import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/features/auth/presentation/forgot_password_page.dart';
import 'package:sleepy_ai/features/auth/presentation/login_page.dart';
import 'package:sleepy_ai/features/auth/presentation/register_page.dart';
import 'package:sleepy_ai/features/auth/presentation/splash_page.dart';
import 'package:sleepy_ai/features/dashboard/presentation/dashboard_page.dart';
import 'package:sleepy_ai/features/feedback/presentation/feedback_page.dart';
import 'package:sleepy_ai/features/learning/presentation/learning_page.dart';
import 'package:sleepy_ai/features/pro/presentation/pro_paywall_page.dart';
import 'package:sleepy_ai/features/rewards/presentation/rewards_page.dart';
import 'package:sleepy_ai/features/settings/presentation/settings_page.dart';
import 'package:sleepy_ai/features/sleep_tracking/presentation/sleep_tracking_page.dart';
import 'package:sleepy_ai/features/sounds/presentation/sounds_page.dart';

/// GetX yönlendirme tablosu.
/// Tüm sayfalar buraya kayıtlıdır ve [AppStrings] rotaları kullanılır.
abstract final class AppRouter {
  AppRouter._();

  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: AppStrings.routeSplash,
      page: () => const SplashPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppStrings.routeLogin,
      page: () => const LoginPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppStrings.routeRegister,
      page: () => const RegisterPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppStrings.routeForgotPassword,
      page: () => const ForgotPasswordPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppStrings.routeDashboard,
      page: () => const DashboardPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppStrings.routeSleepTracking,
      page: () => const SleepTrackingPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppStrings.routeSounds,
      page: () => const SoundsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppStrings.routeLearning,
      page: () => const LearningPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppStrings.routeRewards,
      page: () => const RewardsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppStrings.routeFeedback,
      page: () => const FeedbackPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppStrings.routePro,
      page: () => const ProPaywallPage(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppStrings.routeSettings,
      page: () => const SettingsPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
