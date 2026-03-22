import 'package:equatable/equatable.dart';
import 'package:sleepy_ai/features/challenges/domain/challenge_models.dart';

enum ChallengeStatus { initial, loaded }

class ChallengeState extends Equatable {
  const ChallengeState({
    this.status = ChallengeStatus.initial,
    this.challenges = const [],
  });

  final ChallengeStatus status;
  final List<SleepChallenge> challenges;

  List<SleepChallenge> get activeChallenges =>
      challenges.where((c) => c.isActive && !c.isCompleted).toList();

  List<SleepChallenge> get availableChallenges =>
      challenges.where((c) => !c.isActive && !c.isCompleted).toList();

  List<SleepChallenge> get completedChallenges =>
      challenges.where((c) => c.isCompleted).toList();

  int get totalXpEarned =>
      completedChallenges.fold(0, (sum, c) => sum + c.xpReward);

  ChallengeState copyWith({
    ChallengeStatus? status,
    List<SleepChallenge>? challenges,
  }) {
    return ChallengeState(
      status: status ?? this.status,
      challenges: challenges ?? this.challenges,
    );
  }

  @override
  List<Object?> get props => [status, challenges];
}
