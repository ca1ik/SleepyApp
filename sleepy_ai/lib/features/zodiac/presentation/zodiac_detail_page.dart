import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/features/zodiac/bloc/zodiac_bloc.dart';
import 'package:sleepy_ai/features/zodiac/bloc/zodiac_state.dart';
import 'package:sleepy_ai/features/zodiac/domain/zodiac_models.dart';
import 'package:sleepy_ai/shared/widgets/galaxy_background.dart';
import 'package:sleepy_ai/shared/widgets/cosmic_particles.dart';

class ZodiacDetailPage extends StatelessWidget {
  const ZodiacDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZodiacBloc, ZodiacState>(
      builder: (context, state) {
        final sign = state.selectedSign;
        if (sign == null) {
          return Scaffold(
            backgroundColor: AppColors.galaxyDeep,
            body: Center(
                child: Text('zodiac_select_first'.tr,
                    style: const TextStyle(color: AppColors.textSecondary))),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.galaxyDeep,
          body: GalaxyBackground(
            starCount: 180,
            nebulaCount: 3,
            child: Stack(
              children: [
                CosmicParticleOverlay(
                  particleCount: 50,
                  baseColor: sign.color,
                  secondaryColor: AppColors.galaxyStardust,
                  speed: 0.4,
                ),
                SafeArea(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: _buildHeader(sign)),
                      SliverToBoxAdapter(child: _buildElementInfo(sign)),
                      SliverToBoxAdapter(child: _buildTraitsSection(sign)),
                      SliverToBoxAdapter(child: _buildSleepProfile(sign)),
                      SliverToBoxAdapter(child: _buildAstralAdvice(sign)),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
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

  Widget _buildHeader(ZodiacSign sign) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: AppColors.textPrimary),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          // Large zodiac symbol with glow
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  sign.color.withAlpha(60),
                  sign.color.withAlpha(20),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: sign.color.withAlpha(40),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Text(
                sign.symbol,
                style: TextStyle(
                  fontSize: 56,
                  shadows: [Shadow(color: sign.color, blurRadius: 30)],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            sign.nameKey.tr,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sign.dateRangeKey.tr,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sign.descKey.tr,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildElementInfo(ZodiacSign sign) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _InfoChip(
            icon: sign.element.symbol,
            label: 'element'.tr,
            value: 'element_${sign.element.name}'.tr,
            color: sign.element.color,
          ),
          const SizedBox(width: 12),
          _InfoChip(
            icon: '🌀',
            label: 'modality'.tr,
            value: 'modality_${sign.modality.name}'.tr,
            color: AppColors.accent,
          ),
          const SizedBox(width: 12),
          _InfoChip(
            icon: '🪐',
            label: 'planet'.tr,
            value: sign.rulingPlanetKey.tr,
            color: AppColors.accentGold,
          ),
        ],
      ),
    );
  }

  Widget _buildTraitsSection(ZodiacSign sign) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _TraitCard(
            title: 'strengths'.tr,
            content: sign.strengthsKey.tr,
            icon: Icons.thumb_up_rounded,
            color: AppColors.success,
          ),
          const SizedBox(height: 12),
          _TraitCard(
            title: 'weaknesses'.tr,
            content: sign.weaknessesKey.tr,
            icon: Icons.thumb_down_rounded,
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildSleepProfile(ZodiacSign sign) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              sign.color.withAlpha(20),
              AppColors.backgroundCard.withAlpha(120),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: sign.color.withAlpha(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.nightlight_round,
                    color: AppColors.accent, size: 20),
                const SizedBox(width: 8),
                Text(
                  'sleep_profile'.tr,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              sign.sleepStyleKey.tr,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAstralAdvice(ZodiacSign sign) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withAlpha(30),
              AppColors.cosmicPink.withAlpha(15),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withAlpha(50)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome,
                    color: AppColors.astralGold, size: 20),
                const SizedBox(width: 8),
                Text(
                  'astral_advice'.tr,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              sign.astralAdviceKey.tr,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final String icon, label, value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(30)),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                  color: color, fontSize: 10, fontWeight: FontWeight.w600),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _TraitCard extends StatelessWidget {
  const _TraitCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  final String title, content;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
