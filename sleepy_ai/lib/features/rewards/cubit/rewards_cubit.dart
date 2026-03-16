import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleepy_ai/features/rewards/cubit/rewards_state.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';

class RewardsCubit extends Cubit<RewardsState> {
  RewardsCubit() : super(const RewardsState());

  /// Uyku skoruna göre rozetleri değerlendir
  void evaluateBadges({required int currentSleepScore}) {
    final updated = state.badges.map((badge) {
      if (badge.category != BadgeCategory.sleep) return badge;
      final earned = currentSleepScore >= badge.requiredScore;
      return badge.copyWith(
        isEarned: earned,
        earnedAt: earned && !badge.isEarned ? DateTime.now() : badge.earnedAt,
      );
    }).toList();
    emit(state.copyWith(badges: updated, sleepScore: currentSleepScore));
  }

  /// İlk yüklemede static veriyle init et
  void loadBadges() {
    emit(state.copyWith(isLoading: true));
    Future.delayed(const Duration(milliseconds: 300), () {
      if (isClosed) return;
      emit(state.copyWith(badges: kDefaultBadges, isLoading: false));
    });
  }

  /// Oyun rozeti kilidi aç
  void unlockBadge(BadgeType type) {
    final updated = _unlock(state.badges, type);
    emit(state.copyWith(badges: updated));
  }

  /// Oyun skoru kaydet + otomatik rozet kontrolü
  void recordGameScore(GameScoreRecord record) {
    final scores = List<GameScoreRecord>.from(state.gameScores)..add(record);
    final totalScore = scores.fold<int>(0, (s, r) => s + r.score);
    var badges = state.badges;

    // Galaksi Gezgini: üç oyunun hepsini oynamış mı?
    final playedGames = scores.map((s) => s.gameId).toSet();
    if (playedGames.containsAll(['breathing', 'star_catcher', 'galaxy'])) {
      badges = _unlock(badges, BadgeType.galaxyExplorer);
    }

    // Uyku Bilgesi: toplam 500+ puan
    if (totalScore >= 500) {
      badges = _unlock(badges, BadgeType.sleepSage);
    }

    emit(state.copyWith(badges: badges, gameScores: scores));
  }

  /// Film izlendi — rozet kontrolü
  void recordFilmWatched(String filmId) {
    final watched = List<String>.from(state.watchedFilmIds);
    if (!watched.contains(filmId)) watched.add(filmId);
    var badges = state.badges;
    if (watched.length >= 3) {
      badges = _unlock(badges, BadgeType.dreamWeaver);
    }
    emit(state.copyWith(badges: badges, watchedFilmIds: watched));
  }

  List<BadgeModel> _unlock(List<BadgeModel> badges, BadgeType type) {
    return badges.map((b) {
      if (b.type == type && !b.isEarned) {
        return b.copyWith(isEarned: true, earnedAt: DateTime.now());
      }
      return b;
    }).toList();
  }
}
