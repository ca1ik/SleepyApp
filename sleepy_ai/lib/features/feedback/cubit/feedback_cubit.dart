import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleepy_ai/features/feedback/cubit/feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(const FeedbackState());

  void setRating(int rating) => emit(state.copyWith(rating: rating));

  void setMessage(String message) => emit(state.copyWith(message: message));

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emit(state.copyWith(status: FeedbackStatus.loading));
    try {
      // Simulated API call — replace with real endpoint when backend ready
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: FeedbackStatus.submitted));
    } catch (e) {
      emit(state.copyWith(status: FeedbackStatus.error, error: e.toString()));
    }
  }

  void reset() => emit(const FeedbackState());
}
