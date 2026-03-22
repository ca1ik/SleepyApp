import 'package:equatable/equatable.dart';
import 'package:sleepy_ai/features/mood_tracker/domain/mood_models.dart';

enum MoodTrackerStatus { initial, loaded }

class MoodTrackerState extends Equatable {
  const MoodTrackerState({
    this.status = MoodTrackerStatus.initial,
    this.moods = const [],
    this.hasLoggedToday = false,
  });

  final MoodTrackerStatus status;
  final List<MoodEntry> moods;
  final bool hasLoggedToday;

  double get averageMood {
    if (moods.isEmpty) return 0;
    final last7 = moods.take(7);
    return last7.map((m) => m.mood.score).reduce((a, b) => a + b) /
        last7.length;
  }

  int get currentStreak {
    if (moods.isEmpty) return 0;
    int streak = 0;
    DateTime check = DateTime.now();
    for (final m in moods) {
      if (m.date.year == check.year &&
          m.date.month == check.month &&
          m.date.day == check.day) {
        streak++;
        check = check.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  MoodTrackerState copyWith({
    MoodTrackerStatus? status,
    List<MoodEntry>? moods,
    bool? hasLoggedToday,
  }) {
    return MoodTrackerState(
      status: status ?? this.status,
      moods: moods ?? this.moods,
      hasLoggedToday: hasLoggedToday ?? this.hasLoggedToday,
    );
  }

  @override
  List<Object?> get props => [status, moods, hasLoggedToday];
}
