import 'package:flutter/material.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';

/// DateTime ile ilgili extension metodlar
extension DateTimeExtensions on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isToday() => isSameDay(DateTime.now());

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }

  String toFormattedDate() {
    final months = [
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ];
    return '$day ${months[month - 1]} $year';
  }

  String toTimeString() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

/// Duration extension metodlar
extension DurationExtensions on Duration {
  String toHoursMinutes() {
    final h = inHours;
    final m = inMinutes.remainder(60);
    if (h == 0) return '${m}dk';
    if (m == 0) return '${h}sa';
    return '${h}sa ${m}dk';
  }

  String toSleepScore() {
    final hours = inHours;
    if (hours >= 8) return 'Mükemmel';
    if (hours >= 7) return 'İyi';
    if (hours >= 6) return 'Orta';
    return 'Yetersiz';
  }
}

/// String extension metodlar
extension StringExtensions on String {
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  bool get isValidPassword => length >= 8;
}

/// Int (sleep score) extension
extension SleepScoreExtension on int {
  Color toScoreColor() {
    if (this >= 85) return AppColors.scoreExcellent;
    if (this >= 70) return AppColors.scoreGood;
    if (this >= 55) return AppColors.scoreFair;
    return AppColors.scorePoor;
  }

  String toScoreLabel() {
    if (this >= 85) return 'Mükemmel';
    if (this >= 70) return 'İyi';
    if (this >= 55) return 'Orta';
    return 'Zayıf';
  }
}

/// BuildContext extension — theme/media hızlı erişim
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  bool get isSmallScreen => screenWidth < 360;

  void showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.backgroundCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    );
  }
}
