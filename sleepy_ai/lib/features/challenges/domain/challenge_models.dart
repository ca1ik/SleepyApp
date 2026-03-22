import 'package:equatable/equatable.dart';

/// Meydan okuma tipi
enum ChallengeType {
  sleepDuration,
  consistency,
  noScreen,
  earlyBed,
  meditation,
  noSnooze,
}

extension ChallengeTypeX on ChallengeType {
  String get emoji {
    switch (this) {
      case ChallengeType.sleepDuration:
        return '⏰';
      case ChallengeType.consistency:
        return '📅';
      case ChallengeType.noScreen:
        return '📵';
      case ChallengeType.earlyBed:
        return '🌙';
      case ChallengeType.meditation:
        return '🧘';
      case ChallengeType.noSnooze:
        return '⏱️';
    }
  }

  String get titleKey {
    switch (this) {
      case ChallengeType.sleepDuration:
        return 'challengeSleepDuration';
      case ChallengeType.consistency:
        return 'challengeConsistency';
      case ChallengeType.noScreen:
        return 'challengeNoScreen';
      case ChallengeType.earlyBed:
        return 'challengeEarlyBed';
      case ChallengeType.meditation:
        return 'challengeMeditation';
      case ChallengeType.noSnooze:
        return 'challengeNoSnooze';
    }
  }

  String get descKey {
    switch (this) {
      case ChallengeType.sleepDuration:
        return 'challengeSleepDurationDesc';
      case ChallengeType.consistency:
        return 'challengeConsistencyDesc';
      case ChallengeType.noScreen:
        return 'challengeNoScreenDesc';
      case ChallengeType.earlyBed:
        return 'challengeEarlyBedDesc';
      case ChallengeType.meditation:
        return 'challengeMeditationDesc';
      case ChallengeType.noSnooze:
        return 'challengeNoSnoozeDesc';
    }
  }
}

/// Tek bir meydan okuma
class SleepChallenge extends Equatable {
  const SleepChallenge({
    required this.id,
    required this.type,
    required this.targetDays,
    this.completedDays = 0,
    this.xpReward = 100,
    this.isActive = false,
    this.isCompleted = false,
    this.startDate,
    this.checkedDates = const [],
  });

  final String id;
  final ChallengeType type;
  final int targetDays;
  final int completedDays;
  final int xpReward;
  final bool isActive;
  final bool isCompleted;
  final DateTime? startDate;
  final List<String> checkedDates; // ISO date strings

  double get progress =>
      targetDays > 0 ? (completedDays / targetDays).clamp(0.0, 1.0) : 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'targetDays': targetDays,
        'completedDays': completedDays,
        'xpReward': xpReward,
        'isActive': isActive,
        'isCompleted': isCompleted,
        'startDate': startDate?.toIso8601String(),
        'checkedDates': checkedDates,
      };

  factory SleepChallenge.fromJson(Map<String, dynamic> json) {
    return SleepChallenge(
      id: json['id'] as String,
      type: ChallengeType.values[json['type'] as int],
      targetDays: json['targetDays'] as int,
      completedDays: json['completedDays'] as int? ?? 0,
      xpReward: json['xpReward'] as int? ?? 100,
      isActive: json['isActive'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      checkedDates: List<String>.from(json['checkedDates'] as List? ?? []),
    );
  }

  SleepChallenge copyWith({
    int? completedDays,
    bool? isActive,
    bool? isCompleted,
    DateTime? startDate,
    List<String>? checkedDates,
  }) {
    return SleepChallenge(
      id: id,
      type: type,
      targetDays: targetDays,
      completedDays: completedDays ?? this.completedDays,
      xpReward: xpReward,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
      startDate: startDate ?? this.startDate,
      checkedDates: checkedDates ?? this.checkedDates,
    );
  }

  @override
  List<Object?> get props =>
      [id, type, targetDays, completedDays, isActive, isCompleted];
}

/// Önceden tanımlı meydan okumalar
List<SleepChallenge> get kDefaultChallenges => [
      const SleepChallenge(
        id: 'ch_sleep_7h_5d',
        type: ChallengeType.sleepDuration,
        targetDays: 5,
        xpReward: 100,
      ),
      const SleepChallenge(
        id: 'ch_consistency_7d',
        type: ChallengeType.consistency,
        targetDays: 7,
        xpReward: 150,
      ),
      const SleepChallenge(
        id: 'ch_no_screen_3d',
        type: ChallengeType.noScreen,
        targetDays: 3,
        xpReward: 75,
      ),
      const SleepChallenge(
        id: 'ch_early_bed_5d',
        type: ChallengeType.earlyBed,
        targetDays: 5,
        xpReward: 120,
      ),
      const SleepChallenge(
        id: 'ch_meditation_7d',
        type: ChallengeType.meditation,
        targetDays: 7,
        xpReward: 200,
      ),
      const SleepChallenge(
        id: 'ch_no_snooze_3d',
        type: ChallengeType.noSnooze,
        targetDays: 3,
        xpReward: 80,
      ),
    ];
