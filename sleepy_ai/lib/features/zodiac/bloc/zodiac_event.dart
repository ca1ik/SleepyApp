import 'package:equatable/equatable.dart';
import 'package:sleepy_ai/features/zodiac/domain/zodiac_models.dart';

abstract class ZodiacEvent extends Equatable {
  const ZodiacEvent();
  @override
  List<Object?> get props => [];
}

class ZodiacSelectSign extends ZodiacEvent {
  const ZodiacSelectSign(this.sign);
  final ZodiacSign sign;
  @override
  List<Object?> get props => [sign];
}

class ZodiacSetBirthDate extends ZodiacEvent {
  const ZodiacSetBirthDate(this.date);
  final DateTime date;
  @override
  List<Object?> get props => [date];
}

class ZodiacCalculateCompatibility extends ZodiacEvent {
  const ZodiacCalculateCompatibility(this.sign1, this.sign2);
  final ZodiacSign sign1;
  final ZodiacSign sign2;
  @override
  List<Object?> get props => [sign1, sign2];
}

class ZodiacLoadDailyHoroscope extends ZodiacEvent {
  const ZodiacLoadDailyHoroscope(this.sign);
  final ZodiacSign sign;
  @override
  List<Object?> get props => [sign];
}

class ZodiacLoadAllCompatibilities extends ZodiacEvent {
  const ZodiacLoadAllCompatibilities(this.sign);
  final ZodiacSign sign;
  @override
  List<Object?> get props => [sign];
}
