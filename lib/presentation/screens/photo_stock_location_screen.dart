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

class PhotoStockLocationScreen extends ConsumerStatefulWidget {
  final XFile imageFile;

  const PhotoStockLocationScreen({
    super.key,
    required this.imageFile,
  });

  @override
  ConsumerState<PhotoStockLocationScreen> createState() => _PhotoStockLocationScreenState();
}

class _PhotoStockLocationScreenState extends ConsumerState<PhotoStockLocationScreen> {
  final TextEditingController _locationController = TextEditingController();
  String _selectedPreset = '';
  bool _isAnalyzing = false;

  Uint8List? _imageBytes;
  
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;

  final List<String> _presets = [
    '冷蔵庫', '冷凍庫', '野菜室', 'シンク下', 'パントリー', '納戸', '常温保存'
  ];

  @override
  void initState() {
    super.initState();
    _loadImage();
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

  Future<void> _loadRewardedAd() {
     return RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test Rewarded Ad Unit ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          _rewardedAd = ad;
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
          _isAdLoaded = false;
        },
      ),
    );
  }

  Future<void> _analyze() async {
    if (_locationController.text.isEmpty || _imageBytes == null) return;

    // Show Pre-Ad Dialog
    final shouldProceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('AI解析を開始', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('AIがあなたの冷蔵庫を分析します。\n広告を再生することで、この機能を無料でご利用いただけます。'),
        actions: [
          TextButton(
             onPressed: () => Navigator.pop(context, false),
             child: const Text('キャンセル', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
             onPressed: () => Navigator.pop(context, true),
             style: ElevatedButton.styleFrom(backgroundColor: AppColors.stoxPrimary),
             child: const Text('広告を見て解析する', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (shouldProceed != true) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final aiRepo = ref.read(aiRecipeRepositoryProvider);
      
      // Start loading ad and analysis concurrently
      _loadRewardedAd();
      final analysisFuture = aiRepo.analyzeStockImage(_imageBytes!, _locationController.text);

      // Wait for ad to load (with a small delay to ensure callback fires if fast) or timeout
      // In a real app we might want to ensure ad is loaded before showing, or show loading UI.
      // Here we check periodically.
      int retries = 0;
      while (!_isAdLoaded && retries < 20) { // Wait up to ~10s
        await Future.delayed(const Duration(milliseconds: 500));
        retries++;
      }

      if (_isAdLoaded && _rewardedAd != null) {
          _rewardedAd!.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
               // Reward earned, proceed to show results (handled below)
            }
          );
          
          // We need to wait for the ad to close to proceed. 
          // Since show returns void, we use FullScreenContentCallback.
          final completer = Completer<void>();
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
               ad.dispose();
               completer.complete();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
               ad.dispose();
               completer.complete();
            }
          );
          await completer.future;
      }
      
      // Post-Ad Message
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                 Icon(Icons.check_circle, color: Colors.green, size: 48),
                 SizedBox(height: 16),
                 Text('AIの解析がおわりました。\n広告の視聴ありがとうございました。', textAlign: TextAlign.center),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('結果を見る'),
              )
            ],
          ),
        );
      }

      // Ensure analysis is complete
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
           _isAdLoaded = false;
           _rewardedAd = null;
         });
      }

    } catch (e) {
      setState(() {
         _isAnalyzing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $e')),
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
