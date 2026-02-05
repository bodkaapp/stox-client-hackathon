import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../config/app_colors.dart';
import '../../domain/models/ingredient.dart';
import '../../infrastructure/repositories/drift_ingredient_repository.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';

class VoiceShoppingModal extends ConsumerStatefulWidget {
  final IngredientStatus targetStatus;

  const VoiceShoppingModal({
    super.key,
    this.targetStatus = IngredientStatus.toBuy, // Default for backward compatibility
  });

  @override
  ConsumerState<VoiceShoppingModal> createState() => _VoiceShoppingModalState();
}

class _VoiceShoppingModalState extends ConsumerState<VoiceShoppingModal> with SingleTickerProviderStateMixin {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  final List<String> _recognizedItems = [];
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _isListeningTarget = false; // To mask the gap between restarts
  bool _isAnalyzing = false; // New: Analyzing state

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _initSpeech();
  }

  /// Initialize speech recognition
  void _initSpeech() async {
    // Check permission manually first for better UX
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(AppLocalizations.of(context)!.voicePermissionError)),
           );
           Navigator.pop(context);
        }
        return;
      }
    }

    _speechEnabled = await _speechToText.initialize(
      onError: (e) {
        debugPrint("Speech Error: $e");
        if (mounted && _isListeningTarget) {
          // Restart listening on error if appropriate, or show msg
          // For simple errors like 'no match', we might want to restart
          // But strict error handling for now.
          _startListening();
        }
      },
      onStatus: (status) {
        debugPrint("Speech Status: $status");
        if (status == 'done' || status == 'notListening') {
             // Often we want to restart listening if we are not finished
             // But let's check if we explicitly stopped.
             // If we want continuous loop:
            if (mounted && !_speechToText.isListening && _isListeningTarget && !_isAnalyzing) {
                 Future.delayed(const Duration(milliseconds: 500), () {
                   if (mounted && !_speechToText.isListening && _isListeningTarget && !_isAnalyzing) {
                     _startListening();
                   }
                });
            }
        }
      }
    );
    
    if (mounted) {
      setState(() {});
    }
    
    if (_speechEnabled) {
      _startListening();
    }
  }

  /// Start listening
  void _startListening() async {
    if (!_speechEnabled || _isAnalyzing) return;
    
    setState(() {
      _isListeningTarget = true;
    });

    try {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: 'ja_JP',
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 2), // Reduced for faster response
        partialResults: true,
        cancelOnError: false, 
        listenMode: ListenMode.confirmation,
      );
    } catch(e) {
      debugPrint("Start Listening Error: $e");
    }
    
    if (mounted) setState(() {});
  }

  /// Stop listening manually
  void _stopListening() async {
    setState(() {
      _isListeningTarget = false;
    });
    await _speechToText.stop();
    if (mounted) setState(() {});
  }

  /// Callback on speech result
  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) return;
    
    setState(() {
      _lastWords = result.recognizedWords;
    });

    if (result.finalResult) {
      // Pause listening while analyzing
      _speechToText.stop(); 
      _processRecognizedText(result.recognizedWords);
    }
  }

  Future<void> _processRecognizedText(String text) async {
    final cleanedText = text.trim();
    if (cleanedText.isEmpty) {
        if (_isListeningTarget) _startListening();
        return;
    }

    // Check for exit command
    if (cleanedText.contains('追加終わり') || cleanedText.contains('終了')) { // Flexible matching
      if (mounted) {
         Navigator.pop(context);
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(AppLocalizations.of(context)!.voiceCompleteMessage(_recognizedItems.length))),
         );
      }
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      // Call Gemini for parsing
      final aiRepo = ref.read(aiRecipeRepositoryProvider);
      final ingredients = await aiRepo.parseShoppingList(cleanedText);

      if (ingredients.isNotEmpty) {
        // Save parsed ingredients
        final repo = await ref.read(ingredientRepositoryProvider.future);
        
        for (final item in ingredients) {
          final newItem = item.copyWith(
            status: widget.targetStatus,
            // ID needs to be unique if AI didn't ensure it (it doesn't fully)
            id: '${DateTime.now().millisecondsSinceEpoch}_${item.name.hashCode}',
          );
          
          await repo.save(newItem);
          await repo.incrementInfoUsageCount(newItem.name);
          
          if (mounted) {
            setState(() {
              _recognizedItems.add('${newItem.name} (${newItem.category})');
            });
          }
        }
      } else {
         // Fallback or empty result
         if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.voiceAiError)),
             );
         }
      }

    } catch (e) {
      debugPrint("AI Processing Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _lastWords = ''; // Reset display text
        });
        
        // Resume listening if still active
        if (_isListeningTarget) {
          _startListening();
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.6, // Use 60% of screen height
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
         boxShadow: [
           BoxShadow(color: Colors.black12, blurRadius: 40, offset: Offset(0, -8))
        ],
      ),
      child: Column(
        children: [
           const SizedBox(height: 16), // Reduced from 24
           
           // Listening Indicator
           GestureDetector(
             onTap: _isListeningTarget ? _stopListening : _startListening,
             child: AnimatedBuilder(
               animation: _scaleAnimation,
               builder: (context, child) {
                 return Transform.scale(
                   scale: (_isListeningTarget && !_isAnalyzing) ? _scaleAnimation.value : 1.0,
                   child: Container(
                     width: 80,
                     height: 80,
                     decoration: BoxDecoration(
                       color: _isAnalyzing 
                           ? AppColors.stoxAccent // Different color for analyzing
                           : (_isListeningTarget ? AppColors.stoxPrimary : Colors.grey.shade300),
                       shape: BoxShape.circle,
                       boxShadow: [
                         if (_isListeningTarget || _isAnalyzing)
                           BoxShadow(
                             color: (_isAnalyzing ? AppColors.stoxAccent : AppColors.stoxPrimary).withOpacity(0.4),
                             blurRadius: 20,
                             spreadRadius: 5,
                           )
                       ],
                     ),
                     child: _isAnalyzing
                         ? const Center(child: CircularProgressIndicator(color: Colors.white))
                         : Icon(
                           _isListeningTarget ? Icons.mic : Icons.mic_off,
                           color: Colors.white,
                           size: 40,
                         ),
                   ),
                 );
               },
             ),
           ),
           
           const SizedBox(height: 16), // Reduced from 24
           
           Text(
              _isAnalyzing 
                  ? AppLocalizations.of(context)!.voiceAnalyzing 
                  : (_isListeningTarget ? AppLocalizations.of(context)!.voiceListening : AppLocalizations.of(context)!.voiceTapToStart),
             style: TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.bold,
               color: _isAnalyzing ? AppColors.stoxAccent : AppColors.stoxText,
             ),
           ),
           
           const SizedBox(height: 8),
           
           Text(
              _lastWords.isNotEmpty ? '「$_lastWords」' : AppLocalizations.of(context)!.voiceHint,
             textAlign: TextAlign.center,
             style: const TextStyle(
               fontSize: 14,
               color: AppColors.stoxSubText,
             ),
           ),
           
           const SizedBox(height: 16), // Reduced from 24
           
           const Divider(),
           
           // List of recognized items
           Expanded(
             child: _recognizedItems.isEmpty 
               ? Center(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       const Icon(Icons.format_list_bulleted, size: 48, color: Colors.black12),
                       const SizedBox(height: 8),
                        Text(AppLocalizations.of(context)!.voiceHistoryPlaceholder, style: const TextStyle(color: AppColors.stoxSubText, fontSize: 12)),
                     ],
                   ),
                 )
               : ListView.builder(
                   padding: const EdgeInsets.symmetric(horizontal: 24),
                   itemCount: _recognizedItems.length,
                   itemBuilder: (context, index) {
                     // Show latest on top
                     final item = _recognizedItems[_recognizedItems.length - 1 - index];
                     return Container(
                       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                       decoration: const BoxDecoration(
                         border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                       ),
                       child: Row(
                         children: [
                           const Icon(
                             Icons.check_circle, 
                             color: AppColors.stoxGreen, 
                             size: 20
                           ),
                           const SizedBox(width: 12),
                           Expanded(
                             child: Text(
                               item,
                               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                             ),
                           ),
                            Text(AppLocalizations.of(context)!.voiceAdded, style: const TextStyle(fontSize: 10, color: AppColors.stoxSubText)),
                         ],
                       ),
                     );
                   },
                 ),
           ),
           
           // Manual Close Button
           Padding(
             padding: const EdgeInsets.all(16.0), // Reduced from 24.0
             child: SizedBox(
               width: double.infinity,
               child: ElevatedButton(
                 onPressed: () => Navigator.pop(context),
                 style: ElevatedButton.styleFrom(
                   backgroundColor: AppColors.stoxBackground,
                   foregroundColor: AppColors.stoxText,
                   elevation: 0,
                   side: const BorderSide(color: AppColors.stoxBorder),
                   padding: const EdgeInsets.symmetric(vertical: 16),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                 ),
                  child: Text(AppLocalizations.of(context)!.voiceClose, style: const TextStyle(fontWeight: FontWeight.bold)),
               ),
             ),
           ),
        ],
      ),
    );
  }
}
