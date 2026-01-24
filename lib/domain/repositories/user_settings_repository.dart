import '../models/user_settings.dart';

abstract class UserSettingsRepository {
  Future<UserSettings> get();
  Future<void> save(UserSettings settings);
  Stream<UserSettings> watch();
}
