import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/challenges/cubit/challenge_cubit.dart';
import 'package:sleepy_ai/features/challenges/cubit/challenge_state.dart';
import 'package:sleepy_ai/features/challenges/domain/challenge_models.dart';
import 'package:sleepy_ai/shared/widgets/common_widgets.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: BlocBuilder<ChallengeCubit, ChallengeState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  pinned: true,
                  title: Text(
                    'challengesTitle'.tr,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.pagePaddingH,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: AppSizes.md),
                      // XP earned badge
                      GlassCard(
                        padding: const EdgeInsets.all(AppSizes.md),
                        child: Row(
                          children: [
                            const Text('🏆', style: TextStyle(fontSize: 32)),
                            const SizedBox(width: AppSizes.sm),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'challengeXpEarned'.tr,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: AppSizes.fontSm,
                                  ),
                                ),
                                Text(
                                  '${state.totalXpEarned} XP',
                                  style: const TextStyle(
                                    color: AppColors.accentGold,
                                    fontSize: AppSizes.fontXl,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              '${state.completedChallenges.length}/${state.challenges.length}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: AppSizes.fontSm,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.lg),
                      // Active challenges
                      if (state.activeChallenges.isNotEmpty) ...[
                        Text(
                          'challengeActive'.tr,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: AppSizes.fontLg,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        ...state.activeChallenges.map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSizes.sm),
                            child: _ActiveChallengeCard(challenge: c),
                          ),
                        ),
                        const SizedBox(height: AppSizes.lg),
                      ],
                      // Available challenges
                      if (state.availableChallenges.isNotEmpty) ...[
                        Text(
                          'challengeAvailable'.tr,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: AppSizes.fontLg,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        ...state.availableChallenges.map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSizes.sm),
                            child: _AvailableChallengeCard(challenge: c),
                          ),
                        ),
                        const SizedBox(height: AppSizes.lg),
                      ],
                      // Completed
                      if (state.completedChallenges.isNotEmpty) ...[
                        Text(
                          'challengeCompleted'.tr,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: AppSizes.fontLg,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        ...state.completedChallenges.map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSizes.sm),
                            child: _CompletedChallengeCard(challenge: c),
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSizes.xxxl),
                    ]),
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

// ─── Active Challenge Card ───────────────────────────────────────────────────

class _ActiveChallengeCard extends StatelessWidget {
  const _ActiveChallengeCard({required this.challenge});

  final SleepChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChallengeCubit>();
    final checkedToday = cubit.hasCheckedToday(challenge.id);

    return GlassCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(challenge.type.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.type.titleKey.tr,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      challenge.type.descKey.tr,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppSizes.fontSm,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${challenge.xpReward} XP',
                  style: const TextStyle(
                    color: AppColors.accentGold,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: challenge.progress,
              backgroundColor: AppColors.backgroundMid,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${challenge.completedDays}/${challenge.targetDays} ${'challengeDays'.tr}',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: AppSizes.fontSm,
                ),
              ),
              if (!checkedToday)
                GestureDetector(
                  onTap: () => cubit.checkInToday(challenge.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'challengeCheckIn'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              else
                Text(
                  '✅ ${'challengeCheckedToday'.tr}',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Available Challenge Card ────────────────────────────────────────────────

class _AvailableChallengeCard extends StatelessWidget {
  const _AvailableChallengeCard({required this.challenge});

  final SleepChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          Text(challenge.type.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.type.titleKey.tr,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${challenge.targetDays} ${'challengeDays'.tr} • +${challenge.xpReward} XP',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppSizes.fontSm,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () =>
                context.read<ChallengeCubit>().startChallenge(challenge.id),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'challengeStart'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Completed Challenge Card ────────────────────────────────────────────────

class _CompletedChallengeCard extends StatelessWidget {
  const _CompletedChallengeCard({required this.challenge});

  final SleepChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: GlassCard(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            const Text('🏅', style: TextStyle(fontSize: 28)),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.type.titleKey.tr,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Text(
                    '+${challenge.xpReward} XP ${'challengeEarned'.tr}',
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: AppSizes.fontSm,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
