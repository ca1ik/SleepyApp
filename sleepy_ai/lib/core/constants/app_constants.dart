// ignore_for_file: public_member_api_docs
/// Animasyon süreleri ve eğri sabitleri.
/// Tutarlı animasyon deneyimi için tek kaynak.
abstract final class AppDurations {
  static const Duration fastest = Duration(milliseconds: 150);
  static const Duration fast = Duration(milliseconds: 250);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 750);
  static const Duration slowest = Duration(milliseconds: 1000);

  // Özel süreler
  static const Duration splashDelay = Duration(seconds: 2);
  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Duration snackbar = Duration(seconds: 3);
  static const Duration tooltipDelay = Duration(milliseconds: 800);
  static const Duration shimmerLoop = Duration(milliseconds: 1500);

  AppDurations._();
}

/// Uygulama genelinde string sabitler (route isimleri, asset yolları vb.)
abstract final class AppStrings {
  // ── App Info ─────────────────────────────────────────────────────────
  static const String appName = 'SleepyApp';
  static const String appTagline = 'Sleep Better. Live Better.';
  static const String appVersion = '1.0.0';

  // ── Routes ───────────────────────────────────────────────────────────
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeForgotPassword = '/forgot-password';
  static const String routeDashboard = '/dashboard';
  static const String routeSleepTracking = '/sleep-tracking';
  static const String routeSounds = '/sounds';
  static const String routeSoundMixer = '/sound-mixer';
  static const String routeLearning = '/learning';
  static const String routeArticleDetail = '/article-detail';
  static const String routeRewards = '/rewards';
  static const String routeProfile = '/profile';
  static const String routeSettings = '/settings';
  static const String routeFeedback = '/feedback';
  static const String routePro = '/pro';
  static const String routeChatbot = '/chatbot';
  static const String routeMoodMusic = '/mood-music';
  static const String routeCreateMusic = '/create-music';

  // ── Hive Box Names ───────────────────────────────────────────────────
  static const String boxSleepLogs = 'sleep_logs';
  static const String boxSettings = 'settings';
  static const String boxFavorites = 'favorites';
  static const String boxUser = 'user';

  // ── Secure Storage Keys ──────────────────────────────────────────────
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';

  // ── SharedPreferences Keys ───────────────────────────────────────────
  static const String prefOnboardingDone = 'onboarding_done';
  static const String prefThemeMode = 'theme_mode';
  static const String prefLocale = 'locale';
  static const String prefIsPro = 'is_pro';
  static const String prefNotificationsEnabled = 'notifications_enabled';
  static const String prefBedtimeHour = 'bedtime_hour';
  static const String prefBedtimeMinute = 'bedtime_minute';

  // ── MethodChannel ────────────────────────────────────────────────────
  static const String alarmChannel = 'com.sleepyapp.sleepy_ai/alarm';
  static const String alarmMethodSet = 'setAlarm';
  static const String alarmMethodCancel = 'cancelAlarm';
  static const String alarmMethodCheck = 'isAlarmSet';

  // ── IAP Product IDs ──────────────────────────────────────────────────
  static const String iapProMonthly = 'sleepyapp_pro_monthly';
  static const String iapProYearly = 'sleepyapp_pro_yearly';

  // ── API ──────────────────────────────────────────────────────────────
  static const String apiBaseUrl = 'https://api.sleepyapp.example.com/v1';
  static const String apiSleepTips = '/sleep-tips';
  static const String apiMoodSuggestion = '/mood-suggestion';
  static const String apiAiStory = '/ai-story';

  AppStrings._();
}
