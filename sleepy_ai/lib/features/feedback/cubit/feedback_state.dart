import 'package:equatable/equatable.dart';

enum FeedbackStatus { idle, loading, submitted, error }

class FeedbackState extends Equatable {
  const FeedbackState({
    this.rating = 0,
    this.message = '',
    this.status = FeedbackStatus.idle,
    this.error,
  });

  final int rating; // 1–5
  final String message;
  final FeedbackStatus status;
  final String? error;

  bool get canSubmit => rating > 0;

  FeedbackState copyWith({
    int? rating,
    String? message,
    FeedbackStatus? status,
    String? error,
  }) {
    return FeedbackState(
      rating: rating ?? this.rating,
      message: message ?? this.message,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [rating, message, status, error];
}
