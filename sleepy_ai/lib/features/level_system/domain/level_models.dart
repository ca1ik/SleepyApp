// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Level Math ──────────────────────────────────────────────────────────────

/// XP hesaplama yardımcıları. Lv 1-99 arası üstel büyüme.
/// Formül: Lv N → N+1 için gereken XP = N * 150
/// Toplam XP for Lv N = 75 * N * (N-1)
abstract final class LevelHelper {
  LevelHelper._();

  /// Lv N'den N+1'e geçmek için gereken XP
  static int xpForNextLevel(int level) {
    if (level >= 99) return 0;
    return level * 150;
  }

  /// Lv N'nin başına ulaşmak için gereken toplam kümülatif XP
  static int totalXpForLevel(int level) {
    if (level <= 1) return 0;
    // Σ(i=1 to level-1) of 150*i = 75 * level * (level - 1)
    return 75 * level * (level - 1);
  }

  /// Toplam XP'den mevcut seviyeyi hesapla
  static int levelFromTotalXp(int totalXp) {
    if (totalXp <= 0) return 1;
    int level = 1;
    while (level < 99) {
      if (totalXp < totalXpForLevel(level + 1)) break;
      level++;
    }
    return level;
  }

  /// Title info for a given level
  static LevelTitleInfo titleForLevel(int level) {
    if (level <= 5) {
      return LevelTitleInfo(
        title: 'levelTitle1'.tr,
        emoji: '🌱',
        color: const Color(0xFF10B981),
        glowColor: const Color(0x4010B981),
      );
    } else if (level <= 10) {
      return LevelTitleInfo(
        title: 'levelTitle2'.tr,
        emoji: '🌸',
        color: const Color(0xFFF472B6),
        glowColor: const Color(0x40F472B6),
      );
    } else if (level <= 20) {
      return LevelTitleInfo(
        title: 'levelTitle3'.tr,
        emoji: '⭐',
        color: const Color(0xFFFDE68A),
        glowColor: const Color(0x40FDE68A),
      );
    } else if (level <= 30) {
      return LevelTitleInfo(
        title: 'levelTitle4'.tr,
        emoji: '🌙',
        color: const Color(0xFF93C5FD),
        glowColor: const Color(0x4093C5FD),
      );
    } else if (level <= 40) {
      return LevelTitleInfo(
        title: 'levelTitle5'.tr,
        emoji: '🕸️',
        color: const Color(0xFFC4B5FD),
        glowColor: const Color(0x40C4B5FD),
      );
    } else if (level <= 50) {
      return LevelTitleInfo(
        title: 'levelTitle6'.tr,
        emoji: '🔭',
        color: const Color(0xFF7C3AED),
        glowColor: const Color(0x407C3AED),
      );
    } else if (level <= 60) {
      return LevelTitleInfo(
        title: 'levelTitle7'.tr,
        emoji: '🎓',
        color: const Color(0xFF60A5FA),
        glowColor: const Color(0x4060A5FA),
      );
    } else if (level <= 70) {
      return LevelTitleInfo(
        title: 'levelTitle8'.tr,
        emoji: '🏛️',
        color: const Color(0xFF34D399),
        glowColor: const Color(0x4034D399),
      );
    } else if (level <= 80) {
      return LevelTitleInfo(
        title: 'levelTitle9'.tr,
        emoji: '👑',
        color: const Color(0xFFFFD700),
        glowColor: const Color(0x40FFD700),
      );
    } else if (level <= 90) {
      return LevelTitleInfo(
        title: 'levelTitle10'.tr,
        emoji: '⚡',
        color: const Color(0xFFFF6B35),
        glowColor: const Color(0x40FF6B35),
      );
    } else {
      return LevelTitleInfo(
        title: 'levelTitle11'.tr,
        emoji: '✨',
        color: const Color(0xFFE0D0FF),
        glowColor: const Color(0x40E0D0FF),
      );
    }
  }
}

// ─── LevelTitleInfo ───────────────────────────────────────────────────────────

class LevelTitleInfo {
  const LevelTitleInfo({
    required this.title,
    required this.emoji,
    required this.color,
    required this.glowColor,
  });

  final String title;
  final String emoji;
  final Color color;
  final Color glowColor;
}

// ─── SleepHeroModel ───────────────────────────────────────────────────────────

