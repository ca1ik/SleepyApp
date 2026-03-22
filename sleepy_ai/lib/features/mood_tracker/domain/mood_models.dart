import 'package:equatable/equatable.dart';

/// Ruh hali seviyeleri — 5 kademeli emoji sistemi
enum MoodLevel {
  terrible,
  bad,
  neutral,
  good,
  great,
}

extension MoodLevelX on MoodLevel {
  String get emoji {
    switch (this) {
      case MoodLevel.terrible:
        return '😫';
      case MoodLevel.bad:
        return '😔';
      case MoodLevel.neutral:
        return '😐';
      case MoodLevel.good:
        return '😊';
      case MoodLevel.great:
        return '🤩';
    }
  }

  String get labelKey {
    switch (this) {
      case MoodLevel.terrible:
        return 'moodTerrible';
      case MoodLevel.bad:
        return 'moodBad';
      case MoodLevel.neutral:
        return 'moodNeutral';
      case MoodLevel.good:
        return 'moodGood';
      case MoodLevel.great:
        return 'moodGreat';
    }
  }

  int get score => index + 1; // 1-5
}

/// Tek bir ruh hali kaydı
class MoodEntry extends Equatable {
  const MoodEntry({
    required this.id,
    required this.date,
    required this.mood,
    this.note = '',
    this.sleepHours,
    this.factors = const [],
  });

  final String id;
  final DateTime date;
  final MoodLevel mood;
  final String note;
  final double? sleepHours;
  final List<String> factors; // exercise, caffeine, stress, etc.

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'mood': mood.index,
        'note': note,
        'sleepHours': sleepHours,
        'factors': factors,
      };

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      mood: MoodLevel.values[json['mood'] as int],
      note: json['note'] as String? ?? '',
      sleepHours: (json['sleepHours'] as num?)?.toDouble(),
      factors: List<String>.from(json['factors'] as List? ?? []),
    );
  }

  @override
  List<Object?> get props => [id, date, mood, note, sleepHours, factors];
}

/// Mood'u etkileyen faktörler
class MoodFactor {
  const MoodFactor(
      {required this.key, required this.emoji, required this.labelKey});

  final String key;
  final String emoji;
  final String labelKey;
}

const List<MoodFactor> kMoodFactors = [
  MoodFactor(key: 'exercise', emoji: '🏃', labelKey: 'moodFactorExercise'),
  MoodFactor(key: 'caffeine', emoji: '☕', labelKey: 'moodFactorCaffeine'),
  MoodFactor(key: 'stress', emoji: '😤', labelKey: 'moodFactorStress'),
  MoodFactor(key: 'social', emoji: '👥', labelKey: 'moodFactorSocial'),
  MoodFactor(key: 'nature', emoji: '🌿', labelKey: 'moodFactorNature'),
  MoodFactor(key: 'screen', emoji: '📱', labelKey: 'moodFactorScreen'),
  MoodFactor(key: 'meditation', emoji: '🧘', labelKey: 'moodFactorMeditation'),
  MoodFactor(key: 'alcohol', emoji: '🍷', labelKey: 'moodFactorAlcohol'),
];
