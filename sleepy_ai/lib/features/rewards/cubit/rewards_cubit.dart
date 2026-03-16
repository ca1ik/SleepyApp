import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleepy_ai/features/rewards/cubit/rewards_state.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';

class RewardsCubit extends Cubit<RewardsState> {
  RewardsCubit() : super(const RewardsState());

  /// Mevcut uyku skoru ile rozetleri değerlendir
  void evaluateBadges({required int currentSleepScore}) {
    final updated = kDefaultBadges.map((badge) {
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
    // Simulate async load
    Future.delayed(const Duration(milliseconds: 300), () {
      emit(state.copyWith(badges: kDefaultBadges, isLoading: false));
    });
  }
}