/// Kahramanın sürekliliği kalıcı veri modeli.
class SleepHeroModel {
  const SleepHeroModel({
    this.totalXp = 0,
    this.streak = 0,
    this.totalDays = 0,
    this.lastActiveDate,
    this.completedQuestIds = const [],
    this.lastQuestResetDate,
  });

  final int totalXp;
  final int streak;
  final int totalDays;
  final DateTime? lastActiveDate;
  final List<String> completedQuestIds;
  final DateTime? lastQuestResetDate;

  // ── Computed ─────────────────────────────────────────────────────────

  int get level => LevelHelper.levelFromTotalXp(totalXp);

  int get currentLevelXp => totalXp - LevelHelper.totalXpForLevel(level);

  int get xpToNextLevel => LevelHelper.xpForNextLevel(level);

  double get levelProgress =>
      level >= 99 ? 1.0 : currentLevelXp / xpToNextLevel.toDouble();

  // ── Serialization ─────────────────────────────────────────────────────

  SleepHeroModel copyWith({
    int? totalXp,
    int? streak,
    int? totalDays,
    DateTime? lastActiveDate,
    List<String>? completedQuestIds,
    DateTime? lastQuestResetDate,
  }) =>
      SleepHeroModel(
        totalXp: totalXp ?? this.totalXp,
        streak: streak ?? this.streak,
        totalDays: totalDays ?? this.totalDays,
        lastActiveDate: lastActiveDate ?? this.lastActiveDate,
        completedQuestIds: completedQuestIds ?? this.completedQuestIds,
        lastQuestResetDate: lastQuestResetDate ?? this.lastQuestResetDate,
      );

  Map<String, dynamic> toMap() => {
        'totalXp': totalXp,
        'streak': streak,
        'totalDays': totalDays,
        'lastActiveDate': lastActiveDate?.millisecondsSinceEpoch,
        'completedQuestIds': completedQuestIds,
        'lastQuestResetDate': lastQuestResetDate?.millisecondsSinceEpoch,
      };

  factory SleepHeroModel.fromMap(Map<String, dynamic> map) => SleepHeroModel(
        totalXp: (map['totalXp'] as int?) ?? 0,
        streak: (map['streak'] as int?) ?? 0,
        totalDays: (map['totalDays'] as int?) ?? 0,
        lastActiveDate: map['lastActiveDate'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['lastActiveDate'] as int)
            : null,
        completedQuestIds:
            List<String>.from((map['completedQuestIds'] as List?) ?? []),
        lastQuestResetDate: map['lastQuestResetDate'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                map['lastQuestResetDate'] as int)
            : null,
      );
}

// ─── DailyQuest ───────────────────────────────────────────────────────────────

class DailyQuest {
  const DailyQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.emoji,
    this.isCompleted = false,
    this.route,
  });

  final String id;
  final String title;
  final String description;
  final int xpReward;
  final String emoji;
  final bool isCompleted;
  final String? route;

  DailyQuest copyWith({bool? isCompleted}) => DailyQuest(
        id: id,
        title: title,
        description: description,
        xpReward: xpReward,
        emoji: emoji,
        isCompleted: isCompleted ?? this.isCompleted,
        route: route,
      );
}

// ─── DailyQuestTemplates ──────────────────────────────────────────────────────

abstract final class DailyQuestTemplates {
  static List<DailyQuest> get all => [
        DailyQuest(
          id: 'daily_login',
          title: 'questDailyLogin'.tr,
          description: 'questDailyLoginDesc'.tr,
          xpReward: 15,
          emoji: '⭐',
        ),
        DailyQuest(
          id: 'daily_sleep',
          title: 'questSleepTracking'.tr,
          description: 'questSleepTrackingDesc'.tr,
          xpReward: 50,
          emoji: '🌙',
          route: '/sleep-tracking',
        ),
        DailyQuest(
          id: 'daily_sound',
          title: 'questSleepSound'.tr,
          description: 'questSleepSoundDesc'.tr,
          xpReward: 30,
          emoji: '🎵',
          route: '/sounds',
        ),
        DailyQuest(
          id: 'daily_game',
          title: 'questMiniGame'.tr,
          description: 'questMiniGameDesc'.tr,
          xpReward: 40,
          emoji: '🎮',
          route: '/games',
        ),
        DailyQuest(
          id: 'daily_learn',
          title: 'questSleepSchool'.tr,
          description: 'questSleepSchoolDesc'.tr,
          xpReward: 25,
          emoji: '📚',
          route: '/learning',
        ),
      ];
}
