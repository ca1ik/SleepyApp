import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleepy_ai/features/dream_journal/domain/dream_models.dart';

class DreamRepository {
  DreamRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'dream_journal_entries';

  List<DreamEntry> loadDreams() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => DreamEntry.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> saveDream(DreamEntry entry) async {
    final dreams = loadDreams();
    dreams.insert(0, entry);
    await _persist(dreams);
  }

  Future<void> deleteDream(String id) async {
    final dreams = loadDreams()..removeWhere((d) => d.id == id);
    await _persist(dreams);
  }

  Future<void> updateDream(DreamEntry entry) async {
    final dreams = loadDreams();
    final idx = dreams.indexWhere((d) => d.id == entry.id);
    if (idx >= 0) {
      dreams[idx] = entry;
      await _persist(dreams);
    }
  }

  Future<void> _persist(List<DreamEntry> dreams) async {
    final json = jsonEncode(dreams.map((d) => d.toJson()).toList());
    await _prefs.setString(_key, json);
  }
}
