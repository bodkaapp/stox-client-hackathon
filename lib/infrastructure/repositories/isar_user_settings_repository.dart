import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/user_settings.dart';
import '../../domain/repositories/user_settings_repository.dart';
import '../datasources/isar_database.dart';
import '../datasources/schemas/user_schema.dart';

part 'isar_user_settings_repository.g.dart';

class IsarUserSettingsRepository implements UserSettingsRepository {
  final Isar isar;

  IsarUserSettingsRepository(this.isar);

  @override
  Future<UserSettings> get() async {
    final collection = await isar.userCollections.where().findFirst();
    return collection?.toDomain() ?? 
      const UserSettings(id: 'default', points: 0, adRights: 0, contentWifiOnly: false);
  }

  @override
  Future<void> save(UserSettings settings) async {
    final collection = UserSettingsDomainMapper.fromDomain(settings);
    await isar.writeTxn(() async {
      final existing = await isar.userCollections.where().findFirst();
       if (existing != null) {
        collection.id = existing.id;
      }
      await isar.userCollections.put(collection);
    });
  }

  @override
  Stream<UserSettings> watch() {
    return isar.userCollections.where().watch(fireImmediately: true).map((events) {
       final collection = events.isNotEmpty ? events.first : null;
       return collection?.toDomain() ?? 
         const UserSettings(id: 'default', points: 0, adRights: 0, contentWifiOnly: false);
    });
  }
}

// Mappers
extension UserSettingsMapper on UserCollection {
  UserSettings toDomain() {
    return UserSettings(
      id: originalId,
      points: points,
      adRights: adRights,
      contentWifiOnly: contentWifiOnly,
      myAreaLat: myAreaLat,
      myAreaLng: myAreaLng,
    );
  }
}

extension UserSettingsDomainMapper on UserSettings {
  static UserCollection fromDomain(UserSettings settings) {
    return UserCollection()
      ..originalId = settings.id
      ..points = settings.points
      ..adRights = settings.adRights
      ..contentWifiOnly = settings.contentWifiOnly
      ..myAreaLat = settings.myAreaLat
      ..myAreaLng = settings.myAreaLng;
  }
}

@Riverpod(keepAlive: true)
Future<UserSettingsRepository> userSettingsRepository(UserSettingsRepositoryRef ref) async {
  final isar = await ref.watch(isarDatabaseProvider.future);
  return IsarUserSettingsRepository(isar);
}
