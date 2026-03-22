import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/features/auth/bloc/auth_bloc.dart';
import 'package:sleepy_ai/features/auth/data/auth_repository.dart';
import 'package:sleepy_ai/features/feedback/cubit/feedback_cubit.dart';
import 'package:sleepy_ai/features/learning/cubit/learning_cubit.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_cubit.dart';
import 'package:sleepy_ai/features/pro/data/pro_repository.dart';
import 'package:sleepy_ai/features/rewards/cubit/rewards_cubit.dart';
import 'package:sleepy_ai/features/settings/cubit/settings_cubit.dart';
import 'package:sleepy_ai/features/sleep_tracking/bloc/sleep_cycle_bloc.dart';
import 'package:sleepy_ai/features/sleep_tracking/data/sleep_repository.dart';
import 'package:sleepy_ai/features/sounds/cubit/sounds_cubit.dart';
import 'package:sleepy_ai/features/sounds/data/sounds_repository.dart';
import 'package:sleepy_ai/features/level_system/cubit/level_cubit.dart';
import 'package:sleepy_ai/features/level_system/data/level_repository.dart';
import 'package:sleepy_ai/features/zodiac/bloc/zodiac_bloc.dart';

/// Basit bağımlılık enjeksiyon konteyneri.
/// GetIt yerine manuel singleton pattern — pakete bağımlılık yok.
class InjectionContainer {
  InjectionContainer._();

  static late SharedPreferences _prefs;

  /// Exposed for widgets that need SharedPreferences directly (e.g. ThemeProvider)
  static SharedPreferences get prefs => _prefs;

  /// Uygulama başlamadan önce çağrılmalıdır
  static Future<void> init() async {
    await Hive.initFlutter();
    _prefs = await SharedPreferences.getInstance();

    await Hive.openBox<dynamic>(AppStrings.boxSleepLogs);
    await Hive.openBox<dynamic>(AppStrings.boxSettings);
    await Hive.openBox<dynamic>(AppStrings.boxFavorites);
  }

  // ── Repositories ─────────────────────────────────────────────────────

  static AuthRepository get authRepository => MockAuthRepository();

  static SleepRepository get sleepRepository =>
      LocalSleepRepository(userId: '');

  static SoundsRepository get soundsRepository => LocalSoundsRepository();

  static ProRepository get proRepository => LocalProRepository(_prefs);

  static LevelRepository get levelRepository => LocalLevelRepository(_prefs);

  // ── BLoCs / Cubits ────────────────────────────────────────────────────

  static AuthBloc createAuthBloc() => AuthBloc(authRepository: authRepository);

  static SleepCycleBloc createSleepBloc() =>
      SleepCycleBloc(repository: sleepRepository);

  static SoundsCubit createSoundsCubit() =>
      SoundsCubit(repository: soundsRepository);

  static LearningCubit createLearningCubit() => LearningCubit();

  static RewardsCubit createRewardsCubit() => RewardsCubit();

  static FeedbackCubit createFeedbackCubit() => FeedbackCubit();

  static ProCubit createProCubit() => ProCubit(proRepository);

  static SettingsCubit createSettingsCubit() => SettingsCubit(_prefs);

  static LevelCubit createLevelCubit() => LevelCubit(levelRepository);

  static ZodiacBloc createZodiacBloc() => ZodiacBloc();
}
