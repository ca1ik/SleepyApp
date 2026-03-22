import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/core/di/injection_container.dart';
import 'package:sleepy_ai/core/router/app_router.dart';
import 'package:sleepy_ai/core/theme/app_theme.dart';
import 'package:sleepy_ai/core/theme/theme_provider.dart';
import 'package:sleepy_ai/features/auth/bloc/auth_bloc.dart';
import 'package:sleepy_ai/features/auth/bloc/auth_event.dart';
import 'package:sleepy_ai/features/learning/cubit/learning_cubit.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_cubit.dart';
import 'package:sleepy_ai/features/rewards/cubit/rewards_cubit.dart';
import 'package:sleepy_ai/features/settings/cubit/settings_cubit.dart';
import 'package:sleepy_ai/features/sleep_tracking/bloc/sleep_cycle_bloc.dart';
import 'package:sleepy_ai/features/sounds/cubit/sounds_cubit.dart';
import 'package:sleepy_ai/features/level_system/cubit/level_cubit.dart';
import 'package:sleepy_ai/features/zodiac/bloc/zodiac_bloc.dart';
import 'package:sleepy_ai/core/l10n/app_translations.dart';
import 'package:sleepy_ai/features/settings/cubit/settings_state.dart';
import 'package:sleepy_ai/shared/services/atmospheric_music_manager.dart';
import 'package:sleepy_ai/shared/services/atmospheric_route_observer.dart';

// Uncomment after adding google-services.json:
// import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0118),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await InjectionContainer.init();

  // Uncomment when google-services.json is present:
  // await Firebase.initializeApp();

  runApp(const SleepyApp());
}

class SleepyApp extends StatefulWidget {
  const SleepyApp({super.key});

  @override
  State<SleepyApp> createState() => _SleepyAppState();
}

class _SleepyAppState extends State<SleepyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AtmosphericMusicManager.instance.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final mgr = AtmosphericMusicManager.instance;
    if (state == AppLifecycleState.paused) {
      mgr.onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      mgr.onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(InjectionContainer.prefs),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => InjectionContainer.createAuthBloc()
              ..add(const AuthCheckRequested()),
          ),
          BlocProvider<SleepCycleBloc>(
            create: (_) => InjectionContainer.createSleepBloc(),
          ),
          BlocProvider<SoundsCubit>(
            create: (_) => InjectionContainer.createSoundsCubit(),
          ),
          BlocProvider<LearningCubit>(
            create: (_) => InjectionContainer.createLearningCubit(),
          ),
          BlocProvider<RewardsCubit>(
            create: (_) =>
                InjectionContainer.createRewardsCubit()..loadBadges(),
          ),
          BlocProvider<SettingsCubit>(
            create: (_) => InjectionContainer.createSettingsCubit(),
          ),
          BlocProvider<ProCubit>(
            create: (_) =>
                InjectionContainer.createProCubit()..checkProStatus(),
          ),
          BlocProvider<LevelCubit>(
            create: (_) => InjectionContainer.createLevelCubit()..loadHero(),
          ),
          BlocProvider<ZodiacBloc>(
            create: (_) => InjectionContainer.createZodiacBloc(),
          ),
        ],
        child: Consumer<ThemeProvider>(
          builder: (_, themeProvider, __) =>
              BlocBuilder<SettingsCubit, SettingsState>(
            builder: (_, settingsState) => GetMaterialApp(
              title: AppStrings.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkTheme,
              initialRoute: AppStrings.routeSplash,
              getPages: AppRouter.routes,
              navigatorObservers: [AtmosphericRouteObserver()],
              translations: AppTranslations(),
              locale: settingsState.locale,
              fallbackLocale: const Locale('en'),
              supportedLocales: const [
                Locale('en'),
                Locale('tr'),
                Locale('de'),
                Locale('es'),
                Locale('it'),
                Locale('fr'),
                Locale('zh'),
                Locale('ja'),
                Locale('ko'),
                Locale('ar'),
                Locale('ru'),
                Locale('pt'),
                Locale('hi'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
