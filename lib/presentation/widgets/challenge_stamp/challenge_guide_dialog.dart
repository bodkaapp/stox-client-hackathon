import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import '../../../domain/models/challenge_stamp.dart';

class ChallengeGuideDialog extends StatelessWidget {
  final ChallengeType challenge;
  final bool isCompleted;

  const ChallengeGuideDialog({
    super.key,
    required this.challenge,
    required this.isCompleted,
  });

  static Future<void> show(BuildContext context, ChallengeType challenge, bool isCompleted) async {
    await showDialog(
      context: context,
      // backgroundColor: Colors.transparent, // Invalid param for showDialog
      builder: (context) => ChallengeGuideDialog(challenge: challenge, isCompleted: isCompleted),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.stoxPrimary, width: 4),
          boxShadow: [
             BoxShadow(
               color: Colors.black.withOpacity(0.2),
               blurRadius: 10,
               offset: const Offset(0, 4),
             )
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Icon + Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.stoxPrimary : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.verified : Icons.lock_outline,
                    color: isCompleted ? Colors.white : Colors.grey,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Challenge ${challenge.id}',
                        style: TextStyle(
                          color: AppColors.stoxPrimary.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        challenge.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.stoxText,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  const Chip(
                    label: Text('CLEAR!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                    backgroundColor: AppColors.stoxPrimary,
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Goal Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9F0), // Light orange bg
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.stoxBorder),
              ),
              child: Column(
                children: [
                   const Text('GOAL', style: TextStyle(color: AppColors.stoxPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                   const SizedBox(height: 8),
                   Text(
                     challenge.goal,
                     textAlign: TextAlign.center,
                     style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.stoxText),
                   ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Steps
            const Text(
              'クリア手順',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.stoxSubText),
            ),
            const SizedBox(height: 12),
            ...challenge.guideSteps.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final text = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.stoxPrimary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$index',
                        style: const TextStyle(
                          color: AppColors.stoxPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(fontSize: 14, color: AppColors.stoxText, height: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),
            
            // Close Button
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.stoxPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
