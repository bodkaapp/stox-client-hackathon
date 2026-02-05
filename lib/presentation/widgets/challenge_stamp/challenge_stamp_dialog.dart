import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/app_colors.dart';
import '../../viewmodels/challenge_stamp_viewmodel.dart';
import '../../../domain/models/challenge_stamp.dart';
import 'challenge_guide_dialog.dart';

class ChallengeStampDialog extends ConsumerWidget {
  const ChallengeStampDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stampsAsync = ref.watch(challengeStampViewModelProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: stampsAsync.when(
        data: (stamps) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9F0),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.stoxPrimary, width: 4),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Column(
                children: [
                  const Text(
                    'チャレンジスタンプ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.stoxText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '全クリアでマスターを目指そう！',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.stoxPrimary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stamp Grid
               Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9, 
                  ),
                  itemCount: stamps.length,
                  itemBuilder: (context, index) {
                    final stamp = stamps[index];
                    return _buildStampItem(context, stamp);
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Close Button
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
                  child: const Text('とじる', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildStampItem(BuildContext context, ChallengeStamp stamp) {
    return GestureDetector(
      onTap: () {
        ChallengeGuideDialog.show(context, stamp.type, stamp.isCompleted);
      },
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: stamp.isCompleted ? AppColors.stoxPrimary : Colors.grey.shade300,
                width: 2,
              ),
              boxShadow: [
                if (stamp.isCompleted)
                  BoxShadow(
                    color: AppColors.stoxPrimary.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  )
              ],
            ),
            child: Center(
              child: stamp.isCompleted
                  ? const Icon(Icons.verified, color: AppColors.stoxPrimary, size: 32)
                  : Text(
                      '${stamp.type.id}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade300,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _shortDescription(stamp.type),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: stamp.isCompleted ? AppColors.stoxText : Colors.grey,
          ),
        ), // Text
      ],
      ),
    );
  }

  // Helper moved to ChallengeType domain logic or kept here for display if needed
  // Using stamp.type.title now
  String _shortDescription(ChallengeType type) {
    return type.title;
  }
}
