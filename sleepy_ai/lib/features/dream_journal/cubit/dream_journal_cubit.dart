import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleepy_ai/features/dream_journal/cubit/dream_journal_state.dart';
import 'package:sleepy_ai/features/dream_journal/data/dream_repository.dart';
import 'package:sleepy_ai/features/dream_journal/domain/dream_models.dart';

class DreamJournalCubit extends Cubit<DreamJournalState> {
  DreamJournalCubit(this._repository) : super(const DreamJournalState());

  final DreamRepository _repository;

  void loadDreams() {
    final dreams = _repository.loadDreams();
    emit(state.copyWith(
      status: DreamJournalStatus.loaded,
      dreams: dreams,
    ));
  }

  Future<void> addDream(DreamEntry entry) async {
    emit(state.copyWith(status: DreamJournalStatus.saving));
    await _repository.saveDream(entry);
    loadDreams();
  }

  Future<void> deleteDream(String id) async {
    await _repository.deleteDream(id);
    loadDreams();
  }

  Future<void> updateDream(DreamEntry entry) async {
    await _repository.updateDream(entry);
    loadDreams();
  }

  void setFilter(DreamEmotion? emotion) {
    emit(state.copyWith(filterEmotion: () => emotion));
  }
}
