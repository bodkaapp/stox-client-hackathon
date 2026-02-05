import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../domain/models/notification_item.dart';
import '../viewmodels/notification_viewmodel.dart';

class NotificationListScreen extends ConsumerWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.stoxBackground.withOpacity(0.95),
                border: Border(bottom: BorderSide(color: AppColors.stoxBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildBackButton(context),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.titleNotification, // 通知
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(markAllAsReadProvider);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.stoxPrimary,
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    child: Text(AppLocalizations.of(context)!.actionReadAll), // すべて既読
                  ),
                ],
              ),
            ),
            // List
            Expanded(
              child: notificationsAsync.when(
                data: (notifications) {
                  if (notifications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.noNotifications), // 通知はありません
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              ref.read(addSampleNotificationsProvider);
                            },
                            child: Text(AppLocalizations.of(context)!.actionAddDemoData), // デモデータを追加
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) =>
                        Divider(height: 1, color: AppColors.stoxBorder),
                    itemBuilder: (context, index) {
                      return _NotificationItemView(item: notifications[index]);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.chevron_left, size: 24, color: AppColors.stoxText),
        onPressed: () => context.pop(),
      ),
    );
  }
}

class _NotificationItemView extends ConsumerWidget {
  final NotificationItem item;

  const _NotificationItemView({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine icon and colors based on type
    IconData icon;
    Color iconColor;
    Color iconBg;

    switch (item.type) {
      case 'offer':
        icon = Icons.storefront;
        iconColor = Colors.green.shade600;
        iconBg = Colors.green.shade50;
        break;
      case 'expiry':
        icon = Icons.notification_important;
        iconColor = Colors.red.shade500;
        iconBg = Colors.red.shade50;
        break;
      case 'family':
        icon = Icons.group;
        iconColor = Colors.blue.shade500;
        iconBg = Colors.blue.shade50;
        break;
      case 'menu':
        icon = Icons.restaurant_menu;
        iconColor = Colors.orange.shade500;
        iconBg = Colors.orange.shade50;
        break;
      default:
        icon = Icons.notifications;
        iconColor = AppColors.stoxPrimary;
        iconBg = AppColors.stoxPrimary.withOpacity(0.1);
    }

    // Format time
    String timeStr = _formatTime(context, item.createdAt);

    return InkWell(
      onTap: () {
        if (!item.isRead) {
          ref.read(markAsReadProvider(item.id));
        }
      },
      child: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2D2418)
            : Colors.white,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getTypeLabel(context, item.type),
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold, color: iconColor),
                      ),
                      Text(
                        timeStr,
                        style: const TextStyle(fontSize: 10, color: AppColors.stoxSubText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.body,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.stoxSubText, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!item.isRead)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 18),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.stoxPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getTypeLabel(BuildContext context, String type) {
    switch (type) {
      case 'offer':
        return AppLocalizations.of(context)!.navShopping; // 特売情報 (navShoppingを流用、または適したキーを使用)
      case 'expiry':
        return AppLocalizations.of(context)!.homeExpiringSoon; // 賞味期限
      case 'family':
        return AppLocalizations.of(context)!.categoryUncategorized; // 家族
      case 'menu':
        return AppLocalizations.of(context)!.navMenuPlan; // 献立
      default:
        return AppLocalizations.of(context)!.homeHelpTitle; // お知らせ
    }
  }

  String _formatTime(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    final l10n = AppLocalizations.of(context)!;
    if (diff.inMinutes < 60) {
      return l10n.minutesAgo(diff.inMinutes); // ${diff.inMinutes}分前
    } else if (diff.inHours < 24) {
      return l10n.hoursAgo(diff.inHours); // ${diff.inHours}時間前
    } else if (diff.inDays == 1 && now.day != date.day) {
      return l10n.yesterdayAt(DateFormat('H:mm').format(date)); // 昨日 ${DateFormat('H:mm').format(date)}
    } else if (diff.inDays < 7) {
      return l10n.daysAgo(diff.inDays); // ${diff.inDays}日前
    } else {
      return DateFormat(l10n.shortDateFormat).format(date); // DateFormat('M/d').format(date)
    }
  }
}
