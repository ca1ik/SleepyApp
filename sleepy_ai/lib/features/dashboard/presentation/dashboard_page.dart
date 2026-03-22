import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/sleep_tracking/bloc/sleep_cycle_bloc.dart';
import 'package:sleepy_ai/features/sleep_tracking/bloc/sleep_cycle_event.dart';
import 'package:sleepy_ai/features/sleep_tracking/bloc/sleep_cycle_state.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';
import 'package:sleepy_ai/shared/widgets/card_widgets.dart';
import 'package:sleepy_ai/shared/widgets/common_widgets.dart';
import 'package:sleepy_ai/shared/widgets/sleep_chart_widget.dart';
import 'package:sleepy_ai/features/level_system/cubit/level_cubit.dart';
import 'package:sleepy_ai/features/level_system/cubit/level_state.dart';
import 'package:sleepy_ai/features/level_system/domain/level_models.dart';
import 'package:sleepy_ai/features/level_system/presentation/sleep_hero_page.dart';
import 'package:sleepy_ai/shared/widgets/ad_banner_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<SleepCycleBloc>().add(const LoadSleepHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: IndexedStack(
          index: _selectedNavIndex,
          children: const [
            _HomeTab(),
            // Sounds sayfası tab'ı
            _SoundsTabPlaceholder(),
            // Learning tab
            _LearningTabPlaceholder(),
            // Profil/Kahraman tab
            SleepHeroPage(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.primary.withAlpha(60),
          selectedIndex: _selectedNavIndex,
          onDestinationSelected: (index) {
            // Ses ve Öğren gibi tam sayfa navigasyona yönlendir
            if (index == 1) {
              Get.toNamed(AppStrings.routeSounds);
              return;
            }
            if (index == 2) {
              Get.toNamed(AppStrings.routeLearning);
              return;
            }
            if (index == 4) {
              Get.toNamed(AppStrings.routeSettings);
              return;
            }
            setState(() => _selectedNavIndex = index);
          },
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: 'home'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.music_note_outlined),
              selectedIcon: const Icon(Icons.music_note_rounded),
              label: 'sounds'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined),
              selectedIcon: const Icon(Icons.menu_book_rounded),
              label: 'learn'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.auto_awesome_outlined),
              selectedIcon: const Icon(Icons.auto_awesome_rounded),
              label: 'hero'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings_rounded),
              label: 'settings'.tr,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Ana Sekme ────────────────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SleepCycleBloc, SleepCycleState>(
      builder: (context, state) {
        final loaded = state is SleepHistoryLoaded ? state : null;

        return CustomScrollView(
          slivers: [
            _HomeAppBar(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.pagePaddingH,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: AppSizes.md),
                  // Greeting
                  _GreetingCard(loaded: loaded),
                  const SizedBox(height: AppSizes.md),
                  // Kahraman mini kart
                  _HeroMiniCard(),
                  const SizedBox(height: AppSizes.lg),
                  // Quick metrics row
                  Row(
                    children: [
                      Expanded(
                        child: MetricCardWidget(
                          icon: Icons.bar_chart_rounded,
                          title: 'sleepScore'.tr,
                          value: loaded != null ? '${loaded.sleepScore}' : '--',
                          unit: '/100',
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: MetricCardWidget(
                          icon: Icons.schedule_rounded,
                          title: 'weeklyAvg'.tr,
                          value: loaded != null
                              ? loaded.weeklyAverage.toStringAsFixed(1)
                              : '--',
                          unit: 'sa',
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: MetricCardWidget(
                          icon: Icons.battery_alert_rounded,
                          title: 'sleepDebt'.tr,
                          value: loaded != null
                              ? loaded.sleepDebt.toStringAsFixed(1)
                              : '--',
                          unit: 'sa',
                          color: loaded != null && loaded.sleepDebt > 2
                              ? AppColors.warning
                              : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.lg),
                  // Haftalık grafik
                  if (loaded != null) ...[
                    SleepChartWidget(
                      sleepLogs: loaded.records,
                      targetHours: loaded.goalHours,
                    ),
                    const SizedBox(height: AppSizes.lg),
                  ],
                  // Hızlı butonlar
                  _QuickActionsRow(),
                  const SizedBox(height: AppSizes.sm),
                  // Reklam alanı (PRO/NoAds kullanıcılarına gizlenir)
                  const AdBannerWidget(),
                  const SizedBox(height: AppSizes.lg),
                  // Son kazanılan rozetler
                  _BadgesSection(),
                  const SizedBox(height: AppSizes.lg),
                  // Uyku ipuçları
                  _SleepTipsSection(),
                  const SizedBox(height: AppSizes.xxxl),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      pinned: true,
      elevation: 0,
      titleSpacing: AppSizes.pagePaddingH,
      title: const Text(
        'SleepyApp 🌙',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
          fontSize: AppSizes.fontLg,
        ),
      ),
      actions: [
        // PRO rozeti
        GestureDetector(
          onTap: () => Get.toNamed(AppStrings.routePro),
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm,
              vertical: 10,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: const Text(
              'PRO',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 11,
              ),
            ),
          ),
        ),
        // Bildirimler
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _GreetingCard extends StatelessWidget {
  const _GreetingCard({required this.loaded});

  final SleepHistoryLoaded? loaded;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 6) return 'goodNight'.tr;
    if (hour < 12) return 'goodMorning'.tr;
    if (hour < 18) return 'goodAfternoon'.tr;
    return 'goodEvening'.tr;
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: const Icon(
              Icons.nightlight_round,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppSizes.fontSm,
                  ),
                ),
                if (loaded != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    loaded!.isTracking
                        ? 'trackingActive'.tr
                        : 'sleepScoreIs'
                            .trParams({'score': '${loaded!.sleepScore}'}),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Uyku takip butonu
          GestureDetector(
            onTap: () => Get.toNamed(AppStrings.routeSleepTracking),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm,
              ),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Text(
                'trackBtn'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: AppSizes.fontSm,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'quickAccess'.tr,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppSizes.fontLg,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: AppSizes.sm,
          crossAxisSpacing: AppSizes.sm,
          childAspectRatio: 0.85,
          children: [
            _QuickActionItem(
              icon: Icons.headphones_rounded,
              label: 'sounds'.tr,
              color: AppColors.soundRain,
              route: AppStrings.routeSounds,
            ),
            _QuickActionItem(
              icon: Icons.import_contacts_rounded,
              label: 'stories'.tr,
              color: AppColors.soundMedieval,
              route: AppStrings.routeSounds,
            ),
            _QuickActionItem(
              icon: Icons.spa_rounded,
              label: 'meditation'.tr,
              color: AppColors.accentTeal,
              route: AppStrings.routeSounds,
            ),
            _QuickActionItem(
              icon: Icons.emoji_events_rounded,
              label: 'badges'.tr,
              color: AppColors.accent,
              route: AppStrings.routeRewards,
            ),
            _QuickActionItem(
              icon: Icons.psychology_rounded,
              label: 'assistant'.tr,
              color: AppColors.primaryLight,
              route: AppStrings.routeChatbot,
            ),
            _QuickActionItem(
              icon: Icons.sports_esports_rounded,
              label: 'games'.tr,
              color: AppColors.accentBlue,
              route: AppStrings.routeGames,
            ),
            _QuickActionItem(
              icon: Icons.auto_stories_rounded,
              label: 'sleepStories'.tr,
              color: AppColors.accentTeal,
              route: AppStrings.routeStories,
            ),
            _QuickActionItem(
              icon: Icons.book_rounded,
              label: 'dreamJournal'.tr,
              color: AppColors.primaryLight,
              route: AppStrings.routeDreamJournal,
            ),
            _QuickActionItem(
              icon: Icons.mood_rounded,
              label: 'moodTracker'.tr,
              color: AppColors.accent,
              route: AppStrings.routeMoodTracker,
            ),
            _QuickActionItem(
              icon: Icons.flag_rounded,
              label: 'challenges'.tr,
              color: AppColors.accentGold,
              route: AppStrings.routeChallenges,
            ),
            _QuickActionItem(
              icon: Icons.timer_rounded,
              label: 'sleepTimer'.tr,
              color: AppColors.accentBlue,
              route: AppStrings.routeSleepTimer,
            ),
            _QuickActionItem(
              icon: Icons.lightbulb_rounded,
              label: 'dailyTips'.tr,
              color: AppColors.success,
              route: AppStrings.routeDailyTips,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
  });

  final IconData icon;
  final String label;
  final Color color;
  final String route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: color.withAlpha(60)),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BadgesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'myBadges'.tr,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppSizes.fontLg,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Get.toNamed(AppStrings.routeRewards),
              child: Text('seeAll'.tr),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: kDefaultBadges.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
            itemBuilder: (_, i) {
              return SizedBox(
                width: 90,
                child: BadgeCardWidget(badge: kDefaultBadges[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SleepTipsSection extends StatelessWidget {
  final _tips = [
    SleepTipModel(
      id: '1',
      title: 'tipConsistentTitle'.tr,
      body: 'tipConsistentBody'.tr,
      category: 'ritim',
      readTimeMinutes: 3,
    ),
    SleepTipModel(
      id: '2',
      title: 'tipScreenTitle'.tr,
      body: 'tipScreenBody'.tr,
      category: 'hijyen',
      readTimeMinutes: 2,
    ),
    SleepTipModel(
      id: '3',
      title: 'tipCoolRoomTitle'.tr,
      body: 'tipCoolRoomBody'.tr,
      category: 'ortam',
      readTimeMinutes: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'sleepTips'.tr,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppSizes.fontLg,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Get.toNamed(AppStrings.routeLearning),
              child: Text('more'.tr),
            ),
          ],
        ),
        ..._tips.map(
          (tip) => Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: GlassCard(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                children: [
                  const Text('🌙', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tip.body,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: AppSizes.fontSm,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Placeholder tab'lar (kendi sayfalarına yönlendirir) ──────────────────────

class _SoundsTabPlaceholder extends StatelessWidget {
  const _SoundsTabPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _LearningTabPlaceholder extends StatelessWidget {
  const _LearningTabPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

// ─── Kahraman Mini Kartı (Ana Sekme) ──────────────────────────────────────────

class _HeroMiniCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LevelCubit, LevelState>(
      builder: (ctx, state) {
        if (state.status == LevelStatus.loading) return const SizedBox.shrink();
        final hero = state.hero;
        final titleInfo = LevelHelper.titleForLevel(hero.level);
        final completed = state.dailyQuests.where((q) => !q.isCompleted).length;

        return GestureDetector(
          onTap: () => Get.toNamed(AppStrings.routeSleepHero),
          child: GlassCard(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Row(
              children: [
                // Mini level rozeti
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: titleInfo.color.withAlpha(28),
                    border: Border.all(color: titleInfo.color, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: titleInfo.glowColor,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lv.',
                          style: TextStyle(
                            color: titleInfo.color,
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${hero.level}',
                          style: TextStyle(
                            color: titleInfo.color,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                // İsim + XP çubuğu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            titleInfo.emoji,
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            titleInfo.title,
                            style: TextStyle(
                              color: titleInfo.color,
                              fontWeight: FontWeight.w700,
                              fontSize: AppSizes.fontMd,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: hero.levelProgress,
                          backgroundColor: AppColors.backgroundCard,
                          color: titleInfo.color,
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${hero.currentLevelXp} / ${hero.xpToNextLevel} XP',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: AppSizes.fontXs,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                // Bekleyen görev rozeti
                Column(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: completed > 0
                            ? AppColors.primary.withAlpha(28)
                            : AppColors.success.withAlpha(20),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: completed > 0
                              ? AppColors.primary.withAlpha(60)
                              : AppColors.success.withAlpha(60),
                        ),
                      ),
                      child: Center(
                        child: completed > 0
                            ? Text(
                                '$completed',
                                style: const TextStyle(
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              )
                            : const Icon(
                                Icons.check_rounded,
                                color: AppColors.success,
                                size: 18,
                              ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      completed > 0 ? 'quest'.tr : 'done'.tr,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: AppSizes.fontXs,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
