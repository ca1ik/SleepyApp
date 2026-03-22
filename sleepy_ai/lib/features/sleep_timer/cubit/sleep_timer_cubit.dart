import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─── State ──────────────────────────────────────────────────────────────────

enum SleepTimerStatus { idle, running, paused, finished }

class SleepTimerState extends Equatable {
  const SleepTimerState({
    this.status = SleepTimerStatus.idle,
    this.totalSeconds = 0,
    this.remainingSeconds = 0,
    this.selectedMinutes = 30,
  });

  final SleepTimerStatus status;
  final int totalSeconds;
  final int remainingSeconds;
  final int selectedMinutes;

  double get progress => totalSeconds > 0 ? remainingSeconds / totalSeconds : 0;

  String get formattedTime {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  SleepTimerState copyWith({
    SleepTimerStatus? status,
    int? totalSeconds,
    int? remainingSeconds,
    int? selectedMinutes,
  }) {
    return SleepTimerState(
      status: status ?? this.status,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      selectedMinutes: selectedMinutes ?? this.selectedMinutes,
    );
  }

  @override
  List<Object?> get props =>
      [status, totalSeconds, remainingSeconds, selectedMinutes];
}

// ─── Cubit ──────────────────────────────────────────────────────────────────

class SleepTimerCubit extends Cubit<SleepTimerState> {
  SleepTimerCubit() : super(const SleepTimerState());

  Timer? _timer;

  /// Preset süreler (dakika)
  static const List<int> presets = [5, 10, 15, 20, 30, 45, 60, 90, 120];

  void selectDuration(int minutes) {
    emit(state.copyWith(selectedMinutes: minutes));
  }

  void start() {
    _timer?.cancel();
    final totalSec = state.selectedMinutes * 60;
    emit(state.copyWith(
      status: SleepTimerStatus.running,
      totalSeconds: totalSec,
      remainingSeconds: totalSec,
    ));
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void pause() {
    _timer?.cancel();
    emit(state.copyWith(status: SleepTimerStatus.paused));
  }

  void resume() {
    emit(state.copyWith(status: SleepTimerStatus.running));
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void stop() {
    _timer?.cancel();
    emit(const SleepTimerState());
  }

  void _tick(Timer _) {
    if (state.remainingSeconds <= 1) {
      _timer?.cancel();
      emit(state.copyWith(
        status: SleepTimerStatus.finished,
        remainingSeconds: 0,
      ));
    } else {
      emit(state.copyWith(
        remainingSeconds: state.remainingSeconds - 1,
      ));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
