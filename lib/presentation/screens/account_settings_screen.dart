
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_colors.dart';

class AccountSettingsScreen extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
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
