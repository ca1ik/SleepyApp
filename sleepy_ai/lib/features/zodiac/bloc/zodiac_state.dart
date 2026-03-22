import 'package:equatable/equatable.dart';
import 'package:sleepy_ai/features/zodiac/domain/zodiac_models.dart';

class ZodiacState extends Equatable {
  const ZodiacState({
    this.selectedSign,
    this.birthDate,
    this.compatibility,
    this.allCompatibilities = const [],
    this.dailyHoroscope,
    this.isLoading = false,
  });

  final ZodiacSign? selectedSign;
  final DateTime? birthDate;
  final ZodiacCompatibility? compatibility;
  final List<ZodiacCompatibility> allCompatibilities;
  final DailyHoroscope? dailyHoroscope;
  final bool isLoading;

  ZodiacState copyWith({
    ZodiacSign? selectedSign,
    DateTime? birthDate,
    ZodiacCompatibility? compatibility,
    List<ZodiacCompatibility>? allCompatibilities,
    DailyHoroscope? dailyHoroscope,
    bool? isLoading,
  }) =>
      ZodiacState(
        selectedSign: selectedSign ?? this.selectedSign,
        birthDate: birthDate ?? this.birthDate,
        compatibility: compatibility ?? this.compatibility,
        allCompatibilities: allCompatibilities ?? this.allCompatibilities,
        dailyHoroscope: dailyHoroscope ?? this.dailyHoroscope,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object?> get props => [
        selectedSign,
        birthDate,
        compatibility,
        allCompatibilities,
        dailyHoroscope,
        isLoading,
      ];
}
