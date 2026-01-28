import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/notification_item.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/app_database.dart';
import '../datasources/drift_database_provider.dart';

part 'drift_notification_repository.g.dart';

class DriftNotificationRepository implements NotificationRepository {
  final AppDatabase db;

  DriftNotificationRepository(this.db);

  @override
  Stream<List<NotificationItem>> watchAll() {
    return (db.select(db.notifications)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .watch()
        .map((entities) => entities.map((e) => e.toDomain()).toList());
  }

  @override
  Future<void> markAsRead(int id) async {
    await (db.update(db.notifications)..where((t) => t.id.equals(id))).write(
      NotificationsCompanion(isRead: Value(true)),
    );
  }

  @override
  Future<void> markAllAsRead() async {
    await db.update(db.notifications).write(
      NotificationsCompanion(isRead: Value(true)),
    );
  }

  @override
  Future<void> add(String type, String title, String body, DateTime createdAt) async {
    await db.into(db.notifications).insert(
      NotificationsCompanion.insert(
        type: type,
        title: title,
        body: body,
        createdAt: createdAt,
        isRead: const Value(false),
      ),
    );
  }
}

extension NotificationEntityMapper on NotificationEntity {
  NotificationItem toDomain() {
    return NotificationItem(
      id: id,
      type: type,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead,
    );
  }
}

@Riverpod(keepAlive: true)
Future<NotificationRepository> notificationRepository(NotificationRepositoryRef ref) async {
  final db = ref.watch(driftDatabaseProvider);
  return DriftNotificationRepository(db);
}
