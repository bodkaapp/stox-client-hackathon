
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // [NEW]
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_colors.dart';

import '../../domain/models/ingredient.dart';
import '../../presentation/screens/ai_analyzed_stock_screen.dart';
import '../../presentation/viewmodels/challenge_stamp_viewmodel.dart'; // [NEW]

class AccountSettingsScreen extends ConsumerWidget { // Changed to ConsumerWidget
  const AccountSettingsScreen({super.key});

  Future<void> _resetTutorial(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('確認'),
        content: const Text('本当にチュートリアルからやり直しますか？\n現在の状態は一部リセットされる可能性があります。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('やり直す'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_first_launch', true);
      
      if (context.mounted) {
        context.go('/tutorial');
      }
    }
  }

  Future<void> _resetChallengeStamps(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('確認'),
        content: const Text('チャレンジスタンプの獲得状況をすべてリセットしますか？\nこの操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('リセット'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(challengeStampViewModelProvider.notifier).reset();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('チャレンジスタンプをリセットしました')),
        );
      }
    }
  }

  void _openDebugAiResult(BuildContext context) {
    // ... (same as before)
    final mockIngredients = [
      const Ingredient(
        id: 'debug_1',
        name: 'りんご',
        standardName: 'りんご',
        amount: 3,
        unit: '個',
        category: '果物',
        status: IngredientStatus.stock,
      ),
      const Ingredient(
        id: 'debug_2',
        name: '豚肉こま切れ',
        standardName: '豚肉こま切れ',
        amount: 250,
        unit: 'g',
        category: '肉',
        status: IngredientStatus.stock,
      ),
      const Ingredient(
        id: 'debug_3',
        name: '牛乳',
        standardName: '牛乳',
        amount: 1,
        unit: '本',
        category: '乳製品',
        status: IngredientStatus.stock,
      ),
      const Ingredient(
        id: 'debug_4',
        name: '謎の物体X',
        standardName: '謎の物体X',
        amount: 1,
        unit: '個',
        category: 'その他',
        status: IngredientStatus.stock,
      ),
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiAnalyzedStockScreen(
          initialIngredients: mockIngredients,
          location: 'デバッグ用冷蔵庫',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Added WidgetRef ref
    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      appBar: AppBar(
        backgroundColor: AppColors.stoxBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.stoxText),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'アカウント設定',
          style: TextStyle(
            color: AppColors.stoxText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSettingsSection(
            title: 'デバッグ・開発者オプション',
            children: [
              _buildSettingsTile(
                icon: Icons.restart_alt,
                title: 'チュートリアルからやり直す',
                onTap: () => _resetTutorial(context),
                isDestructive: true,
              ),
              _buildSettingsTile(
                icon: Icons.refresh, // New icon
                title: 'チャレンジスタンプをリセット',
                onTap: () => _resetChallengeStamps(context, ref),
                isDestructive: true,
              ),
               _buildSettingsTile(
                icon: Icons.bug_report,
                title: 'AI解析結果画面確認 (Debug)',
                onTap: () => _openDebugAiResult(context),
              ),
              _buildSettingsTile(
                icon: Icons.preview,
                title: 'スプラッシュスクリーン確認',
                onTap: () => context.push('/splash_view'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.stoxSubText,
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border.symmetric(
              horizontal: BorderSide(color: AppColors.stoxBorder),
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColors.stoxText,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : AppColors.stoxText,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.stoxSubText),
      onTap: onTap,
    );
  }
}
