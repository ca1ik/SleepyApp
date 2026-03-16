import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/sleep_tracking/bloc/sleep_cycle_bloc.dart';
import 'package:sleepy_ai/features/sleep_tracking/bloc/sleep_cycle_event.dart';
import 'package:sleepy_ai/features/sleep_tracking/bloc/sleep_cycle_state.dart';
import 'package:sleepy_ai/shared/widgets/common_widgets.dart';
import 'package:sleepy_ai/shared/widgets/sleep_chart_widget.dart';

class SleepTrackingPage extends StatefulWidget {
  const SleepTrackingPage({super.key});

  @override
  State<SleepTrackingPage> createState() => _SleepTrackingPageState();
}

class _SleepTrackingPageState extends State<SleepTrackingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    context.read<SleepCycleBloc>().add(const LoadSleepHistory());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: BlocConsumer<SleepCycleBloc, SleepCycleState>(
            listener: (context, state) {
              if (state is SleepRecordSaved) {
                Get.snackbar(
                  'Kaydedildi 🌙',
                  'Uyku kaydın başarıyla eklendi.',
                  backgroundColor: AppColors.success.withAlpha(220),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                  margin: const EdgeInsets.all(AppSizes.md),
                  borderRadius: AppSizes.radiusMd,
                );
              } else if (state is SleepError) {
                Get.snackbar(
                  'Hata',
                  state.message,
                  backgroundColor: AppColors.error.withAlpha(220),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                  margin: const EdgeInsets.all(AppSizes.md),
                  borderRadius: AppSizes.radiusMd,
                );
              }
            },
            builder: (context, state) {
              if (state is SleepLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryLight,
                  ),
                );
              }

              if (state is SleepHistoryLoaded) {
                return _buildContent(context, state);
              }

              return const Center(
                child: Text(
                  'Uyku verisi yükleniyor...',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SleepHistoryLoaded state) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          expandedHeight: 120,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'Uyku Takibi',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.backgroundGradient,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Get.toNamed(AppStrings.routeSounds),
              icon: const Icon(
                Icons.music_note_rounded,
                color: AppColors.textPrimary,
              ),
              tooltip: 'Sesler',
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.pagePaddingH,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Uyku puanı kartı
              _buildScoreCard(state),
              const SizedBox(height: AppSizes.lg),
              // Haftalık grafik
              SleepChartWidget(
                sleepLogs: state.records,
                targetHours: state.goalHours,
              ),
              const SizedBox(height: AppSizes.lg),
              // Takip etme butonu
              _buildTrackingButton(state),
              const SizedBox(height: AppSizes.lg),
              // El ile kayıt girme
              _buildManualEntry(context),
              const SizedBox(height: AppSizes.lg),
              // Son kayıtlar
              if (state.records.isNotEmpty) _buildRecentRecords(state),
              const SizedBox(height: AppSizes.xxxl),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCard(SleepHistoryLoaded state) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Uyku Puanı',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppSizes.fontSm,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  '${state.sleepScore}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  '/ 100',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: AppSizes.fontSm,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _statRow(
                  'Haftalık Ort.',
                  '${state.weeklyAverage.toStringAsFixed(1)}s',
                ),
                const SizedBox(height: AppSizes.sm),
                _statRow(
                  'Uyku Borcu',
                  state.sleepDebt > 0
                      ? '+${state.sleepDebt.toStringAsFixed(1)}s'
                      : '0s',
                  color: state.sleepDebt > 0
                      ? AppColors.warning
                      : AppColors.success,
                ),
                const SizedBox(height: AppSizes.sm),
                _statRow('Hedef', '${state.goalHours.toStringAsFixed(1)}s'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppSizes.fontSm,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? AppColors.textPrimary,
            fontSize: AppSizes.fontSm,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingButton(SleepHistoryLoaded state) {
    if (state.isTracking) {
      return ScaleTransition(
        scale: _pulseAnimation,
        child: GradientButton(
          label: 'Uykuyu Bitir',
          onPressed: () {
            context.read<SleepCycleBloc>().add(const StopSleepTracking());
          },
          icon: Icons.alarm_off_rounded,
        ),
      );
    }

    return GradientButton(
      label: 'Uyumaya Başla',
      onPressed: () {
        context.read<SleepCycleBloc>().add(StartSleepTracking(DateTime.now()));
      },
      icon: Icons.bedtime_rounded,
    );
  }

  Widget _buildManualEntry(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: InkWell(
        onTap: () => _showAddSleepDialog(context),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: const Row(
          children: [
            Icon(Icons.edit_note_rounded, color: AppColors.primaryLight),
            SizedBox(width: AppSizes.sm),
            Text(
              'El ile uyku kaydı ekle',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRecords(SleepHistoryLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Son Kayıtlar',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppSizes.fontLg,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        ...state.records.take(5).map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sm),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bedtime_outlined,
                        color: AppColors.primaryLight,
                        size: 18,
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatDate(r.bedtime),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: AppSizes.fontXs,
                              ),
                            ),
                            Text(
                              '${_formatTime(r.bedtime)} → ${_formatTime(r.wakeTime)}',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${(r.duration.inMinutes / 60.0).toStringAsFixed(1)}s',
                        style: TextStyle(
                          color: (r.duration.inMinutes / 60.0) >= 7
                              ? AppColors.success
                              : AppColors.warning,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      // Kalite yıldızları
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < (r.qualityScore ~/ 20)
                                ? Icons.star
                                : Icons.star_border,
                            size: 12,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ],
    );
  }

  void _showAddSleepDialog(BuildContext context) {
    DateTime bedTime = DateTime.now().subtract(const Duration(hours: 8));
    DateTime wakeTime = DateTime.now();
    int quality = 3;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXxl),
        ),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Uyku Kaydı Ekle',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppSizes.fontLg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  // Yatış saati
                  ListTile(
                    leading: const Icon(
                      Icons.bedtime_outlined,
                      color: AppColors.primaryLight,
                    ),
                    title: const Text(
                      'Yatış Saati',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    subtitle: Text(
                      _formatTime(bedTime),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: ctx,
                        initialTime: TimeOfDay.fromDateTime(bedTime),
                      );
                      if (picked != null) {
                        setModalState(() {
                          bedTime = DateTime(
                            bedTime.year,
                            bedTime.month,
                            bedTime.day,
                            picked.hour,
                            picked.minute,
                          );
                        });
                      }
                    },
                  ),
                  // Kalkış saati
                  ListTile(
                    leading: const Icon(
                      Icons.alarm_rounded,
                      color: AppColors.accent,
                    ),
                    title: const Text(
                      'Kalkış Saati',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    subtitle: Text(
                      _formatTime(wakeTime),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: ctx,
                        initialTime: TimeOfDay.fromDateTime(wakeTime),
                      );
                      if (picked != null) {
                        setModalState(() {
                          wakeTime = DateTime(
                            wakeTime.year,
                            wakeTime.month,
                            wakeTime.day,
                            picked.hour,
                            picked.minute,
                          );
                        });
                      }
                    },
                  ),
                  // Kalite
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Uyku Kalitesi',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (i) => IconButton(
                              onPressed: () =>
                                  setModalState(() => quality = i + 1),
                              icon: Icon(
                                i < quality ? Icons.star : Icons.star_border,
                                color: AppColors.accent,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  GradientButton(
                    label: 'Kaydet',
                    onPressed: () {
                      context.read<SleepCycleBloc>().add(
                            SaveSleepRecord(
                              bedTime: bedTime,
                              wakeTime: wakeTime,
                              quality: quality,
                            ),
                          );
                      Navigator.of(ctx).pop();
                    },
                    icon: Icons.save_rounded,
                  ),
                  SizedBox(
                    height: MediaQuery.of(ctx).viewInsets.bottom + AppSizes.md,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
