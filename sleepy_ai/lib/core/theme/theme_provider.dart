import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';

/// Provider ile yönetilen tema ve ayar state'i.
/// Widget tree'nin tepesinden inject edilir.
class ThemeProvider extends ChangeNotifier {
  ThemeProvider(this._prefs) {
    _loadSettings();
  }

  final SharedPreferences _prefs;

  bool _isDarkMode = true;
  Locale _locale = const Locale('tr');
  bool _notificationsEnabled = true;
  int _bedtimeHour = 22;
  int _bedtimeMinute = 30;

  bool get isDarkMode => _isDarkMode;
  Locale get locale => _locale;
  bool get notificationsEnabled => _notificationsEnabled;
  int get bedtimeHour => _bedtimeHour;
  int get bedtimeMinute => _bedtimeMinute;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void _loadSettings() {
    _isDarkMode = _prefs.getBool(AppStrings.prefThemeMode) ?? true;
    final localeCode = _prefs.getString(AppStrings.prefLocale) ?? 'tr';
    _locale = Locale(localeCode);
    _notificationsEnabled =
        _prefs.getBool(AppStrings.prefNotificationsEnabled) ?? true;
    _bedtimeHour = _prefs.getInt(AppStrings.prefBedtimeHour) ?? 22;
    _bedtimeMinute = _prefs.getInt(AppStrings.prefBedtimeMinute) ?? 30;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool(AppStrings.prefThemeMode, _isDarkMode);
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    _locale = Locale(languageCode);
    await _prefs.setString(AppStrings.prefLocale, languageCode);
    notifyListeners();
  }

  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    await _prefs.setBool(
      AppStrings.prefNotificationsEnabled,
      _notificationsEnabled,
    );
    notifyListeners();
  }

  Future<void> setBedtime(int hour, int minute) async {
    _bedtimeHour = hour;
    _bedtimeMinute = minute;
    await _prefs.setInt(AppStrings.prefBedtimeHour, hour);
    await _prefs.setInt(AppStrings.prefBedtimeMinute, minute);
    notifyListeners();
  }
}
