import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleepy_ai/features/level_system/domain/level_models.dart';

abstract class LevelRepository {
  Future<SleepHeroModel> loadHero();
  Future<void> saveHero(SleepHeroModel hero);
}

class LocalLevelRepository implements LevelRepository {
  LocalLevelRepository(this._prefs);

  final SharedPreferences _prefs;
  static const String _heroKey = 'sleep_hero_data';

  @override
  Future<SleepHeroModel> loadHero() async {
    final json = _prefs.getString(_heroKey);
    if (json == null) return const SleepHeroModel();
    try {
      return SleepHeroModel.fromMap(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return const SleepHeroModel();
    }
  }

  @override
  Future<void> saveHero(SleepHeroModel hero) async {
    await _prefs.setString(_heroKey, jsonEncode(hero.toMap()));
  }
}
