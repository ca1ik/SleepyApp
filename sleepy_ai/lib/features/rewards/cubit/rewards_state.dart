import 'package:equatable/equatable.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';

class RewardsState extends Equatable {
  const RewardsState({
    this.badges = const [],
    this.sleepScore = 0,
    this.isLoading = false,
    this.error,
  });

  final List<BadgeModel> badges;
  final int sleepScore;
  final bool isLoading;
  final String? error;

  List<BadgeModel> get earnedBadges => badges.where((b) => b.isEarned).toList();
  List<BadgeModel> get pendingBadges =>
      badges.where((b) => !b.isEarned).toList();

  RewardsState copyWith({
    List<BadgeModel>? badges,
    int? sleepScore,
    bool? isLoading,
    String? error,
  }) {
    return RewardsState(
      badges: badges ?? this.badges,
      sleepScore: sleepScore ?? this.sleepScore,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [badges, sleepScore, isLoading, error];
}
