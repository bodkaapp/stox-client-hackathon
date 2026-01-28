import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/notification_item.dart';
import '../../infrastructure/repositories/drift_notification_repository.dart';

part 'notification_viewmodel.g.dart';

@riverpod
Stream<List<NotificationItem>> notificationStream(NotificationStreamRef ref) async* {
  final repo = await ref.watch(notificationRepositoryProvider.future);
  yield* repo.watchAll();
}

@riverpod
Future<void> markAllAsRead(MarkAllAsReadRef ref) async {
  final repo = await ref.watch(notificationRepositoryProvider.future);
  await repo.markAllAsRead();
}

@riverpod
Future<void> markAsRead(MarkAsReadRef ref, int id) async {
  final repo = await ref.watch(notificationRepositoryProvider.future);
  await repo.markAsRead(id);
}

@riverpod
Future<void> addSampleNotifications(AddSampleNotificationsRef ref) async {
  final repo = await ref.watch(notificationRepositoryProvider.future);
  final now = DateTime.now();
  await repo.add('offer', 'ライフのチラシが更新されました', '本日からの特売品に「鶏むね肉」が含まれています。買い物リストをチェックしましょう。', now.subtract(const Duration(minutes: 10)));
  await repo.add('expiry', '卵の期限があと1日です', '冷蔵庫の「卵」が明日、賞味期限を迎えます。今日の献立に使いませんか？', now.subtract(const Duration(hours: 1)));
  await repo.add('family', 'パパが買い物リストに「牛乳」を追加しました', '「牛乳」が買い物リスト（近所のスーパー）に追加されました。', now.subtract(const Duration(hours: 3)));
  await repo.add('menu', '明日の献立が決まっていません', '在庫の「じゃがいも」と「玉ねぎ」を使ったおすすめレシピがあります。', now.subtract(const Duration(days: 1, hours: 5, minutes: 30)));
  await repo.add('expiry', '納豆の期限があと2日です', '賞味期限が近づいています。朝食などにいかがでしょうか。', now.subtract(const Duration(days: 1, hours: 14)));
}
