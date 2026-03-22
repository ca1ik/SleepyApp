import 'package:equatable/equatable.dart';

/// Rüya duygu etiketleri
enum DreamEmotion {
  happy,
  scared,
  peaceful,
  confused,
  excited,
  sad,
  anxious,
  nostalgic,
}

extension DreamEmotionX on DreamEmotion {
  String get emoji {
    switch (this) {
      case DreamEmotion.happy:
        return '😊';
      case DreamEmotion.scared:
        return '😨';
      case DreamEmotion.peaceful:
        return '😌';
      case DreamEmotion.confused:
        return '😕';
      case DreamEmotion.excited:
        return '🤩';
      case DreamEmotion.sad:
        return '😢';
      case DreamEmotion.anxious:
        return '😰';
      case DreamEmotion.nostalgic:
        return '🥹';
    }
  }

  String get labelKey {
    switch (this) {
      case DreamEmotion.happy:
        return 'dreamEmotionHappy';
      case DreamEmotion.scared:
        return 'dreamEmotionScared';
      case DreamEmotion.peaceful:
        return 'dreamEmotionPeaceful';
      case DreamEmotion.confused:
        return 'dreamEmotionConfused';
      case DreamEmotion.excited:
        return 'dreamEmotionExcited';
      case DreamEmotion.sad:
        return 'dreamEmotionSad';
      case DreamEmotion.anxious:
        return 'dreamEmotionAnxious';
      case DreamEmotion.nostalgic:
        return 'dreamEmotionNostalgic';
    }
  }
}

/// Tek bir rüya kaydı
class DreamEntry extends Equatable {
  const DreamEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    required this.emotions,
    this.lucidityLevel = 0,
    this.isRecurring = false,
    this.tags = const [],
  });

  final String id;
  final DateTime date;
  final String title;
  final String description;
  final List<DreamEmotion> emotions;
  final int lucidityLevel; // 0-5
  final bool isRecurring;
  final List<String> tags;

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'title': title,
        'description': description,
        'emotions': emotions.map((e) => e.index).toList(),
        'lucidityLevel': lucidityLevel,
        'isRecurring': isRecurring,
        'tags': tags,
      };

  factory DreamEntry.fromJson(Map<String, dynamic> json) {
    return DreamEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      emotions: (json['emotions'] as List)
          .map((e) => DreamEmotion.values[e as int])
          .toList(),
      lucidityLevel: json['lucidityLevel'] as int? ?? 0,
      isRecurring: json['isRecurring'] as bool? ?? false,
      tags: List<String>.from(json['tags'] as List? ?? []),
    );
  }

  DreamEntry copyWith({
    String? title,
    String? description,
    List<DreamEmotion>? emotions,
    int? lucidityLevel,
    bool? isRecurring,
    List<String>? tags,
  }) {
    return DreamEntry(
      id: id,
      date: date,
      title: title ?? this.title,
      description: description ?? this.description,
      emotions: emotions ?? this.emotions,
      lucidityLevel: lucidityLevel ?? this.lucidityLevel,
      isRecurring: isRecurring ?? this.isRecurring,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props =>
      [id, date, title, description, emotions, lucidityLevel, isRecurring];
}
