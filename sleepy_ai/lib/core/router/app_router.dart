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
import 'package:sleepy_ai/features/pro/presentation/sleepy_assistant_page.dart';
import 'package:sleepy_ai/features/rewards/presentation/rewards_page.dart';
import 'package:sleepy_ai/features/settings/presentation/settings_page.dart';
import 'package:sleepy_ai/features/sleep_tracking/presentation/sleep_tracking_page.dart';
import 'package:sleepy_ai/features/games/presentation/breathing_game_page.dart';
import 'package:sleepy_ai/features/games/presentation/games_hub_page.dart';
import 'package:sleepy_ai/features/games/presentation/sleep_films_page.dart';
import 'package:sleepy_ai/features/games/presentation/star_catcher_page.dart';
import 'package:sleepy_ai/features/games/presentation/bubble_pop_page.dart';
import 'package:sleepy_ai/features/games/presentation/sheep_counter_page.dart';
import 'package:sleepy_ai/features/sounds/presentation/sounds_page.dart';
import 'package:sleepy_ai/features/level_system/presentation/sleep_hero_page.dart';
import 'package:sleepy_ai/features/zodiac/presentation/zodiac_hub_page.dart';
import 'package:sleepy_ai/features/zodiac/presentation/zodiac_detail_page.dart';
import 'package:sleepy_ai/features/zodiac/presentation/zodiac_compatibility_page.dart';
import 'package:sleepy_ai/features/zodiac/presentation/astral_exercises_page.dart';
import 'package:sleepy_ai/features/zodiac/presentation/astral_exercise_detail_page.dart';
import 'package:sleepy_ai/features/games/presentation/dream_labyrinth_page.dart';
import 'package:sleepy_ai/features/games/presentation/moon_runner_page.dart';
import 'package:sleepy_ai/features/games/presentation/nebula_match_page.dart';
import 'package:sleepy_ai/features/games/presentation/galaxy_puzzle_page.dart';
import 'package:sleepy_ai/features/games/presentation/cosmic_flow_page.dart';

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
    GetPage(
      name: AppStrings.routeChatbot,
      page: () => const SleepyAssistantPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppStrings.routeGames,
      page: () => const GamesHubPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppStrings.routeBreathingGame,
      page: () => const BreathingGamePage(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppStrings.routeStarCatcher,
      page: () => const StarCatcherPage(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppStrings.routeSleepFilms,
      page: () => const SleepFilmsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppStrings.routeBubblePop,
      page: () => const BubblePopPage(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppStrings.routeSheepCounter,
      page: () => const SheepCounterPage(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppStrings.routeSleepHero,
      page: () => const SleepHeroPage(showBackButton: true),
      transition: Transition.downToUp,
    ),

    // ── Zodiac & Astral ────────────────────────────────────────────────
    GetPage(
      name: AppStrings.routeZodiac,
      page: () => const ZodiacHubPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppStrings.routeZodiacDetail,
      page: () => const ZodiacDetailPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppStrings.routeZodiacCompatibility,
      page: () => const ZodiacCompatibilityPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppStrings.routeAstralExercises,
      page: () => const AstralExercisesPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppStrings.routeAstralExerciseDetail,
      page: () => const AstralExerciseDetailPage(),
      transition: Transition.rightToLeft,
    ),

    // ── New Games ──────────────────────────────────────────────────────
    GetPage(
      name: AppStrings.routeDreamLabyrinth,
      page: () => const DreamLabyrinthPage(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppStrings.routeMoonRunner,
      page: () => const MoonRunnerPage(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppStrings.routeNebulaMatch,
      page: () => const NebulaMatchPage(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppStrings.routeGalaxyPuzzle,
      page: () => const GalaxyPuzzlePage(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppStrings.routeCosmicFlow,
      page: () => const CosmicFlowPage(),
      transition: Transition.downToUp,
    ),
  ];
}
