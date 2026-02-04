import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/challenge_stamp.dart';

// Provider
final challengeStampRepositoryProvider = Provider<ChallengeStampRepository>((ref) {
  return ChallengeStampRepositoryImpl();
});

abstract class ChallengeStampRepository {
  Future<List<ChallengeStamp>> loadStamps();
  Future<void> saveStamp(ChallengeStamp stamp);
  Future<void> reset();
}

class ChallengeStampRepositoryImpl implements ChallengeStampRepository {
  static const String _storageKey = 'challenge_stamps_v1';

  @override
  Future<List<ChallengeStamp>> loadStamps() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    // Default: all unchecked
    List<ChallengeStamp> stamps = ChallengeType.values.map((type) => ChallengeStamp(type: type)).toList();

    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        final Map<int, ChallengeStamp> loadedMap = {
          for (var item in jsonList) 
            item['id']: ChallengeStamp.fromJson(item)
        };

        // Merge loaded data with defaults (preserving order or handling new types if added later)
        stamps = stamps.map((defaultStamp) {
          if (loadedMap.containsKey(defaultStamp.type.id)) {
            return loadedMap[defaultStamp.type.id]!;
          }
          return defaultStamp;
        }).toList();

      } catch (e) {
        // Fallback to default if parse error
      }
    }
    
    return stamps;
  }

  @override
  Future<void> saveStamp(ChallengeStamp updatedStamp) async {
    final prefs = await SharedPreferences.getInstance();
    // Load current state first to ensure we have the full list
    List<ChallengeStamp> currentStamps = await loadStamps();

    // Update the specific stamp
    final index = currentStamps.indexWhere((s) => s.type.id == updatedStamp.type.id);
    if (index != -1) {
      currentStamps[index] = updatedStamp;
    }

    // Save back
    final jsonList = currentStamps.map((s) => s.toJson()).toList();
    await prefs.setString(_storageKey, json.encode(jsonList));
  }

  @override
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
