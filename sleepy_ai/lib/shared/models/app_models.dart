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

/// Badge kategorisi — uyku bazlı veya oyun/film bazlı
enum BadgeCategory { sleep, game, film }

/// Badge / ödül modeli
enum BadgeType {
  // Uyku rozetleri
  flexibleHours,
  mealCard,
  commuteCompensation,
  workingEquipment,
  paidBirthdayOff,
  // Oyun rozetleri
  cosmicBreather,
  starCatcher,
  dreamWeaver,
  galaxyExplorer,
  sleepSage,
}

class BadgeModel extends Equatable {
  const BadgeModel({
    required this.type,
    required this.title,
    required this.titleTr,
    required this.description,
    required this.emoji,
    required this.requiredScore,
    this.category = BadgeCategory.sleep,
    this.isEarned = false,
    this.earnedAt,
  });

  final BadgeType type;
  final String title;
  final String titleTr;
  final String description;
  final String emoji;
  final int requiredScore; // Ortalama uyku skoru eşiği (oyun rozetleri için 0)
  final BadgeCategory category;
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
      category: category,
      isEarned: isEarned ?? this.isEarned,
      earnedAt: earnedAt ?? this.earnedAt,
    );
  }

  @override
  List<Object?> get props => [type, isEarned, earnedAt];
}

/// Varsayılan badge listesi
const List<BadgeModel> kDefaultBadges = [
  // ── Uyku Rozetleri ──────────────────────────────────────────────────────
  BadgeModel(
    type: BadgeType.flexibleHours,
    title: 'Flexible Working Hours',
    titleTr: 'Esnek Çalışma Saatleri',
    description: '7 gün üst üste düzenli uyku saati tut.',
    emoji: '⏰',
    requiredScore: 60,
    category: BadgeCategory.sleep,
  ),
  BadgeModel(
    type: BadgeType.mealCard,
    title: 'Meal Card',
    titleTr: 'Yemek Kartı',
    description: '14 gün boyunca 7 saat ve üzeri uyu.',
    emoji: '🍽️',
    requiredScore: 70,
    category: BadgeCategory.sleep,
  ),
  BadgeModel(
    type: BadgeType.commuteCompensation,
    title: 'Commute Compensation',
    titleTr: 'Yol Yardımı',
    description: 'Uyku kalite ortalamasını 75 üzerine çıkar.',
    emoji: '🚌',
    requiredScore: 75,
    category: BadgeCategory.sleep,
  ),
  BadgeModel(
    type: BadgeType.workingEquipment,
    title: 'Working Equipment',
    titleTr: 'Çalışma Ekipmanı',
    description: '30 gün kesintisiz uyku takibi yap.',
    emoji: '💻',
    requiredScore: 80,
    category: BadgeCategory.sleep,
  ),
  BadgeModel(
    type: BadgeType.paidBirthdayOff,
    title: 'Paid Birthday Off',
    titleTr: 'Doğum Günü İzni',
    description: 'Tüm uyku rozetlerini kazandın. Efsanesin!',
    emoji: '🎂',
    requiredScore: 90,
    category: BadgeCategory.sleep,
  ),
  // ── Oyun & Film Rozetleri ───────────────────────────────────────────────
  BadgeModel(
    type: BadgeType.cosmicBreather,
    title: 'Cosmic Breather',
    titleTr: 'Kozmik Nefes',
    description: 'Kozmik Nefes oyununda 5 tam döngü tamamla.',
    emoji: '🌌',
    requiredScore: 0,
    category: BadgeCategory.game,
  ),
  BadgeModel(
    type: BadgeType.starCatcher,
    title: 'Star Catcher',
    titleTr: 'Yıldız Avcısı',
    description: 'Yıldız Avcısı oyununda 30+ yıldız topla.',
    emoji: '⭐',
    requiredScore: 0,
    category: BadgeCategory.game,
  ),
  BadgeModel(
    type: BadgeType.dreamWeaver,
    title: 'Dream Weaver',
    titleTr: 'Hayal Dokuyucu',
    description: '3 uyku filmini baştan sona izle.',
    emoji: '🎬',
    requiredScore: 0,
    category: BadgeCategory.film,
  ),
  BadgeModel(
    type: BadgeType.galaxyExplorer,
    title: 'Galaxy Explorer',
    titleTr: 'Galaksi Gezgini',
    description: 'Tüm 3 oyunu en az bir kez oyna.',
    emoji: '🚀',
    requiredScore: 0,
    category: BadgeCategory.game,
  ),
  BadgeModel(
    type: BadgeType.sleepSage,
    title: 'Sleep Sage',
    titleTr: 'Uyku Bilgesi',
    description: 'Oyunlarda toplam 500+ puan topla.',
    emoji: '🧙',
    requiredScore: 0,
    category: BadgeCategory.game,
  ),
];

/// Oyun skoru kaydı
class GameScoreRecord extends Equatable {
  const GameScoreRecord({
    required this.gameId,
    required this.score,
    required this.timestamp,
  });

  final String gameId; // 'breathing' | 'star_catcher' | 'galaxy'
  final int score;
  final DateTime timestamp;

  @override
  List<Object?> get props => [gameId, score, timestamp];
}

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
