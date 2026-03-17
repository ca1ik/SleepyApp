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

class SleepyApp extends StatelessWidget {
  const SleepyApp({super.key});

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
        ],
        child: Consumer<ThemeProvider>(
          builder: (_, themeProvider, __) => GetMaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            initialRoute: AppStrings.routeSplash,
            getPages: AppRouter.routes,
            locale: const Locale('tr'),
            fallbackLocale: const Locale('en'),
            supportedLocales: const [Locale('tr'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          ),
        ),
      ),
    );
  }
}
