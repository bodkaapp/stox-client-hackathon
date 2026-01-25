import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../config/app_colors.dart';

/// Mixin to handle Rewarded Ad logic
mixin AdManagerMixin<T extends StatefulWidget> on State<T> {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  bool _isAdLoading = false;

  /// Load the Rewarded Ad
  /// Call this when the screen initializes or when anticipating user action
  Future<void> loadRewardedAd() async {
    if (_isAdLoading || _isAdLoaded) return;
    
    _isAdLoading = true;
    await RewardedAd.load(
      // Test Rewarded Ad Unit ID
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', 
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          _rewardedAd = ad;
          _isAdLoaded = true;
          _isAdLoading = false;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
          _isAdLoaded = false;
          _isAdLoading = false;
        },
      ),
    );
  }

  /// Show Pre-Ad Dialog, Play Ad, and Show Post-Ad Dialog
  /// Returns true if the user completed the ad flow and earned the reward
  Future<bool> showAdAndExecute({
    required BuildContext context,
    required String preAdTitle,
    required String preAdContent,
    String confirmButtonText = '広告を見て実行する',
    String? postAdMessage,
    VoidCallback? onConsent,
  }) async {
    // 1. Show Pre-Ad Dialog
    final shouldProceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(preAdTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(preAdContent),
        actions: [
          TextButton(
             onPressed: () => Navigator.pop(context, false),
             child: const Text('キャンセル', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
             onPressed: () => Navigator.pop(context, true),
             style: ElevatedButton.styleFrom(backgroundColor: AppColors.stoxPrimary),
             child: Text(confirmButtonText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (shouldProceed != true) return false;

    // Call onConsent callback if provided (to show loading overlay etc.)
    if (onConsent != null) {
      onConsent();
    }

    // 2. Load Ad if not loaded (or reload if expired/used)
    if (!_isAdLoaded) {
      await loadRewardedAd();
      
      // Wait for load with timeout
      int retries = 0;
      while (!_isAdLoaded && retries < 10) { // Wait up to ~5s
        await Future.delayed(const Duration(milliseconds: 500));
        retries++;
      }
    }

    if (!_isAdLoaded || _rewardedAd == null) {
      // Ad failed to load, ask user if they want to proceed anyway or show error?
      // For now, let's just proceed as fail-safe (or maybe we should block?)
      // Given the requirement "Show ad", if ad fails, usually apps let user pass or show error.
      // Let's show error for now to be safe, or just return false.
      // But typically we might want to fail gracefully. 
      // Let's try to proceed to avoid blocking user flow on network error if that's preferred, 
      // but strictly speaking they skipped the ad.
      // Let's show a snackbar and return false for now to encourage ad watching.
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('広告の読み込みに失敗しました。通信環境を確認して再度お試しください。')),
        );
      }
      return false;
    }

    // 3. Show Ad
    final completer = Completer<bool>();
    bool rewardEarned = false;

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
         rewardEarned = true;
      }
    );

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
         ad.dispose();
         _rewardedAd = null;
         _isAdLoaded = false;
         completer.complete(rewardEarned);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
         ad.dispose();
         _rewardedAd = null;
         _isAdLoaded = false;
         completer.complete(false);
      }
    );

    final result = await completer.future;

    if (!result) return false;

    // 4. Show Post-Ad Dialog (if message provided)
    if (postAdMessage != null && mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               const Icon(Icons.check_circle, color: Colors.green, size: 48),
               const SizedBox(height: 16),
               Text(postAdMessage, textAlign: TextAlign.center),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('次へ'),
            )
          ],
        ),
      );
    }

    return true;
  }
}
