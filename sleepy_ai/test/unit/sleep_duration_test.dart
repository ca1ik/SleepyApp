import 'package:flutter_test/flutter_test.dart';
import 'package:sleepy_ai/core/utils/sleep_duration_calculator.dart';

void main() {
  group('SleepDurationCalculator', () {
    group('calculate()', () {
      test('calculates normal overnight sleep correctly', () {
        final bedtime = DateTime(2024, 1, 1, 23, 0); // 23:00
        final wakeTime = DateTime(2024, 1, 2, 7, 0); // 07:00 next day
        final duration = SleepDurationCalculator.calculate(
          bedtime: bedtime,
          wakeTime: wakeTime,
        );
        expect(duration.inHours, 8);
      });

      test('handles same-day sleep (e.g. nap)', () {
        final bedtime = DateTime(2024, 1, 1, 14, 0);
        final wakeTime = DateTime(2024, 1, 1, 15, 30);
        final duration = SleepDurationCalculator.calculate(
          bedtime: bedtime,
          wakeTime: wakeTime,
        );
        expect(duration.inMinutes, 90);
      });

      test('handles midnight crossover correctly', () {
        final bedtime = DateTime(2024, 1, 1, 23, 30); // 23:30
        final wakeTime = DateTime(2024, 1, 2, 6, 0); // 06:00
        final duration = SleepDurationCalculator.calculate(
          bedtime: bedtime,
          wakeTime: wakeTime,
        );
        expect(duration.inMinutes, 390); // 6h30m
      });

      test(
        'returns correct duration when wakeTime before bedtime (same date)',
        () {
          final bedtime = DateTime(2024, 1, 1, 22, 0);
          final wakeTime = DateTime(
            2024,
            1,
            1,
            6,
            0,
          ); // appears negative but logically next day
          final duration = SleepDurationCalculator.calculate(
            bedtime: bedtime,
            wakeTime: wakeTime,
          );
          expect(duration.inHours, 8); // treated as next day by adding 1 day
        },
      );
    });

    group('calculateQualityScore()', () {
      test('returns 80 for 8h uninterrupted with deep sleep', () {
        final score = SleepDurationCalculator.calculateQualityScore(
          sleepDuration: const Duration(hours: 8),
          disturbanceCount: 0,
          hadDeepSleep: true,
        );
        expect(score, 80);
      });

      test('returns 50 for 7h sleep, no deep sleep, no disturbances', () {
        final score = SleepDurationCalculator.calculateQualityScore(
          sleepDuration: const Duration(hours: 7),
          disturbanceCount: 0,
          hadDeepSleep: false,
        );
        expect(score, 50);
      });

      test('penalizes disturbances. 8h + deep sleep, 4 disturbances', () {
        final score = SleepDurationCalculator.calculateQualityScore(
          sleepDuration: const Duration(hours: 8),
          disturbanceCount: 4,
          hadDeepSleep: true,
        );
        expect(score, 60); // 60 + 20 - 20 = 60
      });

      test('clamps score to 0 minimum', () {
        final score = SleepDurationCalculator.calculateQualityScore(
          sleepDuration: const Duration(hours: 2),
          disturbanceCount: 10,
          hadDeepSleep: false,
        );
        expect(score, greaterThanOrEqualTo(0));
        expect(score, lessThanOrEqualTo(100));
      });

      test('clamps score to 100 maximum', () {
        final score = SleepDurationCalculator.calculateQualityScore(
          sleepDuration: const Duration(hours: 10),
          disturbanceCount: 0,
          hadDeepSleep: true,
        );
        expect(score, lessThanOrEqualTo(100));
      });
    });

    group('calculateWeeklyAverage()', () {
      test('returns Duration.zero for empty list', () {
        final avg = SleepDurationCalculator.calculateWeeklyAverage([]);
        expect(avg, Duration.zero);
      });

      test('returns correct average for equal durations', () {
        final durations = List.filled(7, const Duration(hours: 8));
        final avg = SleepDurationCalculator.calculateWeeklyAverage(durations);
        expect(avg.inHours, 8);
      });

      test('returns correct average for mixed durations', () {
        final durations = [
          const Duration(hours: 6),
          const Duration(hours: 8),
          const Duration(hours: 10),
        ];
        final avg = SleepDurationCalculator.calculateWeeklyAverage(durations);
        expect(avg.inHours, 8);
      });
    });

    group('calculateSleepDebt()', () {
      test('returns zero when sleeping enough', () {
        final durations = List.filled(7, const Duration(hours: 8));
        final debt = SleepDurationCalculator.calculateSleepDebt(
          weeklyDurations: durations,
        );
        expect(debt, Duration.zero);
      });

      test('returns correct debt for undersleeping', () {
        final durations = List.filled(7, const Duration(hours: 6));
        final debt = SleepDurationCalculator.calculateSleepDebt(
          weeklyDurations: durations,
          targetPerNight: const Duration(hours: 8),
        );
        expect(debt.inHours, 14); // 7 nights * 2h short = 14h
      });

      test('returns zero for oversleeping (no negative debt)', () {
        final durations = List.filled(7, const Duration(hours: 10));
        final debt = SleepDurationCalculator.calculateSleepDebt(
          weeklyDurations: durations,
        );
        expect(debt, Duration.zero);
      });
    });

    group('calculateConsistencyScore()', () {
      test('returns 1.0 for single bedtime', () {
        final score = SleepDurationCalculator.calculateConsistencyScore([
          DateTime(2024, 1, 1, 23, 0),
        ]);
        expect(score, 1.0);
      });

      test('returns 1.0 for identical bedtimes', () {
        final bedtimes = List.generate(7, (_) => DateTime(2024, 1, 1, 23, 0));
        final score = SleepDurationCalculator.calculateConsistencyScore(
          bedtimes,
        );
        expect(score, closeTo(1.0, 0.01));
      });

      test('returns lower score for highly variable bedtimes', () {
        final bedtimes = [
          DateTime(2024, 1, 1, 21, 0),
          DateTime(2024, 1, 2, 1, 0),
          DateTime(2024, 1, 3, 23, 0),
          DateTime(2024, 1, 4, 2, 0),
        ];
        final score = SleepDurationCalculator.calculateConsistencyScore(
          bedtimes,
        );
        expect(score, lessThan(0.8));
      });

      test('result is clamped between 0.0 and 1.0', () {
        final bedtimes = [
          DateTime(2024, 1, 1, 8, 0),
          DateTime(2024, 1, 2, 23, 0),
        ];
        final score = SleepDurationCalculator.calculateConsistencyScore(
          bedtimes,
        );
        expect(score, inInclusiveRange(0.0, 1.0));
      });
    });
  });
}
