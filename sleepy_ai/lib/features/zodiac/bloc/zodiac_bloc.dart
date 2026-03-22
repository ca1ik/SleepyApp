import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleepy_ai/features/zodiac/bloc/zodiac_event.dart';
import 'package:sleepy_ai/features/zodiac/bloc/zodiac_state.dart';
import 'package:sleepy_ai/features/zodiac/domain/zodiac_models.dart';

class ZodiacBloc extends Bloc<ZodiacEvent, ZodiacState> {
  ZodiacBloc() : super(const ZodiacState()) {
    on<ZodiacSelectSign>(_onSelectSign);
    on<ZodiacSetBirthDate>(_onSetBirthDate);
    on<ZodiacCalculateCompatibility>(_onCalculateCompatibility);
    on<ZodiacLoadDailyHoroscope>(_onLoadDailyHoroscope);
    on<ZodiacLoadAllCompatibilities>(_onLoadAllCompatibilities);
  }

  void _onSelectSign(ZodiacSelectSign event, Emitter<ZodiacState> emit) {
    emit(state.copyWith(selectedSign: event.sign));
  }

  void _onSetBirthDate(ZodiacSetBirthDate event, Emitter<ZodiacState> emit) {
    final sign = ZodiacSign.fromDate(event.date);
    emit(state.copyWith(birthDate: event.date, selectedSign: sign));
  }

  void _onCalculateCompatibility(
    ZodiacCalculateCompatibility event,
    Emitter<ZodiacState> emit,
  ) {
    final compat = ZodiacCompatibility.calculate(event.sign1, event.sign2);
    emit(state.copyWith(compatibility: compat));
  }

  void _onLoadAllCompatibilities(
    ZodiacLoadAllCompatibilities event,
    Emitter<ZodiacState> emit,
  ) {
    final results = ZodiacSign.values
        .where((s) => s != event.sign)
        .map((s) => ZodiacCompatibility.calculate(event.sign, s))
        .toList()
      ..sort((a, b) => b.overallScore.compareTo(a.overallScore));
    emit(state.copyWith(allCompatibilities: results, selectedSign: event.sign));
  }

  void _onLoadDailyHoroscope(
    ZodiacLoadDailyHoroscope event,
    Emitter<ZodiacState> emit,
  ) {
    emit(state.copyWith(isLoading: true));

    // Generate deterministic daily horoscope based on date + sign
    final today = DateTime.now();
    final seed =
        today.year * 10000 + today.month * 100 + today.day + event.sign.index;
    final rng = math.Random(seed);

    final generalKeys = List.generate(5, (i) => 'horoscope_general_${i + 1}');
    final sleepKeys = List.generate(5, (i) => 'horoscope_sleep_${i + 1}');
    final moodKeys = [
      'mood_calm',
      'mood_energetic',
      'mood_reflective',
      'mood_creative',
      'mood_peaceful'
    ];
    final colorKeys = [
      'color_purple',
      'color_blue',
      'color_gold',
      'color_silver',
      'color_teal'
    ];
    final astralKeys = List.generate(5, (i) => 'horoscope_astral_${i + 1}');

    final horoscope = DailyHoroscope(
      sign: event.sign,
      date: today,
      generalKey: generalKeys[rng.nextInt(generalKeys.length)],
      sleepAdviceKey: sleepKeys[rng.nextInt(sleepKeys.length)],
      luckyNumber: rng.nextInt(99) + 1,
      luckyColorKey: colorKeys[rng.nextInt(colorKeys.length)],
      moodKey: moodKeys[rng.nextInt(moodKeys.length)],
      energyLevel: rng.nextInt(5) + 1,
      astralTipKey: astralKeys[rng.nextInt(astralKeys.length)],
    );

    emit(state.copyWith(dailyHoroscope: horoscope, isLoading: false));
  }
}
