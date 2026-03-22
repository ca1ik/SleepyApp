import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/features/settings/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._prefs) : super(const SettingsState()) {
    _loadSettings();
  }

  final SharedPreferences _prefs;

  void _loadSettings() {
    final localeCode = _prefs.getString(AppStrings.prefLocale) ?? 'en';
    final notificationsEnabled =
        _prefs.getBool(AppStrings.prefNotificationsEnabled) ?? true;
    final bedtimeHour = _prefs.getInt(AppStrings.prefBedtimeHour) ?? 23;
    final bedtimeMinute = _prefs.getInt(AppStrings.prefBedtimeMinute) ?? 0;
    final isDarkMode = _prefs.getBool(AppStrings.prefThemeMode) ?? true;

    emit(
      state.copyWith(
        locale: Locale(localeCode),
        notificationsEnabled: notificationsEnabled,
        bedtimeHour: bedtimeHour,
        bedtimeMinute: bedtimeMinute,
        isDarkMode: isDarkMode,
      ),
    );
  }

  Future<void> toggleTheme() async {
    final newMode = !state.isDarkMode;
    await _prefs.setBool(AppStrings.prefThemeMode, newMode);
    emit(state.copyWith(isDarkMode: newMode));
  }

  Future<void> setLocale(String languageCode) async {
    await _prefs.setString(AppStrings.prefLocale, languageCode);
    Get.updateLocale(Locale(languageCode));
    emit(state.copyWith(locale: Locale(languageCode)));
  }

  Future<void> toggleNotifications({required bool enabled}) async {
    await _prefs.setBool(AppStrings.prefNotificationsEnabled, enabled);
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  Future<void> setBedtime(TimeOfDay time) async {
    await _prefs.setInt(AppStrings.prefBedtimeHour, time.hour);
    await _prefs.setInt(AppStrings.prefBedtimeMinute, time.minute);
    emit(state.copyWith(bedtimeHour: time.hour, bedtimeMinute: time.minute));
  }

  void setSleepGoal(double hours) {
    emit(state.copyWith(sleepGoalHours: hours));
  }
}
