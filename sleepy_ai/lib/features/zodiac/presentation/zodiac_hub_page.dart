import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/features/zodiac/bloc/zodiac_bloc.dart';
import 'package:sleepy_ai/features/zodiac/bloc/zodiac_event.dart';
import 'package:sleepy_ai/features/zodiac/bloc/zodiac_state.dart';
import 'package:sleepy_ai/features/zodiac/domain/zodiac_models.dart';
import 'package:sleepy_ai/shared/widgets/galaxy_background.dart';
import 'package:sleepy_ai/shared/widgets/cosmic_particles.dart';

class ZodiacHubPage extends StatefulWidget {
  const ZodiacHubPage({super.key});

  @override
  State<ZodiacHubPage> createState() => _ZodiacHubPageState();
}

class _ZodiacHubPageState extends State<ZodiacHubPage>
    with TickerProviderStateMixin {
  late final AnimationController _wheelCtrl;
  late final AnimationController _glowCtrl;
  ZodiacSign? _hoveredSign;

  @override
  void initState() {
    super.initState();
    _wheelCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _wheelCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (_) => ZodiacBloc(),
      child: Scaffold(
        backgroundColor: AppColors.galaxyDeep,
        body: GalaxyBackground(
          starCount: 250,
          nebulaCount: 4,
          child: Stack(
            children: [
              const CosmicParticleOverlay(
                particleCount: 60,
                baseColor: Color(0xFF8B5CF6),
                secondaryColor: Color(0xFFFF6FD8),
                speed: 0.6,
              ),
              SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            _buildZodiacWheel(size),
                            const SizedBox(height: 24),
                            _buildActionCards(),
                            const SizedBox(height: 24),
                            _buildDailyHoroscopeCard(),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: AppColors.textPrimary),
          ),
          Expanded(
            child: Text(
              'zodiac_title'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildZodiacWheel(Size screenSize) {
    final wheelSize = screenSize.width * 0.85;
    return SizedBox(
      height: wheelSize,
      width: wheelSize,
      child: AnimatedBuilder(
        animation: _wheelCtrl,
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer glowing ring
              AnimatedBuilder(
                animation: _glowCtrl,
                builder: (_, __) => Container(
                  width: wheelSize,
                  height: wheelSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.galaxyNebula
                          .withAlpha((80 + 40 * _glowCtrl.value).round()),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary
                            .withAlpha((30 + 25 * _glowCtrl.value).round()),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),

              // Center cosmic orb
              Container(
                width: wheelSize * 0.28,
                height: wheelSize * 0.28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.cosmicPink.withAlpha(80),
                      AppColors.primary.withAlpha(40),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child: BlocBuilder<ZodiacBloc, ZodiacState>(
                    builder: (_, state) => Text(
                      state.selectedSign?.symbol ?? '✨',
                      style: TextStyle(
                        fontSize: wheelSize * 0.1,
                        shadows: [
                          Shadow(
                            color: AppColors.primary,
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 12 zodiac signs arranged in circle
              ...List.generate(12, (i) {
                final sign = ZodiacSign.values[i];
                final angle =
                    (i * 30.0 - 90 + _wheelCtrl.value * 6) * math.pi / 180;
                final radius = wheelSize * 0.38;
                final x = math.cos(angle) * radius;
                final y = math.sin(angle) * radius;

                final isSelected = _hoveredSign == sign;

                return Transform.translate(
                  offset: Offset(x, y),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _hoveredSign = sign);
                      context.read<ZodiacBloc>().add(ZodiacSelectSign(sign));
                      context
                          .read<ZodiacBloc>()
                          .add(ZodiacLoadDailyHoroscope(sign));
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isSelected ? 64 : 52,
                      height: isSelected ? 64 : 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? sign.color.withAlpha(60)
                            : AppColors.backgroundCard.withAlpha(150),
                        border: Border.all(
                          color: isSelected
                              ? sign.color
                              : AppColors.border.withAlpha(100),
                          width: isSelected ? 2.5 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: sign.color.withAlpha(80),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            sign.symbol,
                            style: TextStyle(
                              fontSize: isSelected ? 22 : 18,
                            ),
                          ),
                          if (isSelected)
                            Text(
                              sign.nameKey.tr,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _GlassActionCard(
            icon: Icons.compare_arrows_rounded,
            title: 'zodiac_compatibility'.tr,
            subtitle: 'zodiac_compatibility_sub'.tr,
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
            ),
            onTap: () {
              final bloc = context.read<ZodiacBloc>();
              if (bloc.state.selectedSign != null) {
                Get.toNamed(AppStrings.routeZodiacCompatibility);
              } else {
                Get.snackbar(
                  'zodiac_select_first'.tr,
                  'zodiac_select_first_sub'.tr,
                  backgroundColor: AppColors.backgroundCard,
                  colorText: AppColors.textPrimary,
                );
              }
            },
          ),
          const SizedBox(height: 12),
          _GlassActionCard(
            icon: Icons.auto_awesome_rounded,
            title: 'astral_exercises_title'.tr,
            subtitle: 'astral_exercises_sub'.tr,
            gradient: const LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFF14B8A6)],
            ),
            onTap: () => Get.toNamed(AppStrings.routeAstralExercises),
          ),
          const SizedBox(height: 12),
          _GlassActionCard(
            icon: Icons.info_outline_rounded,
            title: 'zodiac_detail'.tr,
            subtitle: 'zodiac_detail_sub'.tr,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFF6B35)],
            ),
            onTap: () {
              final bloc = context.read<ZodiacBloc>();
              if (bloc.state.selectedSign != null) {
                Get.toNamed(AppStrings.routeZodiacDetail);
              } else {
                Get.snackbar(
                  'zodiac_select_first'.tr,
                  'zodiac_select_first_sub'.tr,
                  backgroundColor: AppColors.backgroundCard,
                  colorText: AppColors.textPrimary,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDailyHoroscopeCard() {
    return BlocBuilder<ZodiacBloc, ZodiacState>(
      builder: (_, state) {
        if (state.selectedSign == null || state.dailyHoroscope == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard.withAlpha(120),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border.withAlpha(60)),
              ),
              child: Column(
                children: [
                  const Text('🔮', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  Text(
                    'zodiac_tap_sign'.tr,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final h = state.dailyHoroscope!;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  state.selectedSign!.color.withAlpha(30),
                  AppColors.backgroundCard.withAlpha(150),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: state.selectedSign!.color.withAlpha(80),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      state.selectedSign!.symbol,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${'daily_horoscope'.tr} — ${state.selectedSign!.nameKey.tr}',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            h.generalKey.tr,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _HoroscopeRow(
                  icon: Icons.nightlight_round,
                  label: 'sleep_advice'.tr,
                  value: h.sleepAdviceKey.tr,
                ),
                _HoroscopeRow(
                  icon: Icons.star_rounded,
                  label: 'lucky_number'.tr,
                  value: '${h.luckyNumber}',
                ),
                _HoroscopeRow(
                  icon: Icons.palette_rounded,
                  label: 'lucky_color'.tr,
                  value: h.luckyColorKey.tr,
                ),
                _HoroscopeRow(
                  icon: Icons.mood_rounded,
                  label: 'mood'.tr,
                  value: h.moodKey.tr,
                ),
                _HoroscopeRow(
                  icon: Icons.bolt_rounded,
                  label: 'energy_level'.tr,
                  value: '⚡' * h.energyLevel,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome,
                          color: AppColors.astralGold, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          h.astralTipKey.tr,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
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

class _HoroscopeRow extends StatelessWidget {
  const _HoroscopeRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textMuted, size: 18),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassActionCard extends StatelessWidget {
  const _GlassActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard.withAlpha(120),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withAlpha(60)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textMuted,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
