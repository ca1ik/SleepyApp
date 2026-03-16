import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/core/error/failures.dart';
import 'package:sleepy_ai/shared/models/entities.dart';

abstract class SleepRepository {
  /// Son 7 günün uyku kayıtlarını döner (en yeniden en eskiye).
  Future<Either<Failure, List<SleepEntity>>> getLast7DaysRecords();

  /// Yeni kayıt ekler.
  Future<Either<Failure, void>> saveSleepRecord(SleepEntity record);

  /// Kaydı ID ile siler.
  Future<Either<Failure, void>> deleteRecord(String id);

  /// Hedef uyku süresini (saat) okur.
  double getSleepGoalHours();

  /// Hedef uyku süresini (saat) kaydeder.
  Future<void> saveSleepGoalHours(double hours);

  /// Yatış / kalkış saatlerini kaydeder.
  Future<void> saveBedtimeSchedule({
    required TimeOfDay bedTime,
    required TimeOfDay wakeTime,
  });

  /// Mevcut oturumdaki kullanıcı ID'si.
  String get currentUserId;
}

/// Hive tabanlı yerel uygulama — Firebase senkronizasyonu daha sonra eklenir.
class LocalSleepRepository implements SleepRepository {
  LocalSleepRepository({required this.userId});

  @override
  final String userId;

  @override
  String get currentUserId => userId;

  Box<Map> get _box => Hive.box<Map>(AppStrings.boxSleepLogs);

  @override
  Future<Either<Failure, List<SleepEntity>>> getLast7DaysRecords() async {
    try {
      final cutoff = DateTime.now().subtract(const Duration(days: 7));
      final records =
          _box.values
              .map((m) => SleepEntity.fromMap(Map<String, dynamic>.from(m)))
              .where((r) => r.bedtime.isAfter(cutoff))
              .toList()
            ..sort((a, b) => b.bedtime.compareTo(a.bedtime));
      return Right(records);
    } catch (e) {
      return Left(CacheFailure('Uyku geçmişi yüklenemedi: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveSleepRecord(SleepEntity record) async {
    try {
      await _box.put(record.id, record.toMap());
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Kayıt kaydedilemedi: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecord(String id) async {
    try {
      await _box.delete(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Kayıt silinemedi: $e'));
    }
  }

  @override
  double getSleepGoalHours() {
    final prefs = Hive.box(AppStrings.boxSettings);
    return (prefs.get('sleep_goal_hours') as num?)?.toDouble() ?? 8.0;
  }

  @override
  Future<void> saveSleepGoalHours(double hours) async {
    final prefs = Hive.box(AppStrings.boxSettings);
    await prefs.put('sleep_goal_hours', hours);
  }

  @override
  Future<void> saveBedtimeSchedule({
    required TimeOfDay bedTime,
    required TimeOfDay wakeTime,
  }) async {
    final prefs = Hive.box(AppStrings.boxSettings);
    await prefs.put('bed_hour', bedTime.hour);
    await prefs.put('bed_minute', bedTime.minute);
    await prefs.put('wake_hour', wakeTime.hour);
    await prefs.put('wake_minute', wakeTime.minute);
  }
}
