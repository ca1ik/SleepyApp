import 'package:flutter/material.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';

/// All 12 zodiac signs with symbols, date ranges, elements, and colors.
enum ZodiacSign {
  aries,
  taurus,
  gemini,
  cancer,
  leo,
  virgo,
  libra,
  scorpio,
  sagittarius,
  capricorn,
  aquarius,
  pisces;

  String get symbol => switch (this) {
        aries => '♈',
        taurus => '♉',
        gemini => '♊',
        cancer => '♋',
        leo => '♌',
        virgo => '♍',
        libra => '♎',
        scorpio => '♏',
        sagittarius => '♐',
        capricorn => '♑',
        aquarius => '♒',
        pisces => '♓',
      };

  String get emoji => switch (this) {
        aries => '🐏',
        taurus => '🐂',
        gemini => '👯',
        cancer => '🦀',
        leo => '🦁',
        virgo => '👼',
        libra => '⚖️',
        scorpio => '🦂',
        sagittarius => '🏹',
        capricorn => '🐐',
        aquarius => '🏺',
        pisces => '🐟',
      };

  Color get color => switch (this) {
        aries => AppColors.zodiacAries,
        taurus => AppColors.zodiacTaurus,
        gemini => AppColors.zodiacGemini,
        cancer => AppColors.zodiacCancer,
        leo => AppColors.zodiacLeo,
        virgo => AppColors.zodiacVirgo,
        libra => AppColors.zodiacLibra,
        scorpio => AppColors.zodiacScorpio,
        sagittarius => AppColors.zodiacSagittarius,
        capricorn => AppColors.zodiacCapricorn,
        aquarius => AppColors.zodiacAquarius,
        pisces => AppColors.zodiacPisces,
      };

  ZodiacElement get element => switch (this) {
        aries || leo || sagittarius => ZodiacElement.fire,
        taurus || virgo || capricorn => ZodiacElement.earth,
        gemini || libra || aquarius => ZodiacElement.air,
        cancer || scorpio || pisces => ZodiacElement.water,
      };

  ZodiacModality get modality => switch (this) {
        aries || cancer || libra || capricorn => ZodiacModality.cardinal,
        taurus || leo || scorpio || aquarius => ZodiacModality.fixed,
        gemini || virgo || sagittarius || pisces => ZodiacModality.mutable,
      };

  /// Ruling planet key for localization.
  String get rulingPlanetKey => 'zodiac_${name}_planet';

  /// Date range string key.
  String get dateRangeKey => 'zodiac_${name}_dates';

  /// i18n key prefix.
  String get nameKey => 'zodiac_$name';
  String get descKey => 'zodiac_${name}_desc';
  String get strengthsKey => 'zodiac_${name}_strengths';
  String get weaknessesKey => 'zodiac_${name}_weaknesses';
  String get sleepStyleKey => 'zodiac_${name}_sleep';
  String get astralAdviceKey => 'zodiac_${name}_astral';

  /// Detect zodiac from birth date.
  static ZodiacSign fromDate(DateTime date) {
    final m = date.month;
    final d = date.day;
    if ((m == 3 && d >= 21) || (m == 4 && d <= 19)) return aries;
    if ((m == 4 && d >= 20) || (m == 5 && d <= 20)) return taurus;
    if ((m == 5 && d >= 21) || (m == 6 && d <= 20)) return gemini;
    if ((m == 6 && d >= 21) || (m == 7 && d <= 22)) return cancer;
    if ((m == 7 && d >= 23) || (m == 8 && d <= 22)) return leo;
    if ((m == 8 && d >= 23) || (m == 9 && d <= 22)) return virgo;
    if ((m == 9 && d >= 23) || (m == 10 && d <= 22)) return libra;
    if ((m == 10 && d >= 23) || (m == 11 && d <= 21)) return scorpio;
    if ((m == 11 && d >= 22) || (m == 12 && d <= 21)) return sagittarius;
    if ((m == 12 && d >= 22) || (m == 1 && d <= 19)) return capricorn;
    if ((m == 1 && d >= 20) || (m == 2 && d <= 18)) return aquarius;
    return pisces;
  }
}

enum ZodiacElement {
  fire,
  earth,
  air,
  water;

  String get symbol => switch (this) {
        fire => '🔥',
        earth => '🌍',
        air => '💨',
        water => '💧',
      };

  Color get color => switch (this) {
        fire => const Color(0xFFFF6B35),
        earth => const Color(0xFF4CAF50),
        air => const Color(0xFF90CAF9),
        water => const Color(0xFF1E88E5),
      };
}

enum ZodiacModality { cardinal, fixed, mutable }

/// Compatibility result between two zodiac signs.
class ZodiacCompatibility {
  const ZodiacCompatibility({
    required this.sign1,
    required this.sign2,
    required this.overallScore,
    required this.loveScore,
    required this.friendshipScore,
    required this.sleepHarmonyScore,
    required this.astralConnectionScore,
  });

  final ZodiacSign sign1;
  final ZodiacSign sign2;
  final int overallScore; // 0-100
  final int loveScore;
  final int friendshipScore;
  final int sleepHarmonyScore;
  final int astralConnectionScore;

  String get levelKey {
    if (overallScore >= 85) return 'compat_excellent';
    if (overallScore >= 70) return 'compat_good';
    if (overallScore >= 50) return 'compat_moderate';
    if (overallScore >= 30) return 'compat_challenging';
    return 'compat_difficult';
  }

