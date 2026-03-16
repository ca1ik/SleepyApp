/// Uyku süresi hesaplama yardımcı sınıfı.
/// Tüm metodlar pure function — unit test için tasarlanmıştır.
abstract final class SleepDurationCalculator {
  /// İki DateTime arasındaki uyku süresini hesaplar.
  /// Gece yarısı geçişini doğru şekilde ele alır.
  ///
  /// Örnek: 23:00 yatış, 07:00 kalkış → 8 saat
  /// Örnek: 01:00 yatış, 07:00 kalkış → 6 saat (aynı gün)
  static Duration calculate({
    required DateTime bedtime,
    required DateTime wakeTime,
  }) {
    var duration = wakeTime.difference(bedtime);
    // Eğer negatifse (yani yatış sonraki günden önce), 1 gün ekle
    if (duration.isNegative) {
      duration = wakeTime.add(const Duration(days: 1)).difference(bedtime);
    }
    return duration;
  }

  /// Uyku kalite skoru hesaplar (0–100).
  /// 8 saat optimum kabul edilir.
  static int calculateQualityScore({
    required Duration sleepDuration,
    required int disturbanceCount,
    required bool hadDeepSleep,
  }) {
    var score = 0;

    // Süre skoru (max 60 puan)
    final hours = sleepDuration.inMinutes / 60.0;
    if (hours >= 8.0) {
      score += 60;
    } else if (hours >= 7.0) {
      score += 50;
    } else if (hours >= 6.0) {
      score += 35;
    } else if (hours >= 5.0) {
      score += 20;
    } else {
      score += 10;
    }

    // Derin uyku bonusu (20 puan)
    if (hadDeepSleep) score += 20;

    // Uyku kesintisi penaltı
    final disturbancePenalty = (disturbanceCount * 5).clamp(0, 20);
    score -= disturbancePenalty;

    return score.clamp(0, 100);
  }

  /// Haftalık ortalama uyku süresini hesaplar.
  static Duration calculateWeeklyAverage(List<Duration> durations) {
    if (durations.isEmpty) return Duration.zero;
    final total = durations.fold<int>(0, (sum, d) => sum + d.inMinutes);
    return Duration(minutes: total ~/ durations.length);
  }

  /// Uyku açığını hesaplar (hedef - gerçekleşen).
  static Duration calculateSleepDebt({
    required List<Duration> weeklyDurations,
    Duration targetPerNight = const Duration(hours: 8),
  }) {
    final targetMinutes = targetPerNight.inMinutes * weeklyDurations.length;
    final actualMinutes = weeklyDurations.fold<int>(
      0,
      (sum, d) => sum + d.inMinutes,
    );
    final diff = targetMinutes - actualMinutes;
    return diff > 0 ? Duration(minutes: diff) : Duration.zero;
  }

  /// Yatış tutarlılık skoru (0.0–1.0).
  /// Yatış saatleri birbirine ne kadar yakınsa skor o kadar yüksek.
  static double calculateConsistencyScore(List<DateTime> bedtimes) {
    if (bedtimes.length < 2) return 1.0;

    final minutes = bedtimes.map((d) => d.hour * 60 + d.minute).toList();

    final avg = minutes.reduce((a, b) => a + b) / minutes.length;
    final variance =
        minutes.map((m) => (m - avg) * (m - avg)).reduce((a, b) => a + b) /
        minutes.length;
    final stdDev = variance > 0 ? variance : 1.0;

    // 0–120 dakika standart sapma → 0.0–1.0 ters orantılı skor
    return (1.0 - (stdDev / 120.0)).clamp(0.0, 1.0);
  }

  SleepDurationCalculator._();
}
