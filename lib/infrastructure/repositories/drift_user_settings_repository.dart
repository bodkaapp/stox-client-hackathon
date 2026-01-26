import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/user_settings.dart';
import '../../domain/repositories/user_settings_repository.dart';
import '../datasources/app_database.dart';
import '../datasources/drift_database_provider.dart';

part 'drift_user_settings_repository.g.dart';

class DriftUserSettingsRepository implements UserSettingsRepository {
  final AppDatabase db;

  DriftUserSettingsRepository(this.db);

  Future<UserSettingsEntity?> _getEntry() {
    return db.select(db.userSettings).getSingleOrNull();
  }

  @override
  Future<UserSettings> get() async {
    final entity = await _getEntry();
    return entity?.toDomain() ?? 
       const UserSettings(id: 'default', points: 0, adRights: 0, contentWifiOnly: false);
  }

  @override
  Future<void> save(UserSettings settings) async {
    final companion = UserSettingsDomainMapper.fromDomain(settings);
    final existing = await _getEntry();
    
    if (existing != null) {
      await (db.update(db.userSettings)..where((t) => t.id.equals(existing.id))).write(companion);
    } else {
      await db.into(db.userSettings).insert(companion);
    }
  }

  @override
  Stream<UserSettings> watch() {
    return db.select(db.userSettings).watchSingleOrNull().map((entity) {
       return entity?.toDomain() ?? 
         const UserSettings(id: 'default', points: 0, adRights: 0, contentWifiOnly: false);
    });
  }
}

// Mappers
extension UserSettingsEntityMapper on UserSettingsEntity {
  UserSettings toDomain() {
    return UserSettings(
      id: originalId,
      points: points,
      adRights: adRights,
      contentWifiOnly: contentWifiOnly,
      hideAiIngredientRegistrationDialog: hideAiIngredientRegistrationDialog,
      myAreaLat: myAreaLat,
      myAreaLng: myAreaLng,
    );
  }
}

extension UserSettingsDomainMapper on UserSettings {
  static UserSettingsCompanion fromDomain(UserSettings settings) {
    return UserSettingsCompanion(
      originalId: Value(settings.id),
      points: Value(settings.points),
      adRights: Value(settings.adRights),
      contentWifiOnly: Value(settings.contentWifiOnly),
      hideAiIngredientRegistrationDialog: Value(settings.hideAiIngredientRegistrationDialog),
      myAreaLat: Value(settings.myAreaLat),
      myAreaLng: Value(settings.myAreaLng),
    );
  }
}

@Riverpod(keepAlive: true)
Future<UserSettingsRepository> userSettingsRepository(UserSettingsRepositoryRef ref) async {
  final db = ref.watch(driftDatabaseProvider);
  return DriftUserSettingsRepository(db);
}
