import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final cookingModeServiceProvider = StateNotifierProvider<CookingModeService, bool>((ref) {
  return CookingModeService();
});

class CookingModeService extends StateNotifier<bool> {
  static const String _storageKey = 'is_cooking_mode_active';

  CookingModeService() : super(false) {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_storageKey) ?? false;
  }

  Future<void> setCookingMode(bool active) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_storageKey, active);
    state = active;
  }
}
