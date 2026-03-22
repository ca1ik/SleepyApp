import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleepy_ai/features/challenges/cubit/challenge_state.dart';
import 'package:sleepy_ai/features/challenges/data/challenge_repository.dart';
import 'package:sleepy_ai/features/challenges/domain/challenge_models.dart';

class ChallengeCubit extends Cubit<ChallengeState> {
  ChallengeCubit(this._repository) : super(const ChallengeState());

  final ChallengeRepository _repository;

  void loadChallenges() {
    final challenges = _repository.loadChallenges();
    emit(state.copyWith(
      status: ChallengeStatus.loaded,
      challenges: challenges,
    ));
  }

  Future<void> startChallenge(String id) async {
    final challenges = List<SleepChallenge>.from(state.challenges);
    final idx = challenges.indexWhere((c) => c.id == id);
    if (idx < 0) return;

    challenges[idx] = challenges[idx].copyWith(
      isActive: true,
      startDate: DateTime.now(),
    );
    await _repository.saveChallenges(challenges);
    emit(state.copyWith(challenges: challenges));
  }

  Future<void> checkInToday(String id) async {
    final challenges = List<SleepChallenge>.from(state.challenges);
    final idx = challenges.indexWhere((c) => c.id == id);
    if (idx < 0) return;

    final today = DateTime.now().toIso8601String().substring(0, 10);
    final challenge = challenges[idx];
    if (challenge.checkedDates.contains(today)) return;

    final newDates = [...challenge.checkedDates, today];
    final newCompleted = challenge.completedDays + 1;
    final isDone = newCompleted >= challenge.targetDays;

    challenges[idx] = challenge.copyWith(
      completedDays: newCompleted,
      checkedDates: newDates,
      isCompleted: isDone,
    );
    await _repository.saveChallenges(challenges);
    emit(state.copyWith(challenges: challenges));
  }

  bool hasCheckedToday(String id) {
    final challenge = state.challenges.firstWhere(
      (c) => c.id == id,
      orElse: () => kDefaultChallenges.first,
    );
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return challenge.checkedDates.contains(today);
  }
}
