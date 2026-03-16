import 'package:equatable/equatable.dart';

/// Ses kategorisi
enum SoundCategory {
  nature,
  rain,
  whiteNoise,
  instrument,
  instruments,
  lullaby,
  medieval,
  ambient,
  healing,
  meditation,
  binaural,
  happy,
  prayer,
}

/// Tek bir ses parçası modeli
class SoundModel extends Equatable {
  const SoundModel({
    required this.id,
    required this.name,
    required this.nameTr,
    required this.category,
    required this.streamUrl,
    required this.iconEmoji,
    this.isPro = false,
    this.isFavorite = false,
    this.description,
  });

  final String id;
  final String name;
  final String nameTr;
  final SoundCategory category;
  final String streamUrl;
  final String iconEmoji;
  final bool isPro;
  final bool isFavorite;
  final String? description;

  SoundModel copyWith({
    String? id,
    String? name,
    String? nameTr,
    SoundCategory? category,
    String? streamUrl,
    String? iconEmoji,
    bool? isPro,
    bool? isFavorite,
    String? description,
  }) {
    return SoundModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameTr: nameTr ?? this.nameTr,
      category: category ?? this.category,
      streamUrl: streamUrl ?? this.streamUrl,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      isPro: isPro ?? this.isPro,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, name, category, streamUrl, isPro, isFavorite];
}

/// Mixer'daki aktif track — ses seviyesi ile birlikte
class ActiveSoundTrack extends Equatable {
  const ActiveSoundTrack({
    required this.sound,
    required this.volume,
    this.isPlaying = true,
  });

  final SoundModel sound;
  final double volume; // 0.0 – 1.0
  final bool isPlaying;

  ActiveSoundTrack copyWith({
    SoundModel? sound,
    double? volume,
    bool? isPlaying,
  }) {
    return ActiveSoundTrack(
      sound: sound ?? this.sound,
      volume: volume ?? this.volume,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  @override
  List<Object?> get props => [sound, volume, isPlaying];
}

/// Badge / ödül modeli
enum BadgeType {
  flexibleHours,
  mealCard,
  commuteCompensation,
  workingEquipment,
  paidBirthdayOff,
}

class BadgeModel extends Equatable {
  const BadgeModel({
    required this.type,
    required this.title,
    required this.titleTr,
    required this.description,
    required this.emoji,
    required this.requiredScore,
    this.isEarned = false,
    this.earnedAt,
  });

  final BadgeType type;
  final String title;
  final String titleTr;
  final String description;
  final String emoji;
  final int requiredScore; // Ortalama uyku skoru eşiği
  final bool isEarned;
  final DateTime? earnedAt;

  BadgeModel copyWith({bool? isEarned, DateTime? earnedAt}) {
    return BadgeModel(
      type: type,
      title: title,
      titleTr: titleTr,
      description: description,
      emoji: emoji,
      requiredScore: requiredScore,
      isEarned: isEarned ?? this.isEarned,
      earnedAt: earnedAt ?? this.earnedAt,
    );
  }

  @override
  List<Object?> get props => [type, isEarned, earnedAt];
}

/// Varsayılan badge listesi
const List<BadgeModel> kDefaultBadges = [
  BadgeModel(
    type: BadgeType.flexibleHours,
    title: 'Flexible Working Hours',
    titleTr: 'Esnek Çalışma Saatleri',
    description: '7 gün üst üste düzenli uyku saati tut.',
    emoji: '⏰',
    requiredScore: 60,
  ),
  BadgeModel(
    type: BadgeType.mealCard,
    title: 'Meal Card',
    titleTr: 'Yemek Kartı',
    description: '14 gün boyunca 7 saat ve üzeri uyu.',
    emoji: '🍽️',
    requiredScore: 70,
  ),
  BadgeModel(
    type: BadgeType.commuteCompensation,
    title: 'Commute Compensation',
    titleTr: 'Yol Yardımı',
    description: 'Uyku kalite ortalamasını 75 üzerine çıkar.',
    emoji: '🚌',
    requiredScore: 75,
  ),
  BadgeModel(
    type: BadgeType.workingEquipment,
    title: 'Working Equipment',
    titleTr: 'Çalışma Ekipmanı',
    description: '30 gün kesintisiz uyku takibi yap.',
    emoji: '💻',
    requiredScore: 80,
  ),
  BadgeModel(
    type: BadgeType.paidBirthdayOff,
    title: 'Paid Birthday Off',
    titleTr: 'Doğum Günü İzni',
    description: 'Tüm rozetleri kazandın. Efsanesin!',
    emoji: '🎂',
    requiredScore: 90,
  ),
];

/// Öğrenme modeli uyku ipuçları için
class SleepTipModel extends Equatable {
  const SleepTipModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.readTimeMinutes,
    this.imageUrl,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final String body;
  final String category;
  final int readTimeMinutes;
  final String? imageUrl;
  final bool isFavorite;

  factory SleepTipModel.fromJson(Map<String, dynamic> json) {
    return SleepTipModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      category: json['category'] as String? ?? 'Genel',
      readTimeMinutes: json['readTimeMinutes'] as int? ?? 5,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  SleepTipModel copyWith({bool? isFavorite}) {
    return SleepTipModel(
      id: id,
      title: title,
      body: body,
      category: category,
      readTimeMinutes: readTimeMinutes,
      imageUrl: imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id, title, category, isFavorite];
}
