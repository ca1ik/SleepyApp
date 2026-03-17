// ignore_for_file: public_member_api_docs
import 'package:equatable/equatable.dart';
import 'package:sleepy_ai/features/level_system/domain/level_models.dart';

enum LevelStatus { loading, ready, levelingUp, proGateReached }

class LevelState extends Equatable {
  const LevelState({
    this.status = LevelStatus.loading,
    this.hero = const SleepHeroModel(),
    this.previousLevel = 0,
    this.xpGained = 0,
    this.dailyQuests = const [],
  });

  final LevelStatus status;
  final SleepHeroModel hero;

  /// Seviye atlamadan önceki seviye (LevelUpOverlay için)
  final int previousLevel;

  /// Son kazanılan XP miktarı (animasyon trigger için)
  final int xpGained;

  final List<DailyQuest> dailyQuests;

  LevelState copyWith({
    LevelStatus? status,
    SleepHeroModel? hero,
    int? previousLevel,
    int? xpGained,
    List<DailyQuest>? dailyQuests,
  }) =>
      LevelState(
        status: status ?? this.status,
        hero: hero ?? this.hero,
        previousLevel: previousLevel ?? this.previousLevel,
        xpGained: xpGained ?? this.xpGained,
        dailyQuests: dailyQuests ?? this.dailyQuests,
      );

  @override
  List<Object?> get props =>
      [status, hero, previousLevel, xpGained, dailyQuests];
}
