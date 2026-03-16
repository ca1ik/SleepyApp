import 'package:equatable/equatable.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';

class RewardsState extends Equatable {
  const RewardsState({
    this.badges = const [],
    this.sleepScore = 0,
    this.isLoading = false,
    this.error,
    this.gameScores = const [],
    this.watchedFilmIds = const [],
  });

  final List<BadgeModel> badges;
  final int sleepScore;
  final bool isLoading;
  final String? error;
  final List<GameScoreRecord> gameScores;
  final List<String> watchedFilmIds;

  List<BadgeModel> get earnedBadges => badges.where((b) => b.isEarned).toList();
  List<BadgeModel> get pendingBadges =>
      badges.where((b) => !b.isEarned).toList();
  List<BadgeModel> get gameBadges =>
      badges.where((b) => b.category != BadgeCategory.sleep).toList();
  int get totalGameScore => gameScores.fold(0, (s, r) => s + r.score);

  RewardsState copyWith({
    List<BadgeModel>? badges,
    int? sleepScore,
    bool? isLoading,
    String? error,
    List<GameScoreRecord>? gameScores,
    List<String>? watchedFilmIds,
  }) {
    return RewardsState(
      badges: badges ?? this.badges,
      sleepScore: sleepScore ?? this.sleepScore,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      gameScores: gameScores ?? this.gameScores,
      watchedFilmIds: watchedFilmIds ?? this.watchedFilmIds,
    );
  }

  @override
  List<Object?> get props =>
      [badges, sleepScore, isLoading, error, gameScores, watchedFilmIds];
}
