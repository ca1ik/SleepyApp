import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/sleep_timer/cubit/sleep_timer_cubit.dart';
import 'package:sleepy_ai/shared/widgets/common_widgets.dart';

class SleepTimerPage extends StatelessWidget {
  const SleepTimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: BlocBuilder<SleepTimerCubit, SleepTimerState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  pinned: true,
                  title: Text(
                    'sleepTimerTitle'.tr,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.pagePaddingH,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Timer circle
                        _TimerCircle(state: state),
                        const SizedBox(height: AppSizes.xl),
                        // Duration presets
                        if (state.status == SleepTimerStatus.idle) ...[
                          Text(
                            'sleepTimerSelectDuration'.tr,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: AppSizes.fontLg,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSizes.md),
                          _DurationPresets(
                            selected: state.selectedMinutes,
                            onSelected: (m) => context
                                .read<SleepTimerCubit>()
                                .selectDuration(m),
                          ),
                          const SizedBox(height: AppSizes.xl),
                          // Start button
                          SizedBox(
                            width: 200,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () =>
                                  context.read<SleepTimerCubit>().start(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.radiusMd),
                                ),
                              ),
                              child: Text(
                                'sleepTimerStart'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: AppSizes.fontMd,
                                ),
                              ),
                            ),
                          ),
                        ],
                        // Controls when running
                        if (state.status == SleepTimerStatus.running ||
                            state.status == SleepTimerStatus.paused) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Pause/Resume
                              IconButton(
                                onPressed: () {
                                  final cubit = context.read<SleepTimerCubit>();
                                  if (state.status ==
                                      SleepTimerStatus.running) {
                                    cubit.pause();
                                  } else {
                                    cubit.resume();
                                  }
                                },
                                icon: Icon(
                                  state.status == SleepTimerStatus.running
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                  color: AppColors.primary,
                                  size: 56,
                                ),
                              ),
                              const SizedBox(width: AppSizes.lg),
                              // Stop
                              IconButton(
                                onPressed: () =>
                                    context.read<SleepTimerCubit>().stop(),
                                icon: const Icon(
                                  Icons.stop_circle,
                                  color: AppColors.accent,
                                  size: 56,
                                ),
                              ),
                            ],
                          ),
                        ],
                        // Finished
                        if (state.status == SleepTimerStatus.finished) ...[
                          const SizedBox(height: AppSizes.md),
                          Text(
                            'sleepTimerFinished'.tr,
                            style: const TextStyle(
                              color: AppColors.accentGold,
                              fontSize: AppSizes.fontXl,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSizes.md),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<SleepTimerCubit>().stop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: Text(
                              'sleepTimerReset'.tr,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSizes.xxl),
                        // Tip
                        GlassCard(
                          padding: const EdgeInsets.all(AppSizes.md),
                          child: Row(
                            children: [
                              const Text('💡', style: TextStyle(fontSize: 24)),
                              const SizedBox(width: AppSizes.sm),
                              Expanded(
                                child: Text(
                                  'sleepTimerTip'.tr,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: AppSizes.fontSm,
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
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Timer Circle ────────────────────────────────────────────────────────────

class _TimerCircle extends StatelessWidget {
  const _TimerCircle({required this.state});

  final SleepTimerState state;

  @override
  Widget build(BuildContext context) {
    final displayTime = state.status == SleepTimerStatus.idle
        ? '${state.selectedMinutes.toString().padLeft(2, '0')}:00'
        : state.formattedTime;

    return SizedBox(
      width: 220,
      height: 220,
      child: CustomPaint(
        painter: _CircleProgressPainter(
          progress:
              state.status == SleepTimerStatus.idle ? 1.0 : state.progress,
          isActive: state.status != SleepTimerStatus.idle,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.status == SleepTimerStatus.idle ? '🌙' : '😴',
                style: const TextStyle(fontSize: 32),
              ),
              Text(
                displayTime,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  _CircleProgressPainter({required this.progress, required this.isActive});

  final double progress;
  final bool isActive;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.backgroundCard
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (isActive) {
      final progressPaint = Paint()
        ..shader = const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPainter old) =>
      old.progress != progress || old.isActive != isActive;
}

// ─── Duration Presets ────────────────────────────────────────────────────────

class _DurationPresets extends StatelessWidget {
  const _DurationPresets({required this.selected, required this.onSelected});

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: SleepTimerCubit.presets.map((m) {
        final isSelected = m == selected;
        final label = m >= 60 ? '${m ~/ 60}h' : '${m}m';
        return GestureDetector(
          onTap: () => onSelected(m),
          child: Container(
            width: 56,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withAlpha(60)
                  : AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.divider,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color:
                      isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
