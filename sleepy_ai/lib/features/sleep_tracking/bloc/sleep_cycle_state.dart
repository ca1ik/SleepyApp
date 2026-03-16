import 'package:equatable/equatable.dart';
import 'package:sleepy_ai/shared/models/entities.dart';

abstract class SleepCycleState extends Equatable {
  const SleepCycleState();

  @override
  List<Object?> get props => [];
}

class SleepInitial extends SleepCycleState {
  const SleepInitial();
}

class SleepLoading extends SleepCycleState {
  const SleepLoading();
}

class SleepHistoryLoaded extends SleepCycleState {
  const SleepHistoryLoaded({
    required this.records,
    required this.weeklyAverage,
    required this.sleepScore,
    required this.sleepDebt,
    required this.goalHours,
    this.trackingStartedAt,
  });

  final List<SleepEntity> records;
  final double weeklyAverage; // saat
  final int sleepScore; // 0-100
  final double sleepDebt; // saat (birikmiş)
  final double goalHours;
  final DateTime? trackingStartedAt;

  bool get isTracking => trackingStartedAt != null;

  SleepHistoryLoaded copyWith({
    List<SleepEntity>? records,
    double? weeklyAverage,
    int? sleepScore,
    double? sleepDebt,
    double? goalHours,
    DateTime? trackingStartedAt,
    bool clearTracking = false,
  }) {
    return SleepHistoryLoaded(
      records: records ?? this.records,
      weeklyAverage: weeklyAverage ?? this.weeklyAverage,
      sleepScore: sleepScore ?? this.sleepScore,
      sleepDebt: sleepDebt ?? this.sleepDebt,
      goalHours: goalHours ?? this.goalHours,
      trackingStartedAt: clearTracking
          ? null
          : (trackingStartedAt ?? this.trackingStartedAt),
    );
  }

  @override
  List<Object?> get props => [
    records,
    weeklyAverage,
    sleepScore,
    sleepDebt,
    goalHours,
    trackingStartedAt,
  ];
}

class SleepRecordSaved extends SleepCycleState {
  const SleepRecordSaved(this.record);
  final SleepEntity record;

  @override
  List<Object?> get props => [record];
}

class SleepError extends SleepCycleState {
  const SleepError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
