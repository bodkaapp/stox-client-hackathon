import '../models/notification_item.dart';

abstract class NotificationRepository {
  Stream<List<NotificationItem>> watchAll();
  Future<void> markAsRead(int id);
  Future<void> markAllAsRead();
  Future<void> add(String type, String title, String body, DateTime createdAt);
}