  /// Compute compatibility using element + modality affinities.
  factory ZodiacCompatibility.calculate(ZodiacSign s1, ZodiacSign s2) {
    // Same sign = high affinity
    if (s1 == s2) {
      return ZodiacCompatibility(
        sign1: s1,
        sign2: s2,
        overallScore: 80,
        loveScore: 75,
        friendshipScore: 90,
        sleepHarmonyScore: 85,
        astralConnectionScore: 82,
      );
    }

    int base = 50;

    // Same element = +25
    if (s1.element == s2.element) base += 25;

    // Complementary elements
    final complementary = {
      ZodiacElement.fire: ZodiacElement.air,
      ZodiacElement.air: ZodiacElement.fire,
      ZodiacElement.earth: ZodiacElement.water,
      ZodiacElement.water: ZodiacElement.earth,
    };
    if (complementary[s1.element] == s2.element) base += 18;

    // Opposing elements = -10
    final opposing = {
      ZodiacElement.fire: ZodiacElement.water,
      ZodiacElement.water: ZodiacElement.fire,
      ZodiacElement.earth: ZodiacElement.air,
      ZodiacElement.air: ZodiacElement.earth,
    };
    if (opposing[s1.element] == s2.element) base -= 10;

    // Same modality = +8
    if (s1.modality == s2.modality) base += 8;

    final overall = base.clamp(15, 98);
    // Derive sub-scores with slight variation
    final love =
        (overall + (s1.index * 3 - s2.index * 2) % 12 - 5).clamp(10, 98);
    final friendship = (overall + (s1.index + s2.index) % 8 - 3).clamp(10, 98);
    final sleepHarmony =
        (overall + (s1.element == s2.element ? 5 : -3)).clamp(10, 98);
    final astral = (overall + (s1.index ^ s2.index) % 10 - 4).clamp(10, 98);

    return ZodiacCompatibility(
      sign1: s1,
      sign2: s2,
      overallScore: overall,
      loveScore: love,
      friendshipScore: friendship,
      sleepHarmonyScore: sleepHarmony,
      astralConnectionScore: astral,
    );
  }
}

/// Daily horoscope reading model.
class DailyHoroscope {
  const DailyHoroscope({
    required this.sign,
    required this.date,
    required this.generalKey,
    required this.sleepAdviceKey,
    required this.luckyNumber,
    required this.luckyColorKey,
    required this.moodKey,
    required this.energyLevel,
    required this.astralTipKey,
  });

  final ZodiacSign sign;
  final DateTime date;
  final String generalKey;
  final String sleepAdviceKey;
  final int luckyNumber;
  final String luckyColorKey;
  final String moodKey;
  final int energyLevel; // 1-5
  final String astralTipKey;
}

/// Astral exercise model.
class AstralExercise {
  const AstralExercise({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.durationMinutes,
    required this.difficulty,
    required this.category,
    required this.iconData,
    required this.steps,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final int durationMinutes;
  final int difficulty; // 1-5
  final AstralCategory category;
  final IconData iconData;
  final List<String> steps; // List of i18n step keys

  static List<AstralExercise> get all => [
        AstralExercise(
          id: 'astral_projection_beginner',
          titleKey: 'astral_ex_projection_title',
          descriptionKey: 'astral_ex_projection_desc',
          durationMinutes: 20,
          difficulty: 2,
          category: AstralCategory.projection,
          iconData: Icons.flight_takeoff_rounded,
          steps: List.generate(7, (i) => 'astral_ex_projection_step_${i + 1}'),
        ),
        AstralExercise(
          id: 'lucid_dream_induction',
          titleKey: 'astral_ex_lucid_title',
          descriptionKey: 'astral_ex_lucid_desc',
          durationMinutes: 15,
          difficulty: 3,
          category: AstralCategory.lucidDream,
          iconData: Icons.visibility_rounded,
          steps: List.generate(6, (i) => 'astral_ex_lucid_step_${i + 1}'),
        ),
        AstralExercise(
          id: 'chakra_alignment_sleep',
          titleKey: 'astral_ex_chakra_title',
          descriptionKey: 'astral_ex_chakra_desc',
          durationMinutes: 25,
          difficulty: 2,
          category: AstralCategory.chakra,
          iconData: Icons.spa_rounded,
          steps: List.generate(7, (i) => 'astral_ex_chakra_step_${i + 1}'),
        ),
        AstralExercise(
          id: 'cosmic_energy_meditation',
          titleKey: 'astral_ex_cosmic_title',
          descriptionKey: 'astral_ex_cosmic_desc',
          durationMinutes: 18,
          difficulty: 1,
          category: AstralCategory.meditation,
          iconData: Icons.auto_awesome_rounded,
          steps: List.generate(6, (i) => 'astral_ex_cosmic_step_${i + 1}'),
        ),
        AstralExercise(
          id: 'third_eye_activation',
          titleKey: 'astral_ex_thirdeye_title',
          descriptionKey: 'astral_ex_thirdeye_desc',
          durationMinutes: 22,
          difficulty: 4,
          category: AstralCategory.thirdEye,
          iconData: Icons.remove_red_eye_rounded,
          steps: List.generate(7, (i) => 'astral_ex_thirdeye_step_${i + 1}'),
        ),
      ];
}

enum AstralCategory {
  projection,
  lucidDream,
  chakra,
  meditation,
  thirdEye;

  String get nameKey => 'astral_cat_$name';

  Color get color => switch (this) {
        projection => const Color(0xFF7C3AED),
        lucidDream => const Color(0xFF6366F1),
        chakra => const Color(0xFF14B8A6),
        meditation => const Color(0xFFEC4899),
        thirdEye => const Color(0xFFFFD700),
      };
}
