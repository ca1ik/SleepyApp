import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.locale = const Locale('en'),
    this.notificationsEnabled = true,
    this.bedtimeHour = 23,
    this.bedtimeMinute = 0,
    this.sleepGoalHours = 8.0,
    this.isDarkMode = true,
    this.isSaving = false,
  });

  final Locale locale;
  final bool notificationsEnabled;
  final int bedtimeHour;
  final int bedtimeMinute;
  final double sleepGoalHours;
  final bool isDarkMode;
  final bool isSaving;

  bool get isTurkish => locale.languageCode == 'tr';

  SettingsState copyWith({
    Locale? locale,
    bool? notificationsEnabled,
    int? bedtimeHour,
    int? bedtimeMinute,
    double? sleepGoalHours,
    bool? isDarkMode,
    bool? isSaving,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      bedtimeHour: bedtimeHour ?? this.bedtimeHour,
      bedtimeMinute: bedtimeMinute ?? this.bedtimeMinute,
      sleepGoalHours: sleepGoalHours ?? this.sleepGoalHours,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [
        locale,
        notificationsEnabled,
        bedtimeHour,
        bedtimeMinute,
        sleepGoalHours,
        isDarkMode,
        isSaving,
      ];
}
