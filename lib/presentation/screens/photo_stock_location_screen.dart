import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/app_colors.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';
import '../../domain/models/ingredient.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ai_analyzed_stock_screen.dart';
import '../mixins/ad_manager_mixin.dart';

class PhotoStockLocationScreen extends ConsumerStatefulWidget {
  final XFile imageFile;

  const PhotoStockLocationScreen({
    super.key,
    required this.imageFile,
  });

  @override
  ConsumerState<PhotoStockLocationScreen> createState() => _PhotoStockLocationScreenState();
}

class _PhotoStockLocationScreenState extends ConsumerState<PhotoStockLocationScreen> with AdManagerMixin {
  final TextEditingController _locationController = TextEditingController();
  String _selectedPreset = '';
  bool _isAnalyzing = false;

  Uint8List? _imageBytes;
  
  final List<String> _presets = [
    '冷蔵庫', '冷凍庫', '野菜室', 'シンク下', 'パントリー', '納戸', '常温保存'
  ];

  @override
  void initState() {
    super.initState();
    _loadImage();
    loadRewardedAd(); // Preload ad
  }

  Future<void> _loadImage() async {
    final bytes = await widget.imageFile.readAsBytes();
    setState(() {
      _imageBytes = bytes;
    });
  }

  void _onPresetSelected(String location) {
    setState(() {
      _selectedPreset = location;
      _locationController.text = location;
    });
  }

  Future<void> _analyze() async {
    if (_locationController.text.isEmpty || _imageBytes == null) return;

    final success = await showAdAndExecute(
      context: context,
      preAdTitle: 'AI解析を開始',
      preAdContent: 'AIがあなたの冷蔵庫を分析します。\n広告を再生することで、この機能を無料でご利用いただけます。',
      confirmButtonText: '広告を見て解析する',
      postAdMessage: 'AIの解析がおわりました。\n広告の視聴ありがとうございました。',
      onConsent: () {
        setState(() {
          _isAnalyzing = true;
        });
      },
    );

    if (!success) {
      setState(() {
        _isAnalyzing = false;
      });
      return;
    } 
    // _isAnalyzing is already true from onConsent, keep it true for analysis
    // Actually if success is true, we proceed. If false (ad fail), we already set it false in the check above?
    // Wait, if showAdAndExecute returns false (ad failed), we need to make sure _isAnalyzing is set back to false if we set it to true in onConsent.
    // Yes, added setState check.

    // setState(() {
    //   _isAnalyzing = true; 
    // }); // Already done in onConsent

    try {
      final aiRepo = ref.read(aiRecipeRepositoryProvider);
      
      final analysisFuture = aiRepo.analyzeStockImage(
        _imageBytes!, 
        _locationController.text,
        mimeType: widget.imageFile.mimeType,
      );

      final ingredients = await analysisFuture;
    
      if (!mounted) return;

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AiAnalyzedStockScreen(
            initialIngredients: ingredients,
            location: _locationController.text,
            imageBytes: _imageBytes,
          ),
        ),
      );

      if (result == true && mounted) {
        Navigator.pop(context, true); 
      } else {
         setState(() {
           _isAnalyzing = false;
         });
      }

    } catch (e) {
      debugPrint('AI Analysis Error: $e');
      setState(() {
         _isAnalyzing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラーが発生しました: $e'),
            duration: const Duration(seconds: 10),
            action: SnackBarAction(
              label: '閉じる',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      appBar: AppBar(
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 16, color: AppColors.stoxPrimary),
          label: const Text('やり直す', style: TextStyle(color: AppColors.stoxPrimary, fontWeight: FontWeight.bold)),
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
        ),
        leadingWidth: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Preview
                  if (_imageBytes != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.memory(
                        _imageBytes!,
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(height: 240, color: Colors.grey[200]),

                  const SizedBox(height: 24),

                  // Location Input
                  const Text('撮影した保管場所を入力', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: '例: 食品庫',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Presets
                  const Text('候補から選択', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.stoxSubText)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _presets.map((preset) {
                      final isSelected = _selectedPreset == preset;
                      return ChoiceChip(
                        label: Text(preset),
                        selected: isSelected,
                        onSelected: (_) => _onPresetSelected(preset),
                        backgroundColor: Colors.white,
                        selectedColor: AppColors.stoxPrimary.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.stoxPrimary : AppColors.stoxText,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.stoxPrimary : AppColors.stoxBorder,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 48),

                  ElevatedButton(
                    onPressed: _isAnalyzing ? null : _analyze,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.stoxPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('決定', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
            ),
             if (_isAnalyzing)
               Container(
                 color: Colors.black87,
                 padding: const EdgeInsets.symmetric(horizontal: 32),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const CircularProgressIndicator(color: AppColors.stoxPrimary),
                     const SizedBox(height: 24),
                     Text(
                       'AIがあなたの${_locationController.text}を分析しています。\n解析が終わるまで広告をご覧ください。',
                       textAlign: TextAlign.center,
                       style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                     ),
                   ],
                 ),
               ),
          ],
        ),
      ),
    );
  }
}
