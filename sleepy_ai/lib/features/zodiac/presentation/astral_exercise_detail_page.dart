import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/features/zodiac/domain/zodiac_models.dart';
import 'package:sleepy_ai/shared/widgets/galaxy_background.dart';
import 'package:sleepy_ai/shared/widgets/cosmic_particles.dart';

class AstralExerciseDetailPage extends StatefulWidget {
  const AstralExerciseDetailPage({super.key});

  @override
  State<AstralExerciseDetailPage> createState() =>
      _AstralExerciseDetailPageState();
}

class _AstralExerciseDetailPageState extends State<AstralExerciseDetailPage>
    with TickerProviderStateMixin {
  late final AstralExercise exercise;
  late final AnimationController _breathCtrl;
  late final AnimationController _stepCtrl;
  int _currentStep = 0;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    exercise = Get.arguments as AstralExercise;
    _breathCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    _stepCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _breathCtrl.dispose();
    _stepCtrl.dispose();
    super.dispose();
  }

  void _startExercise() {
    setState(() => _isActive = true);
    _breathCtrl.repeat(reverse: true);
  }

  void _nextStep() {
    if (_currentStep < exercise.steps.length - 1) {
      _stepCtrl.forward(from: 0).then((_) {
        setState(() => _currentStep++);
      });
    } else {
      // Exercise complete
      setState(() => _isActive = false);
      _breathCtrl.stop();
      Get.snackbar(
        'exercise_complete'.tr,
        'exercise_complete_sub'.tr,
        backgroundColor: AppColors.success.withAlpha(200),
        colorText: Colors.white,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _stepCtrl.forward(from: 0).then((_) {
        setState(() => _currentStep--);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.galaxyDeep,
      body: GalaxyBackground(
        starCount: 200,
        nebulaCount: 5,
        child: Stack(
          children: [
            CosmicParticleOverlay(
              particleCount: 70,
              baseColor: exercise.category.color,
              secondaryColor: AppColors.galaxyStardust,
              speed: 0.3,
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: _isActive ? _buildActiveExercise() : _buildIntro(),
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
              exercise.titleKey.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildIntro() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Animated cosmic orb
          AnimatedBuilder(
            animation: _breathCtrl,
            builder: (_, __) {
              final t = _breathCtrl.isAnimating ? _breathCtrl.value : 0.5;
              return Container(
                width: 140 + t * 30,
                height: 140 + t * 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      exercise.category.color.withAlpha(120),
                      exercise.category.color.withAlpha(40),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: exercise.category.color.withAlpha(50),
                      blurRadius: 40 + t * 20,
                      spreadRadius: 5 + t * 10,
                    ),
                  ],
                ),
                child: Icon(
                  exercise.iconData,
                  color: Colors.white.withAlpha(200),
                  size: 60,
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Text(
            exercise.descriptionKey.tr,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Info chips
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Chip(
                icon: Icons.timer_outlined,
                text: '${exercise.durationMinutes} ${'minutes'.tr}',
              ),
              const SizedBox(width: 12),
              _Chip(
                icon: Icons.star_outline_rounded,
                text: '${exercise.difficulty}/5',
              ),
              const SizedBox(width: 12),
              _Chip(
                icon: Icons.format_list_numbered_rounded,
                text: '${exercise.steps.length} ${'steps'.tr}',
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Start button
          GestureDetector(
            onTap: _startExercise,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    exercise.category.color,
                    exercise.category.color.withAlpha(180),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: exercise.category.color.withAlpha(60),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'start_exercise'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildActiveExercise() {
    return Column(
      children: [
        // Breathing orb
        Expanded(
          flex: 3,
          child: Center(
            child: AnimatedBuilder(
              animation: _breathCtrl,
              builder: (_, __) {
                final t = _breathCtrl.value;
                final scale = 0.7 + t * 0.6;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          exercise.category.color.withAlpha(150),
                          exercise.category.color.withAlpha(50),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: exercise.category.color.withAlpha(60),
                          blurRadius: 50,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        t < 0.5 ? 'breathe_in'.tr : 'breathe_out'.tr,
                        style: TextStyle(
                          color: Colors.white.withAlpha(180),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Step content
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Progress indicator
                Row(
                  children: List.generate(exercise.steps.length, (i) {
                    return Expanded(
                      child: Container(
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: i <= _currentStep
                              ? exercise.category.color
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  '${'step'.tr} ${_currentStep + 1}/${exercise.steps.length}',
                  style: TextStyle(
                    color: exercise.category.color,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),

                // Step text
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard.withAlpha(120),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: exercise.category.color.withAlpha(40),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        exercise.steps[_currentStep].tr,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          height: 1.7,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Navigation buttons
                Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: GestureDetector(
                          onTap: _prevStep,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              'previous'.tr,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _nextStep,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                exercise.category.color,
                                exercise.category.color.withAlpha(180),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _currentStep == exercise.steps.length - 1
                                ? 'complete'.tr
                                : 'next'.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard.withAlpha(120),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textMuted, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
