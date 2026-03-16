import 'package:flutter/services.dart';
import 'package:dartz/dartz.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/core/error/failures.dart';

/// Android AlarmManager'a erişim için MethodChannel Dart katmanı.
/// Kotlin tarafı MainActivity.kt içinde tanımlanmıştır.
/// Akıllı uyandırma alarmı kurmak ve iptal etmek için kullanılır.
class AlarmChannelService {
  static const MethodChannel _channel = MethodChannel(AppStrings.alarmChannel);

  /// Belirtilen saat ve dakikada alarm kurar.
  /// Returns [Right(true)] başarı, [Left(PlatformFailure)] hata durumunda.
  Future<Either<Failure, bool>> setAlarm({
    required int hour,
    required int minute,
    String? label,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        AppStrings.alarmMethodSet,
        {'hour': hour, 'minute': minute, 'label': label ?? 'SleepyApp Wake-Up'},
      );
      return Right(result ?? false);
    } on PlatformException catch (e) {
      return Left(PlatformFailure('Alarm kurulamadi: ${e.message}'));
    }
  }

  /// Mevcut alarmı iptal eder.
  Future<Either<Failure, bool>> cancelAlarm() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        AppStrings.alarmMethodCancel,
      );
      return Right(result ?? false);
    } on PlatformException catch (e) {
      return Left(PlatformFailure('Alarm iptal edilemedi: ${e.message}'));
    }
  }

  /// Aktif alarm var mı kontrol eder.
  Future<Either<Failure, bool>> isAlarmSet() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        AppStrings.alarmMethodCheck,
      );
      return Right(result ?? false);
    } on PlatformException catch (e) {
      return Left(
        PlatformFailure('Alarm durumu kontrol edilemedi: ${e.message}'),
      );
    }
  }
}
