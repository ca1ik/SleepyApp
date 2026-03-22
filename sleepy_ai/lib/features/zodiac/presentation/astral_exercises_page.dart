import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/features/zodiac/domain/zodiac_models.dart';
import 'package:sleepy_ai/shared/widgets/galaxy_background.dart';
import 'package:sleepy_ai/shared/widgets/cosmic_particles.dart';

class AstralExercisesPage extends StatelessWidget {
  const AstralExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = AstralExercise.all;
    return Scaffold(
      backgroundColor: AppColors.galaxyDeep,
      body: GalaxyBackground(
        starCount: 180,
        nebulaCount: 4,
        child: Stack(
          children: [
            const CosmicParticleOverlay(
              particleCount: 50,
              baseColor: Color(0xFF14B8A6),
              secondaryColor: Color(0xFF7C3AED),
              speed: 0.3,
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: exercises.length,
                      itemBuilder: (_, i) => _ExerciseCard(
                        exercise: exercises[i],
                        index: i,
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
              'astral_exercises_title'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.exercise, required this.index});

  final AstralExercise exercise;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => Get.toNamed(
          AppStrings.routeAstralExerciseDetail,
          arguments: exercise,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                exercise.category.color.withAlpha(25),
                AppColors.backgroundCard.withAlpha(140),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: exercise.category.color.withAlpha(50),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      exercise.category.color.withAlpha(100),
                      exercise.category.color.withAlpha(40),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  exercise.iconData,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.titleKey.tr,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exercise.descriptionKey.tr,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _Tag(
                          icon: Icons.timer_outlined,
                          text: '${exercise.durationMinutes} min',
                          color: AppColors.accentTeal,
                        ),
                        const SizedBox(width: 8),
                        _Tag(
                          icon: Icons.star_rounded,
                          text: '${'difficulty'.tr}: ${exercise.difficulty}/5',
                          color: AppColors.accentGold,
                        ),
                        const SizedBox(width: 8),
                        _Tag(
                          icon: Icons.category_rounded,
                          text: exercise.category.nameKey.tr,
                          color: exercise.category.color,
                        ),
                      ],
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
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 10),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
                color: color, fontSize: 9, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
