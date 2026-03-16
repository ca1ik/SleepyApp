import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleepy_ai/core/utils/sleep_duration_calculator.dart';
import 'package:sleepy_ai/features/sleep_tracking/bloc/sleep_cycle_event.dart';
import 'package:sleepy_ai/features/sleep_tracking/bloc/sleep_cycle_state.dart';
import 'package:sleepy_ai/features/sleep_tracking/data/sleep_repository.dart';
import 'package:sleepy_ai/shared/models/entities.dart';
import 'package:uuid/uuid.dart';

class SleepCycleBloc extends Bloc<SleepCycleEvent, SleepCycleState> {
  SleepCycleBloc({required this.repository}) : super(const SleepInitial()) {
    on<LoadSleepHistory>(_onLoadSleepHistory);
    on<SaveSleepRecord>(_onSaveSleepRecord);
    on<UpdateSleepGoal>(_onUpdateSleepGoal);
    on<DeleteSleepRecord>(_onDeleteSleepRecord);
    on<StartSleepTracking>(_onStartSleepTracking);
    on<StopSleepTracking>(_onStopSleepTracking);
    on<UpdateBedtimeSchedule>(_onUpdateBedtimeSchedule);
  }

  final SleepRepository repository;
  final _uuid = const Uuid();

  Future<void> _onLoadSleepHistory(
    LoadSleepHistory event,
    Emitter<SleepCycleState> emit,
  ) async {
    emit(const SleepLoading());
    final result = await repository.getLast7DaysRecords();
    result.fold((failure) => emit(SleepError(failure.message)), (records) {
      final goalHours = repository.getSleepGoalHours();
      final weeklyAvg = SleepDurationCalculator.weeklyAverageHours(records);
      final score = SleepDurationCalculator.calculateQualityScore(
        records.isNotEmpty ? records.first : null,
        goalHours,
      );
      final debt = SleepDurationCalculator.calculateSleepDebt(
        records,
        goalHours,
      );
      emit(
        SleepHistoryLoaded(
          records: records,
          weeklyAverage: weeklyAvg,
          sleepScore: score,
          sleepDebt: debt,
          goalHours: goalHours,
        ),
      );
    });
  }

  Future<void> _onSaveSleepRecord(
    SaveSleepRecord event,
    Emitter<SleepCycleState> emit,
  ) async {
    final current = state;
    if (current is SleepHistoryLoaded) {
      emit(current.copyWith());
    } else {
      emit(const SleepLoading());
    }

    final record = SleepEntity(
      id: _uuid.v4(),
      userId: repository.currentUserId,
      bedTime: event.bedTime,
      wakeTime: event.wakeTime,
      quality: event.quality,
      notes: event.notes,
    );

    final result = await repository.saveSleepRecord(record);
    result.fold((failure) => emit(SleepError(failure.message)), (_) {
      emit(SleepRecordSaved(record));
      add(const LoadSleepHistory());
    });
  }

  Future<void> _onUpdateSleepGoal(
    UpdateSleepGoal event,
    Emitter<SleepCycleState> emit,
  ) async {
    await repository.saveSleepGoalHours(event.goalHours);
    if (state is SleepHistoryLoaded) {
      final current = state as SleepHistoryLoaded;
      emit(current.copyWith(goalHours: event.goalHours));
    }
  }

  Future<void> _onDeleteSleepRecord(
    DeleteSleepRecord event,
    Emitter<SleepCycleState> emit,
  ) async {
    final result = await repository.deleteRecord(event.recordId);
    result.fold(
      (failure) => emit(SleepError(failure.message)),
      (_) => add(const LoadSleepHistory()),
    );
  }

  void _onStartSleepTracking(
    StartSleepTracking event,
    Emitter<SleepCycleState> emit,
  ) {
    if (state is SleepHistoryLoaded) {
      final current = state as SleepHistoryLoaded;
      emit(current.copyWith(trackingStartedAt: event.bedTime));
    }
  }

  Future<void> _onStopSleepTracking(
    StopSleepTracking event,
    Emitter<SleepCycleState> emit,
  ) async {
    if (state is SleepHistoryLoaded) {
      final current = state as SleepHistoryLoaded;
      if (current.trackingStartedAt != null) {
        add(
          SaveSleepRecord(
            bedTime: current.trackingStartedAt!,
            wakeTime: DateTime.now(),
            quality: 3,
          ),
        );
      }
      emit(current.copyWith(clearTracking: true));
    }
  }

  Future<void> _onUpdateBedtimeSchedule(
    UpdateBedtimeSchedule event,
    Emitter<SleepCycleState> emit,
  ) async {
    await repository.saveBedtimeSchedule(
      bedTime: event.bedTime,
      wakeTime: event.wakeTime,
    );
  }
}
