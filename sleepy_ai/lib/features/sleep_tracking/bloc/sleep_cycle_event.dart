import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SleepCycleEvent extends Equatable {
  const SleepCycleEvent();

  @override
  List<Object?> get props => [];
}

/// Dashboard veya Sleep sayfası açıldığında son 7 günlük veriyi yükler.
class LoadSleepHistory extends SleepCycleEvent {
  const LoadSleepHistory();
}

/// Yeni uyku verisi kaydet (sabah kayıt akışı).
class SaveSleepRecord extends SleepCycleEvent {
  const SaveSleepRecord({
    required this.bedTime,
    required this.wakeTime,
    required this.quality,
    this.notes,
  });

  final DateTime bedTime;
  final DateTime wakeTime;
  final int quality; // 1-5
  final String? notes;

  @override
  List<Object?> get props => [bedTime, wakeTime, quality, notes];
}

/// Mevcut hedef uyku süresini güncelle (saat cinsinden, ör. 8.0).
class UpdateSleepGoal extends SleepCycleEvent {
  const UpdateSleepGoal(this.goalHours);

  final double goalHours;

  @override
  List<Object?> get props => [goalHours];
}

/// Yatış ve uyanış saatlerini güncelle.
class UpdateBedtimeSchedule extends SleepCycleEvent {
  const UpdateBedtimeSchedule({required this.bedTime, required this.wakeTime});

  final TimeOfDay bedTime;
  final TimeOfDay wakeTime;

  @override
  List<Object?> get props => [bedTime, wakeTime];
}

/// Belirli bir kaydı sil.
class DeleteSleepRecord extends SleepCycleEvent {
  const DeleteSleepRecord(this.recordId);

  final String recordId;

  @override
  List<Object?> get props => [recordId];
}

/// Uyku takip etmeye başla (timer aktif et).
class StartSleepTracking extends SleepCycleEvent {
  const StartSleepTracking(this.bedTime);

  final DateTime bedTime;

  @override
  List<Object?> get props => [bedTime];
}

/// Uyku takibini bitir.
class StopSleepTracking extends SleepCycleEvent {
  const StopSleepTracking();
}
