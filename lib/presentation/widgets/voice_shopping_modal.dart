import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../config/app_colors.dart';
import '../../domain/models/ingredient.dart';
import '../../infrastructure/repositories/drift_ingredient_repository.dart';

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
             const SnackBar(content: Text('マイクの権限が必要です')),
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
            if (mounted && !_speechToText.isListening && _isListeningTarget) {
                 Future.delayed(const Duration(milliseconds: 500), () {
                   if (mounted && !_speechToText.isListening && _isListeningTarget) {
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
    if (!_speechEnabled) return;
    
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
      _processRecognizedText(result.recognizedWords);
    }
  }

  Future<void> _processRecognizedText(String text) async {
    final cleanedText = text.trim();
    if (cleanedText.isEmpty) return;

    // Check for exit command
    if (cleanedText.contains('追加終わり') || cleanedText.contains('終了')) { // Flexible matching
      if (mounted) {
         Navigator.pop(context);
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('${_recognizedItems.length}件の操作を完了しました')),
         );
      }
      return;
    }

    // Check for delete command
    // Simple logic: if text ends with "削除" or "消して", assume delete mode for the preceding word
    bool isDelete = false;
    String targetName = cleanedText;

    if (targetName.endsWith('削除')) {
      isDelete = true;
      targetName = targetName.replaceAll('削除', '').trim();
    } else if (targetName.endsWith('消して')) {
      isDelete = true;
      targetName = targetName.replaceAll('消して', '').trim();
    }

    // Split items if multiple (only for add mode mostly, but maybe delete multiple?)
    // "トマトとキャベツを削除" -> tricky. 
    // Let's assume split works first.
    final items = targetName.split(RegExp(r'[と、\s]+')); 
    
    for (var item in items) {
      if (item.trim().isEmpty) continue;
      final name = item.trim();
      
      if (isDelete) {
        await _deleteIngredient(name);
      } else {
        await _addIngredient(name);
      }
    }
    
    // Clear last words for display reset
    setState(() {
      _lastWords = '';
    });
  }

  Future<void> _addIngredient(String name) async {
    final repo = await ref.read(ingredientRepositoryProvider.future);
    
    final newIngredient = Ingredient(
      id: '${DateTime.now().millisecondsSinceEpoch}_${name.hashCode}',
      name: name,
      standardName: name, 
      category: '未分類', 
      unit: '個',
      amount: 1.0,
      status: widget.targetStatus, // Use dynamic status
      storageType: StorageType.fridge,
      purchaseDate: DateTime.now(),
      expiryDate: DateTime.now().add(const Duration(days: 7)),
    );

    await repo.save(newIngredient);
    await repo.incrementInfoUsageCount(name);

    if (mounted) {
      setState(() {
        _recognizedItems.add('$name (追加)');
      });
    }
  }

  Future<void> _deleteIngredient(String name) async {
    final repo = await ref.read(ingredientRepositoryProvider.future);
    final allItems = await repo.getAll();
    
    // Find item with same name and matching status (or any status? usually matching status)
    // If targetStatus is Stock, we only delete from Stock? Or generally by name?
    // Safer to delete only from current view context.
    
    final targets = allItems.where((i) => i.name == name && i.status == widget.targetStatus).toList();

    if (targets.isEmpty) {
      // Maybe nice to show a toast "Not found"
      return;
    }

    // Delete one logic (oldest or just first)
    // Let's delete ALL matching items? Or just one?
    // "Delete apple" usually implies deleting the apple entry. 
    // If multiple apples entries, user might want to delete all or one. 
    // Safe bet: Delete ALL matching name in this context? Or just one?
    // Let's delete ALL for now as it's cleaner than leftover duplicates.
    
    for (var target in targets) {
      await repo.delete(target.id);
    }
    
    if (mounted) {
      setState(() {
        _recognizedItems.add('$name (削除: ${targets.length}件)');
      });
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
                   scale: _isListeningTarget ? _scaleAnimation.value : 1.0,
                   child: Container(
                     width: 80,
                     height: 80,
                     decoration: BoxDecoration(
                       color: _isListeningTarget ? AppColors.stoxPrimary : Colors.grey.shade300,
                       shape: BoxShape.circle,
                       boxShadow: [
                         if (_isListeningTarget)
                           BoxShadow(
                             color: AppColors.stoxPrimary.withOpacity(0.4),
                             blurRadius: 20,
                             spreadRadius: 5,
                           )
                       ],
                     ),
                     child: Icon(
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
             _isListeningTarget ? '聞いています...' : 'タップして開始',
             style: const TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.bold,
               color: AppColors.stoxText,
             ),
           ),
           
           const SizedBox(height: 8),
           
           Text(
             _lastWords.isNotEmpty ? '「$_lastWords」' : '材料名 + 「追加」or「削除」\n「追加終わり」で終了',
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
                     children: const [
                       Icon(Icons.format_list_bulleted, size: 48, color: Colors.black12),
                       SizedBox(height: 8),
                       Text('操作履歴がここに表示されます', style: TextStyle(color: AppColors.stoxSubText, fontSize: 12)),
                     ],
                   ),
                 )
               : ListView.builder(
                   padding: const EdgeInsets.symmetric(horizontal: 24),
                   itemCount: _recognizedItems.length,
                   itemBuilder: (context, index) {
                     // Show latest on top? Or bottom?
                     // Let's reverse display so latest is top
                     final item = _recognizedItems[_recognizedItems.length - 1 - index];
                     return Container(
                       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                       decoration: const BoxDecoration(
                         border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                       ),
                       child: Row(
                         children: [
                           Icon(
                             item.contains('削除') ? Icons.delete_outline : Icons.check_circle, 
                             color: item.contains('削除') ? Colors.red : AppColors.stoxGreen, 
                             size: 20
                           ),
                           const SizedBox(width: 12),
                           Text(
                             item,
                             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                           ),
                           const Spacer(),
                           const Text('完了', style: TextStyle(fontSize: 10, color: AppColors.stoxSubText)),
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
                 child: const Text('閉じる', style: TextStyle(fontWeight: FontWeight.bold)),
               ),
             ),
           ),
        ],
      ),
    );
  }
}
