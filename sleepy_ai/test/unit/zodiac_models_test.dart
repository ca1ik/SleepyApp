import 'package:flutter_test/flutter_test.dart';
import 'package:sleepy_ai/features/zodiac/domain/zodiac_models.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // ZodiacSign.fromDate — Date ↔ Sign mapping
  // ═══════════════════════════════════════════════════════════════════════════
  group('ZodiacSign.fromDate', () {
    final expectedMappings = <DateTime, ZodiacSign>{
      // Aries: Mar 21 – Apr 19
      DateTime(2000, 3, 21): ZodiacSign.aries,
      DateTime(2000, 4, 19): ZodiacSign.aries,
      // Taurus: Apr 20 – May 20
      DateTime(2000, 4, 20): ZodiacSign.taurus,
      DateTime(2000, 5, 20): ZodiacSign.taurus,
      // Gemini: May 21 – Jun 20
      DateTime(2000, 5, 21): ZodiacSign.gemini,
      DateTime(2000, 6, 20): ZodiacSign.gemini,
      // Cancer: Jun 21 – Jul 22
      DateTime(2000, 6, 21): ZodiacSign.cancer,
      DateTime(2000, 7, 22): ZodiacSign.cancer,
      // Leo: Jul 23 – Aug 22
      DateTime(2000, 7, 23): ZodiacSign.leo,
      DateTime(2000, 8, 22): ZodiacSign.leo,
      // Virgo: Aug 23 – Sep 22
      DateTime(2000, 8, 23): ZodiacSign.virgo,
      DateTime(2000, 9, 22): ZodiacSign.virgo,
      // Libra: Sep 23 – Oct 22
      DateTime(2000, 9, 23): ZodiacSign.libra,
      DateTime(2000, 10, 22): ZodiacSign.libra,
      // Scorpio: Oct 23 – Nov 21
      DateTime(2000, 10, 23): ZodiacSign.scorpio,
      DateTime(2000, 11, 21): ZodiacSign.scorpio,
      // Sagittarius: Nov 22 – Dec 21
      DateTime(2000, 11, 22): ZodiacSign.sagittarius,
      DateTime(2000, 12, 21): ZodiacSign.sagittarius,
      // Capricorn: Dec 22 – Jan 19
      DateTime(2000, 12, 22): ZodiacSign.capricorn,
      DateTime(2001, 1, 19): ZodiacSign.capricorn,
      // Aquarius: Jan 20 – Feb 18
      DateTime(2000, 1, 20): ZodiacSign.aquarius,
      DateTime(2000, 2, 18): ZodiacSign.aquarius,
      // Pisces: Feb 19 – Mar 20
      DateTime(2000, 2, 19): ZodiacSign.pisces,
      DateTime(2000, 3, 20): ZodiacSign.pisces,
    };

    for (final entry in expectedMappings.entries) {
      test(
        '${entry.key.month}/${entry.key.day} → ${entry.value.name}',
        () => expect(ZodiacSign.fromDate(entry.key), entry.value),
      );
    }

    test('all 12 signs are reachable', () {
      final reached = <ZodiacSign>{};
      for (int m = 1; m <= 12; m++) {
        for (int d = 1; d <= 28; d++) {
          reached.add(ZodiacSign.fromDate(DateTime(2000, m, d)));
        }
      }
      expect(reached, containsAll(ZodiacSign.values));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ZodiacSign properties
  // ═══════════════════════════════════════════════════════════════════════════
  group('ZodiacSign properties', () {
    test('every sign has a non-empty symbol', () {
      for (final s in ZodiacSign.values) {
        expect(s.symbol, isNotEmpty, reason: '${s.name} symbol');
      }
    });

    test('every sign has a non-empty emoji', () {
      for (final s in ZodiacSign.values) {
        expect(s.emoji, isNotEmpty, reason: '${s.name} emoji');
      }
    });

    test('element classification covers all signs', () {
      for (final s in ZodiacSign.values) {
        expect(ZodiacElement.values, contains(s.element));
      }
    });

    test('modality classification covers all signs', () {
      for (final s in ZodiacSign.values) {
        expect(ZodiacModality.values, contains(s.modality));
      }
    });

    test('fire signs are aries, leo, sagittarius', () {
      final fireSigns = ZodiacSign.values
          .where((s) => s.element == ZodiacElement.fire)
          .toSet();
      expect(fireSigns, {
        ZodiacSign.aries,
        ZodiacSign.leo,
        ZodiacSign.sagittarius,
      });
    });

    test('water signs are cancer, scorpio, pisces', () {
      final waterSigns = ZodiacSign.values
          .where((s) => s.element == ZodiacElement.water)
          .toSet();
      expect(waterSigns, {
        ZodiacSign.cancer,
        ZodiacSign.scorpio,
        ZodiacSign.pisces,
      });
    });

    test('earth signs are taurus, virgo, capricorn', () {
      final earthSigns = ZodiacSign.values
          .where((s) => s.element == ZodiacElement.earth)
          .toSet();
      expect(earthSigns, {
        ZodiacSign.taurus,
        ZodiacSign.virgo,
        ZodiacSign.capricorn,
      });
    });

    test('air signs are gemini, libra, aquarius', () {
      final airSigns = ZodiacSign.values
          .where((s) => s.element == ZodiacElement.air)
          .toSet();
      expect(airSigns, {
        ZodiacSign.gemini,
        ZodiacSign.libra,
        ZodiacSign.aquarius,
      });
    });

    test('i18n key format is correct', () {
      for (final s in ZodiacSign.values) {
        expect(s.nameKey, 'zodiac_${s.name}');
        expect(s.descKey, 'zodiac_${s.name}_desc');
        expect(s.sleepStyleKey, 'zodiac_${s.name}_sleep');
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ZodiacCompatibility.calculate
  // ═══════════════════════════════════════════════════════════════════════════
  group('ZodiacCompatibility.calculate', () {
    test('same sign returns fixed high score (80)', () {
      final c = ZodiacCompatibility.calculate(
        ZodiacSign.leo,
        ZodiacSign.leo,
      );
      expect(c.overallScore, 80);
      expect(c.sign1, ZodiacSign.leo);
      expect(c.sign2, ZodiacSign.leo);
    });

    test('same element pair scores higher than opposing', () {
      // Aries + Leo = both fire → same element bonus
      final sameElement = ZodiacCompatibility.calculate(
        ZodiacSign.aries,
        ZodiacSign.leo,
      );
      // Aries + Cancer = fire vs water → opposing
      final opposing = ZodiacCompatibility.calculate(
        ZodiacSign.aries,
        ZodiacSign.cancer,
      );
      expect(sameElement.overallScore, greaterThan(opposing.overallScore));
    });

    test('complementary elements score higher than opposing', () {
      // Aries (fire) + Gemini (air) → complementary
      final comp = ZodiacCompatibility.calculate(
        ZodiacSign.aries,
        ZodiacSign.gemini,
      );
      // Aries (fire) + Cancer (water) → opposing
      final opp = ZodiacCompatibility.calculate(
        ZodiacSign.aries,
        ZodiacSign.cancer,
      );
      expect(comp.overallScore, greaterThan(opp.overallScore));
    });

    test('all sub-scores are clamped between 10 and 98', () {
      for (final s1 in ZodiacSign.values) {
        for (final s2 in ZodiacSign.values) {
          final c = ZodiacCompatibility.calculate(s1, s2);
          expect(c.overallScore, inInclusiveRange(10, 98),
              reason: '${s1.name} × ${s2.name} overall');
          expect(c.loveScore, inInclusiveRange(10, 98),
              reason: '${s1.name} × ${s2.name} love');
          expect(c.friendshipScore, inInclusiveRange(10, 98),
              reason: '${s1.name} × ${s2.name} friendship');
          expect(c.sleepHarmonyScore, inInclusiveRange(10, 98),
              reason: '${s1.name} × ${s2.name} sleep');
          expect(c.astralConnectionScore, inInclusiveRange(10, 98),
              reason: '${s1.name} × ${s2.name} astral');
        }
      }
    });

    test('levelKey returns valid categories', () {
      final validKeys = {
        'compat_excellent',
        'compat_good',
        'compat_moderate',
        'compat_challenging',
        'compat_difficult',
      };
      for (final s1 in ZodiacSign.values) {
        for (final s2 in ZodiacSign.values) {
          final c = ZodiacCompatibility.calculate(s1, s2);
          expect(validKeys, contains(c.levelKey),
              reason: '${s1.name} × ${s2.name} levelKey=${c.levelKey}');
        }
      }
    });

    test('is deterministic — same inputs always produce same output', () {
      final a =
          ZodiacCompatibility.calculate(ZodiacSign.scorpio, ZodiacSign.pisces);
      final b =
          ZodiacCompatibility.calculate(ZodiacSign.scorpio, ZodiacSign.pisces);
      expect(a.overallScore, b.overallScore);
      expect(a.loveScore, b.loveScore);
      expect(a.friendshipScore, b.friendshipScore);
      expect(a.sleepHarmonyScore, b.sleepHarmonyScore);
      expect(a.astralConnectionScore, b.astralConnectionScore);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // AstralExercise catalog
  // ═══════════════════════════════════════════════════════════════════════════
  group('AstralExercise', () {
    test('all catalog returns exactly 5 exercises', () {
      expect(AstralExercise.all.length, 5);
    });

    test('all exercises have unique ids', () {
      final ids = AstralExercise.all.map((e) => e.id).toSet();
      expect(ids.length, 5);
    });

    test('all exercises have valid difficulty (1-5)', () {
      for (final ex in AstralExercise.all) {
        expect(ex.difficulty, inInclusiveRange(1, 5), reason: ex.id);
      }
    });

    test('all exercises have non-empty steps', () {
      for (final ex in AstralExercise.all) {
        expect(ex.steps, isNotEmpty, reason: '${ex.id} steps');
        expect(ex.steps.length, greaterThanOrEqualTo(5),
            reason: '${ex.id} should have 5+ steps');
      }
    });

    test('all categories are represented', () {
      final categories = AstralExercise.all.map((e) => e.category).toSet();
      expect(categories, containsAll(AstralCategory.values));
    });

    test('duration is positive for all exercises', () {
      for (final ex in AstralExercise.all) {
        expect(ex.durationMinutes, greaterThan(0), reason: ex.id);
      }
    });

    test('step keys follow naming convention', () {
      for (final ex in AstralExercise.all) {
        for (int i = 0; i < ex.steps.length; i++) {
          expect(ex.steps[i], contains('step_${i + 1}'),
              reason: '${ex.id} step $i');
        }
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ZodiacElement properties
  // ═══════════════════════════════════════════════════════════════════════════
  group('ZodiacElement', () {
    test('all 4 elements have non-empty symbols', () {
      for (final e in ZodiacElement.values) {
        expect(e.symbol, isNotEmpty, reason: e.name);
      }
    });

    test('exactly 4 elements exist', () {
      expect(ZodiacElement.values.length, 4);
    });
  });
}
