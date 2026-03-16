import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/rewards/cubit/rewards_cubit.dart';
import 'package:sleepy_ai/features/rewards/cubit/rewards_state.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RewardsCubit()..loadBadges(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: AppColors.textPrimary),
          title: const Text(
            'Rozetlerim',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSizes.fontXl,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<RewardsCubit, RewardsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _ScoreBanner(score: state.sleepScore),
                ),
                SliverToBoxAdapter(
                  child: _SectionHeader(
                    label: 'Kazanılanlar (${state.earnedBadges.length})',
                    color: AppColors.success,
                  ),
                ),
                if (state.earnedBadges.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSizes.lg),
                      child: Center(
                        child: Text(
                          'Henüz rozet kazanılmadı.\nDüzenli uyuyarak rozetleri kilitle!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.sm,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: AppSizes.md,
                            crossAxisSpacing: AppSizes.md,
                            childAspectRatio: 0.9,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) => _BadgeCard(
                          badge: state.earnedBadges[i],
                          isEarned: true,
                        ),
                        childCount: state.earnedBadges.length,
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: _SectionHeader(
                    label: 'Kilitli (${state.pendingBadges.length})',
                    color: AppColors.textMuted,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: AppSizes.md,
                    right: AppSizes.md,
                    bottom: AppSizes.xl,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppSizes.md,
                          crossAxisSpacing: AppSizes.md,
                          childAspectRatio: 0.9,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _BadgeCard(
                        badge: state.pendingBadges[i],
                        isEarned: false,
                      ),
                      childCount: state.pendingBadges.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ScoreBanner extends StatelessWidget {
  const _ScoreBanner({required this.score});
  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: AppColors.sleepScoreGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🏆', style: TextStyle(fontSize: 36)),
          const SizedBox(width: AppSizes.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Uyku Puanın',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppSizes.fontMd,
                ),
              ),
              Text(
                '$score / 100',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppSizes.fontXxl,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.md,
        top: AppSizes.lg,
        bottom: AppSizes.sm,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: AppSizes.fontLg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.badge, required this.isEarned});
  final BadgeModel badge;
  final bool isEarned;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isEarned
            ? AppColors.backgroundCard
            : AppColors.backgroundCardLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: isEarned ? AppColors.accentGold : AppColors.border,
          width: isEarned ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji with glow if earned
            Container(
              width: 64,
              height: 64,
              decoration: isEarned
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentGold.withOpacity(0.4),
                          blurRadius: 16,
                          spreadRadius: 4,
                        ),
                      ],
                    )
                  : null,
              child: Center(
                child: Text(
                  isEarned ? badge.emoji : '🔒',
                  style: TextStyle(
                    fontSize: 32,
                    color: isEarned ? null : Colors.grey.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              badge.titleTr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isEarned ? AppColors.textPrimary : AppColors.textMuted,
                fontSize: AppSizes.fontSm,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              isEarned ? '✓ Kazanıldı' : 'Skor: ${badge.requiredScore}+',
              style: TextStyle(
                color: isEarned ? AppColors.success : AppColors.textDisabled,
                fontSize: AppSizes.fontXs,
              ),
            ),
            if (!isEarned) ...[
              const SizedBox(height: AppSizes.xs),
              Text(
                badge.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: AppSizes.fontXs,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
