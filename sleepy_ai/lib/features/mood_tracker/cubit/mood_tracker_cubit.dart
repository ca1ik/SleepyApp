import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleepy_ai/features/mood_tracker/cubit/mood_tracker_state.dart';
import 'package:sleepy_ai/features/mood_tracker/data/mood_repository.dart';
import 'package:sleepy_ai/features/mood_tracker/domain/mood_models.dart';

class MoodTrackerCubit extends Cubit<MoodTrackerState> {
  MoodTrackerCubit(this._repository) : super(const MoodTrackerState());

  final MoodRepository _repository;

  void loadMoods() {
    final moods = _repository.loadMoods();
    emit(state.copyWith(
      status: MoodTrackerStatus.loaded,
      moods: moods,
      hasLoggedToday: _repository.hasLoggedToday(),
    ));
  }

  Future<void> addMood(MoodEntry entry) async {
    await _repository.saveMood(entry);
    loadMoods();
  }

  Future<void> deleteMood(String id) async {
    await _repository.deleteMood(id);
    loadMoods();
  }
}
