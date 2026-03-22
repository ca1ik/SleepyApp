import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleepy_ai/features/challenges/domain/challenge_models.dart';

class ChallengeRepository {
  ChallengeRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'sleep_challenges';

  List<SleepChallenge> loadChallenges() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return kDefaultChallenges;
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => SleepChallenge.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveChallenges(List<SleepChallenge> challenges) async {
    final json = jsonEncode(challenges.map((c) => c.toJson()).toList());
    await _prefs.setString(_key, json);
  }
}
