import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart'; // Optional: Can assume lottie isn't added yet, so stick to standard animations or emojis
import '../../../config/app_colors.dart';
import '../../../domain/models/challenge_stamp.dart';

class CongratulationDialog extends StatefulWidget {
  final ChallengeType challengeType;

  const CongratulationDialog({super.key, required this.challengeType});

  static Future<void> show(BuildContext context, ChallengeType type) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // User must interact to dismiss
      builder: (context) => CongratulationDialog(challengeType: type),
    );
  }

  @override
  State<CongratulationDialog> createState() => _CongratulationDialogState();
}

class _CongratulationDialogState extends State<CongratulationDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.stoxPrimary, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ぱんぱかぱーん🎉',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.stoxPrimary,
                ),
              ),
              const SizedBox(height: 16),
              const Icon(
                Icons.emoji_events,
                size: 80,
                color: Color(0xFFFFD700), // Gold
              ),
              const SizedBox(height: 16),
              const Text(
                'おめでとうございます！',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.stoxText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (widget.challengeType == ChallengeType.tutorial) ...[
                 const Text(
                  '１つめのチャレンジクリアです！',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.stoxSubText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                 Text(
                  'チャレンジ「${_getChallengeName(widget.challengeType)}」\nクリアです！',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.stoxSubText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.stoxPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('やったー！', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getChallengeName(ChallengeType type) {
    switch (type) {
      case ChallengeType.tutorial: return '冷蔵庫撮影';
      case ChallengeType.scheduleRecipe: return '献立登録';
      case ChallengeType.searchRecipe: return 'レシピ検索';
      case ChallengeType.extractIngredients: return '材料抽出';
      case ChallengeType.shoppingComplete: return 'お買い物';
      case ChallengeType.scanReceipt: return 'レシート登録';
      case ChallengeType.cookAndPhoto: return '料理撮影';
    }
  }
}
