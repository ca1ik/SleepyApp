import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleepy_ai/features/level_system/cubit/level_state.dart';
import 'package:sleepy_ai/features/level_system/data/level_repository.dart';
import 'package:sleepy_ai/features/level_system/domain/level_models.dart';

class LevelCubit extends Cubit<LevelState> {
  LevelCubit(this._repository) : super(const LevelState());

  final LevelRepository _repository;

  // ── Load ───────────────────────────────────────────────────────────────────

  Future<void> loadHero() async {
    emit(state.copyWith(status: LevelStatus.loading));
    final hero = await _repository.loadHero();
    final now = DateTime.now();
    SleepHeroModel updatedHero = hero;

    final lastActive = hero.lastActiveDate;
    final isNewDay = lastActive == null ||
        (now.day != lastActive.day ||
            now.month != lastActive.month ||
            now.year != lastActive.year);

    if (isNewDay) {
      // Yeni gün: günlük giriş XP'si ver, seriyi hesapla, görevleri sıfırla
      final streak = _calcStreak(hero, now);
      updatedHero = hero.copyWith(
        totalXp: hero.totalXp + 15,
        streak: streak,
        totalDays: hero.totalDays + 1,
        lastActiveDate: now,
        completedQuestIds: const ['daily_login'],
        lastQuestResetDate: now,
      );
      await _repository.saveHero(updatedHero);
    }

    emit(state.copyWith(
      status: LevelStatus.ready,
      hero: updatedHero,
      dailyQuests: _buildQuests(updatedHero),
    ));
  }

  // ── Earn XP ────────────────────────────────────────────────────────────────

  /// XP kazan. [isPro] gereklidir – Lv 5+ için PRO kapısı var.
  /// Seviye atladıysa [LevelStatus.levelingUp] emit eder.
  Future<void> earnXp(
    int amount, {
    String? questId,
    required bool isPro,
  }) async {
    final hero = state.hero;
    final oldLevel = hero.level;

    // PRO kapısı: Lv 5'te takılı ve PRO değilse → paywall
    if (!isPro && oldLevel >= 5) {
      emit(state.copyWith(status: LevelStatus.proGateReached));
      return;
    }

    // Görevi tamamlanmış olarak işaretle
    final questIds = questId != null
        ? List<String>.from([...hero.completedQuestIds, questId])
        : hero.completedQuestIds;

    final newHero = hero.copyWith(
      totalXp: hero.totalXp + amount,
      completedQuestIds: questIds,
    );

    final newLevel = newHero.level;
    final leveledUp = newLevel > oldLevel;

    await _repository.saveHero(newHero);
    final quests = _buildQuests(newHero);

    if (leveledUp) {
      emit(state.copyWith(
        status: LevelStatus.levelingUp,
        hero: newHero,
        previousLevel: oldLevel,
        xpGained: amount,
        dailyQuests: quests,
      ));
    } else {
      emit(state.copyWith(
        status: LevelStatus.ready,
        hero: newHero,
        xpGained: amount,
        dailyQuests: quests,
      ));
    }
  }

  // ── Acknowledge ────────────────────────────────────────────────────────────

  void acknowledgeLevelUp() => emit(state.copyWith(status: LevelStatus.ready));

  void acknowledgeProGate() => emit(state.copyWith(status: LevelStatus.ready));

  // ── Private ────────────────────────────────────────────────────────────────

  int _calcStreak(SleepHeroModel hero, DateTime now) {
    if (hero.lastActiveDate == null) return 1;
    final yesterday = now.subtract(const Duration(days: 1));
    final last = hero.lastActiveDate!;
    if (last.day == yesterday.day &&
        last.month == yesterday.month &&
        last.year == yesterday.year) {
      return hero.streak + 1;
    }
    return 1;
  }

  List<DailyQuest> _buildQuests(SleepHeroModel hero) => DailyQuestTemplates.all
      .map(
          (q) => q.copyWith(isCompleted: hero.completedQuestIds.contains(q.id)))
      .toList();
}
