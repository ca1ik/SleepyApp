import 'package:flutter/widgets.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/shared/services/atmospheric_music_manager.dart';

/// A [NavigatorObserver] that automatically switches the
/// [AtmosphericMusicManager] context based on the current route.
///
/// Register this in GetMaterialApp's `navigatorObservers`.
class AtmosphericRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateContext(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) _updateContext(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) _updateContext(newRoute);
  }

  void _updateContext(Route<dynamic> route) {
    final name = route.settings.name;
    if (name == null) return;

    final context = _resolveContext(name);
    AtmosphericMusicManager.instance.setContext(context);
  }

  /// Map route names to atmospheric contexts.
  static AtmosphericContext _resolveContext(String routeName) {
    // Zodiac / Astral screens → zodiac ambience
    if (routeName.startsWith(AppStrings.routeZodiac) ||
        routeName.startsWith(AppStrings.routeAstralExercises)) {
      // Distinguish astral exercise detail (meditation) from zodiac hub
      if (routeName == AppStrings.routeAstralExerciseDetail) {
        return AtmosphericContext.astral;
      }
      if (routeName == AppStrings.routeAstralExercises) {
        return AtmosphericContext.astral;
      }
      return AtmosphericContext.zodiac;
    }

    // Game screens → games music
    if (routeName.startsWith('/games')) {
      // The hub itself gets the galaxy vibe; individual games get games music.
      if (routeName == AppStrings.routeGames) {
        return AtmosphericContext.galaxy;
      }
      return AtmosphericContext.games;
    }

    // Sleep tracking → sleep ambience
    if (routeName == AppStrings.routeSleepTracking) {
      return AtmosphericContext.sleep;
    }

    // Sounds page — let the user's mixer dominate; no atmospheric overlay.
    if (routeName == AppStrings.routeSounds ||
        routeName == AppStrings.routeSoundMixer ||
        routeName == AppStrings.routeMoodMusic ||
        routeName == AppStrings.routeCreateMusic) {
      return AtmosphericContext.none;
    }

    // Default: no atmospheric music (login, dashboard, settings, etc.)
    return AtmosphericContext.none;
  }
}
