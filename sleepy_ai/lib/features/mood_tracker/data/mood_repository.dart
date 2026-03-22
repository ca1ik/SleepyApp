import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleepy_ai/features/mood_tracker/domain/mood_models.dart';

class MoodRepository {
  MoodRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'mood_tracker_entries';

  List<MoodEntry> loadMoods() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => MoodEntry.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> saveMood(MoodEntry entry) async {
    final moods = loadMoods();
    moods.insert(0, entry);
    await _persist(moods);
  }

  Future<void> deleteMood(String id) async {
    final moods = loadMoods()..removeWhere((m) => m.id == id);
    await _persist(moods);
  }

  bool hasLoggedToday() {
    final moods = loadMoods();
    if (moods.isEmpty) return false;
    final now = DateTime.now();
    return moods.first.date.year == now.year &&
        moods.first.date.month == now.month &&
        moods.first.date.day == now.day;
  }

  Future<void> _persist(List<MoodEntry> moods) async {
    final json = jsonEncode(moods.map((m) => m.toJson()).toList());
    await _prefs.setString(_key, json);
  }
}
