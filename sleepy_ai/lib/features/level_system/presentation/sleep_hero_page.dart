// ignore_for_file: public_member_api_docs
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/level_system/cubit/level_cubit.dart';
import 'package:sleepy_ai/features/level_system/cubit/level_state.dart';
import 'package:sleepy_ai/features/level_system/domain/level_models.dart';
import 'package:sleepy_ai/features/level_system/presentation/level_up_overlay.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_cubit.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Ana Sayfa
// ─────────────────────────────────────────────────────────────────────────────

class SleepHeroPage extends StatefulWidget {
  const SleepHeroPage({super.key, this.showBackButton = false});

  /// Dashboard tab olarak yerleştirildiğinde false, ayrı route olarak true
  final bool showBackButton;

  @override
  State<SleepHeroPage> createState() => _SleepHeroPageState();
}

class _SleepHeroPageState extends State<SleepHeroPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _xpBarCtrl;
  late final Animation<double> _xpBarAnim;
  int _lastKnownTotalXp = -1;

  @override
  void initState() {
    super.initState();
    _xpBarCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _xpBarAnim = CurvedAnimation(
      parent: _xpBarCtrl,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _xpBarCtrl.dispose();
    super.dispose();
  }

  void _triggerXpBarAnim() {
    _xpBarCtrl
      ..reset()
      ..forward();
  }

  void _showLevelUpOverlay(BuildContext ctx, LevelState st) {
    showGeneralDialog(
      context: ctx,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      pageBuilder: (_, __, ___) => BlocProvider.value(
        value: ctx.read<LevelCubit>(),
        child: LevelUpOverlay(
          newLevel: st.hero.level,
          oldLevel: st.previousLevel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LevelCubit, LevelState>(
      listenWhen: (prev, curr) =>
          curr.status != prev.status || curr.hero.totalXp != prev.hero.totalXp,
      listener: (ctx, state) {
        if (state.status == LevelStatus.levelingUp) {
          _showLevelUpOverlay(ctx, state);
        } else if (state.status == LevelStatus.proGateReached) {
          ctx.read<LevelCubit>().acknowledgeProGate();
          Get.toNamed(AppStrings.routePro);
        }
        if (state.hero.totalXp > _lastKnownTotalXp && _lastKnownTotalXp >= 0) {
          _triggerXpBarAnim();
        }
        _lastKnownTotalXp = state.hero.totalXp;
      },
      builder: (ctx, state) {
        final isPro = ctx.select<ProCubit, bool>(
          (c) => c.state.status == ProStatus.active,
        );

        if (state.status == LevelStatus.loading) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primaryLight),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            leading: widget.showBackButton
                ? IconButton(
                    onPressed: Get.back,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary,
                    ),
                  )
                : null,
            actions: [
              if (!isPro)
                Padding(
                  padding: const EdgeInsets.only(right: AppSizes.md),
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppStrings.routePro),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentGold.withAlpha(80),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'proButtonSmall'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: _SleepHeroBody(
            state: state,
            isPro: isPro,
            xpBarAnim: _xpBarAnim,
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Body
// ─────────────────────────────────────────────────────────────────────────────

class _SleepHeroBody extends StatelessWidget {
  const _SleepHeroBody({
    required this.state,
    required this.isPro,
    required this.xpBarAnim,
  });

  final LevelState state;
  final bool isPro;
  final Animation<double> xpBarAnim;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _StarField(),
        SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.pagePaddingH,
                    vertical: AppSizes.md,
                  ),
                  child: _HeroCard(
                    hero: state.hero,
                    isPro: isPro,
                    xpBarAnim: xpBarAnim,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _DailyQuestsSection(
                  quests: state.dailyQuests,
                  isPro: isPro,
                  hero: state.hero,
                ),
              ),
              SliverToBoxAdapter(
                child: _LevelPathSection(
                  hero: state.hero,
                  isPro: isPro,
                ),
              ),
              SliverToBoxAdapter(
                child: _StatsSection(hero: state.hero),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Yıldız Alanı Arka Planı
// ─────────────────────────────────────────────────────────────────────────────

class _StarField extends StatefulWidget {
  const _StarField();

  @override
  State<_StarField> createState() => _StarFieldState();
}

class _StarFieldState extends State<_StarField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => RepaintBoundary(
          child: CustomPaint(
            painter: _StarFieldPainter(progress: _ctrl.value),
          ),
        ),
      ),
    );
  }
}

class _StarData {
  const _StarData({
    required this.x,
    required this.y,
    required this.size,
    required this.phase,
    required this.speed,
  });

  final double x;
  final double y;
  final double size;
  final double phase;
  final double speed;
}

class _StarFieldPainter extends CustomPainter {
  _StarFieldPainter({required this.progress});

  final double progress;

  static final List<_StarData> _stars = List.generate(90, (i) {
    final rng = math.Random(i * 13 + 7);
    return _StarData(
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      size: rng.nextDouble() * 2.2 + 0.4,
      phase: rng.nextDouble() * math.pi * 2,
      speed: rng.nextDouble() * 0.6 + 0.4,
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Gradient arka plan
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF04000E),
        Color(0xFF0D0328),
        Color(0xFF1A0845),
        Color(0xFF0A0118),
      ],
      stops: [0.0, 0.25, 0.6, 1.0],
    ).createShader(rect);
    canvas.drawRect(rect, paint);
    paint.shader = null;

    // Yıldızlar
    for (final star in _stars) {
      final twinkle =
          (math.sin(star.phase + progress * math.pi * 2 * star.speed) + 1) / 2;
      final opacity = 0.25 + twinkle * 0.75;
      final r = star.size * (0.7 + twinkle * 0.5);
      paint.color = Color.fromRGBO(210, 185, 255, opacity);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        r,
        paint,
      );
    }

    // Parlak aksanlı yıldızlar
    for (int i = 0; i < 6; i++) {
      final rng = math.Random(i * 29 + 5);
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height * 0.55;
      final t = (math.sin(progress * math.pi * 2 + i * 1.3) + 1) / 2;
      paint.color = Color.fromRGBO(170, 130, 255, 0.35 + t * 0.65);
      canvas.drawCircle(Offset(x, y), 2.8 + t * 1.2, paint);
    }
  }

  @override
  bool shouldRepaint(_StarFieldPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Kartı
// ─────────────────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.hero,
    required this.isPro,
    required this.xpBarAnim,
  });

  final SleepHeroModel hero;
  final bool isPro;
  final Animation<double> xpBarAnim;

  @override
  Widget build(BuildContext context) {
    final titleInfo = LevelHelper.titleForLevel(hero.level);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusXxl),
        border: Border.all(
          color: titleInfo.color.withAlpha(55),
          width: 1.5,
        ),
        gradient: RadialGradient(
          center: const Alignment(0, -0.8),
          radius: 1.4,
          colors: [
            titleInfo.color.withAlpha(22),
            const Color(0xFF1E1035).withAlpha(230),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: titleInfo.color.withAlpha(28),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _HeroBadge(level: hero.level, titleInfo: titleInfo),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${titleInfo.emoji}  ${titleInfo.title}',
                      style: TextStyle(
                        color: titleInfo.color,
                        fontSize: AppSizes.fontLg,
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                            color: titleInfo.glowColor,
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'levelSub'.trParams({'level': '${hero.level}'}),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppSizes.fontSm,
                      ),
                    ),
                    if (hero.streak > 1) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35).withAlpha(20),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0xFFFF6B35).withAlpha(60)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(
                              'dayStreak'.trParams({'days': '${hero.streak}'}),
                              style: const TextStyle(
                                color: Color(0xFFFF6B35),
                                fontSize: AppSizes.fontXs,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _XpProgressSection(
            hero: hero,
            titleInfo: titleInfo,
            fillAnim: xpBarAnim,
            isPro: isPro,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Kahraman Rozeti (Nabız Animasyonlu)
// ─────────────────────────────────────────────────────────────────────────────

class _HeroBadge extends StatefulWidget {
  const _HeroBadge({required this.level, required this.titleInfo});

  final int level;
  final LevelTitleInfo titleInfo;

  @override
  State<_HeroBadge> createState() => _HeroBadgeState();
}

class _HeroBadgeState extends State<_HeroBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) {
        final g = _pulse.value;
        return Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.titleInfo.glowColor
                    .withAlpha((60 + (g * 100).round())),
                blurRadius: 12 + g * 16,
                spreadRadius: 2 + g * 5,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.titleInfo.color.withAlpha((60 + g * 40).round()),
                  const Color(0xFF1E1035),
                ],
              ),
              border: Border.all(
                color: widget.titleInfo.color.withAlpha((160 + g * 95).round()),
                width: 2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lv.',
                    style: TextStyle(
                      color: widget.titleInfo.color,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${widget.level}',
                    style: TextStyle(
                      color: widget.titleInfo.color,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      shadows: [
                        Shadow(
                          color: widget.titleInfo.glowColor,
                          blurRadius: 8 + g * 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// XP İlerleme Bölümü
// ─────────────────────────────────────────────────────────────────────────────

class _XpProgressSection extends StatelessWidget {
  const _XpProgressSection({
    required this.hero,
    required this.titleInfo,
    required this.fillAnim,
    required this.isPro,
  });

  final SleepHeroModel hero;
  final LevelTitleInfo titleInfo;
  final Animation<double> fillAnim;
  final bool isPro;

  @override
  Widget build(BuildContext context) {
    if (hero.level >= 99) {
      return _MaxLevelBadge(titleInfo: titleInfo);
    }

    // PRO Kapısı
    if (!isPro && hero.level >= 5) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${hero.currentLevelXp} / ${hero.xpToNextLevel} XP',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppSizes.fontSm,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.lock_rounded,
                      color: AppColors.accentGold, size: 13),
                  SizedBox(width: 4),
                  Text(
                    'proContinue'.tr,
                    style: TextStyle(
                      color: AppColors.accentGold,
                      fontSize: AppSizes.fontSm,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          _LockedXpBar(progress: hero.levelProgress),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => Get.toNamed(AppStrings.routePro),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGold.withAlpha(70),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('✨', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text(
                    'proReachLv99'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: AppSizes.fontMd,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${hero.currentLevelXp} / ${hero.xpToNextLevel} XP',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppSizes.fontSm,
              ),
            ),
            Text(
              'nextLv'.trParams({'level': '${hero.level + 1}'}),
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: AppSizes.fontXs,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _XpBar(
          progress: hero.levelProgress,
          color: titleInfo.color,
          glowColor: titleInfo.glowColor,
        ),
      ],
    );
  }
}

class _XpBar extends StatefulWidget {
  const _XpBar({
    required this.progress,
    required this.color,
    required this.glowColor,
  });

  final double progress;
  final Color color;
  final Color glowColor;

  @override
  State<_XpBar> createState() => _XpBarState();
}

class _XpBarState extends State<_XpBar> with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerCtrl,
      builder: (_, __) {
        return Container(
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: const Color(0xFF1E1035),
            border: Border.all(
              color: widget.color.withAlpha(50),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Stack(
              children: [
                // XP dolum çubuğu
                FractionallySizedBox(
                  widthFactor: widget.progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.color.withAlpha(180),
                          widget.color,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.glowColor,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
                // Shimmer efekti
                if (widget.progress > 0.04)
                  Positioned.fill(
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment(_shimmerCtrl.value * 4 - 2, 0),
                        end: Alignment(_shimmerCtrl.value * 4 - 0.8, 0),
                        colors: [
                          Colors.transparent,
                          Colors.white.withAlpha(55),
                          Colors.transparent,
                        ],
                      ).createShader(bounds),
                      child: Container(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LockedXpBar extends StatelessWidget {
  const _LockedXpBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: const Color(0xFF1E1035),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                color: AppColors.accentGold.withAlpha(60),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_rounded, color: Colors.white54, size: 9),
                    SizedBox(width: 3),
                    Text(
                      'lv6ProRequired'.tr,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaxLevelBadge extends StatelessWidget {
  const _MaxLevelBadge({required this.titleInfo});

  final LevelTitleInfo titleInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            titleInfo.color.withAlpha(30),
            titleInfo.color.withAlpha(15),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: titleInfo.color.withAlpha(80)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(titleInfo.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            'maxLevelReached'.tr,
            style: TextStyle(
              color: titleInfo.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Günlük Görevler
// ─────────────────────────────────────────────────────────────────────────────

class _DailyQuestsSection extends StatelessWidget {
  const _DailyQuestsSection({
    required this.quests,
    required this.isPro,
    required this.hero,
  });

  final List<DailyQuest> quests;
  final bool isPro;
  final SleepHeroModel hero;

  @override
  Widget build(BuildContext context) {
    final completed = quests.where((q) => q.isCompleted).length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.pagePaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.xl),
          Row(
            children: [
              Text(
                'dailyQuestsTitle'.tr,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppSizes.fontLg,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(28),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withAlpha(60)),
                ),
                child: Text(
                  '$completed / ${quests.length}',
                  style: const TextStyle(
                    color: AppColors.primaryLight,
                    fontSize: AppSizes.fontXs,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          ...quests.indexed.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.sm),
              child: _QuestCard(
                quest: entry.$2,
                isPro: isPro,
                animDelay: Duration(milliseconds: entry.$1 * 70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestCard extends StatefulWidget {
  const _QuestCard({
    required this.quest,
    required this.isPro,
    required this.animDelay,
  });

  final DailyQuest quest;
  final bool isPro;
  final Duration animDelay;

  @override
  State<_QuestCard> createState() => _QuestCardState();
}

class _QuestCardState extends State<_QuestCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _slideIn;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _slideIn = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    Future.delayed(widget.animDelay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleTap(BuildContext ctx) {
    if (widget.quest.isCompleted) return;
    if (widget.quest.route != null) Get.toNamed(widget.quest.route!);
    ctx.read<LevelCubit>().earnXp(
          widget.quest.xpReward,
          questId: widget.quest.id,
          isPro: widget.isPro,
        );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideIn,
      builder: (_, child) => Transform.translate(
        offset: Offset(28 * (1 - _slideIn.value), 0),
        child: Opacity(
          opacity: _slideIn.value.clamp(0.0, 1.0),
          child: child,
        ),
      ),
      child: GestureDetector(
        onTap: () => _handleTap(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            color: widget.quest.isCompleted
                ? AppColors.success.withAlpha(12)
                : const Color(0xFF1E1035),
            border: Border.all(
              color: widget.quest.isCompleted
                  ? AppColors.success.withAlpha(55)
                  : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Text(widget.quest.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.quest.title,
                      style: TextStyle(
                        color: widget.quest.isCompleted
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: AppSizes.fontMd,
                        decoration: widget.quest.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.quest.description,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: AppSizes.fontXs,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (!widget.quest.isCompleted)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '+${widget.quest.xpReward} XP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                )
              else
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.success.withAlpha(28),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.success.withAlpha(80)),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.success,
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Seviye Yolu (Yatay Scroll)
// ─────────────────────────────────────────────────────────────────────────────

class _LevelPathSection extends StatelessWidget {
  const _LevelPathSection({required this.hero, required this.isPro});

  final SleepHeroModel hero;
  final bool isPro;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.pagePaddingH,
        right: AppSizes.pagePaddingH,
        top: AppSizes.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'levelPath'.tr,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSizes.fontLg,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          SizedBox(
            height: 88,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: 99,
              itemBuilder: (_, index) {
                final lv = index + 1;
                return Padding(
                  padding: EdgeInsets.only(right: lv < 99 ? 6 : 0),
                  child: _LevelNode(
                    level: lv,
                    isCurrent: lv == hero.level,
                    isPast: lv < hero.level,
                    isLocked: !isPro && lv > 5,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelNode extends StatelessWidget {
  const _LevelNode({
    required this.level,
    required this.isCurrent,
    required this.isPast,
    required this.isLocked,
  });

  final int level;
  final bool isCurrent;
  final bool isPast;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final titleInfo = LevelHelper.titleForLevel(level);
    final isProWall = level == 6 && isLocked;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isProWall)
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: ShaderMask(
              shaderCallback: (b) => AppColors.goldGradient.createShader(b),
              child: const Text(
                'PRO',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5),
              ),
            ),
          ),
        GestureDetector(
          onTap: isLocked ? () => Get.toNamed(AppStrings.routePro) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: isCurrent ? 54 : 42,
            height: isCurrent ? 54 : 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPast
                  ? titleInfo.color.withAlpha(25)
                  : isCurrent
                      ? titleInfo.color.withAlpha(40)
                      : const Color(0xFF1E1035),
              border: Border.all(
                color: isPast
                    ? titleInfo.color.withAlpha(110)
                    : isCurrent
                        ? titleInfo.color
                        : isLocked
                            ? AppColors.border
                            : AppColors.border.withAlpha(60),
                width: isCurrent ? 2 : 1,
              ),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: titleInfo.glowColor,
                        blurRadius: 14,
                        spreadRadius: 3,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isLocked
                  ? const Icon(Icons.lock_rounded,
                      color: AppColors.textMuted, size: 15)
                  : isPast
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.success, size: 17)
                      : Text(
                          '$level',
                          style: TextStyle(
                            color: isCurrent
                                ? titleInfo.color
                                : AppColors.textMuted,
                            fontWeight: FontWeight.w700,
                            fontSize: isCurrent ? 14 : 12,
                          ),
                        ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isCurrent ? '◆' : '',
          style: TextStyle(color: titleInfo.color, fontSize: 8),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// İstatistikler
// ─────────────────────────────────────────────────────────────────────────────

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.hero});

  final SleepHeroModel hero;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.pagePaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.xl),
          Text(
            'myHero'.tr,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSizes.fontLg,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  emoji: '⭐',
                  label: 'totalXpLabel'.tr,
                  value: _formatXp(hero.totalXp),
                  color: AppColors.accentGold,
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: _StatCard(
                  emoji: '🔥',
                  label: 'streakLabel'.tr,
                  value: 'streakDays'.trParams({'days': '${hero.streak}'}),
                  color: const Color(0xFFFF6B35),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: _StatCard(
                  emoji: '📅',
                  label: 'activeDaysLabel'.tr,
                  value: '${hero.totalDays}',
                  color: AppColors.accentTeal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatXp(int xp) {
    if (xp >= 1000) {
      return '${(xp / 1000).toStringAsFixed(1)}k';
    }
    return '$xp';
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
  });

  final String emoji;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        color: color.withAlpha(14),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: AppSizes.fontMd,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: AppSizes.fontXs,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
