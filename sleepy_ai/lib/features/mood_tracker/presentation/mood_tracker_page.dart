import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/mood_tracker/cubit/mood_tracker_cubit.dart';
import 'package:sleepy_ai/features/mood_tracker/cubit/mood_tracker_state.dart';
import 'package:sleepy_ai/features/mood_tracker/domain/mood_models.dart';
import 'package:sleepy_ai/shared/widgets/common_widgets.dart';

class MoodTrackerPage extends StatelessWidget {
  const MoodTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: BlocBuilder<MoodTrackerCubit, MoodTrackerState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  pinned: true,
                  title: Text(
                    'moodTrackerTitle'.tr,
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
                      // Stats
                      _MoodStatsRow(state: state),
                      const SizedBox(height: AppSizes.lg),
                      // Log button
                      if (!state.hasLoggedToday) ...[
                        _LogMoodCard(context: context),
                        const SizedBox(height: AppSizes.lg),
                      ] else ...[
                        GlassCard(
                          padding: const EdgeInsets.all(AppSizes.md),
                          child: Row(
                            children: [
                              const Text('✅', style: TextStyle(fontSize: 28)),
                              const SizedBox(width: AppSizes.sm),
                              Expanded(
                                child: Text(
                                  'moodLoggedToday'.tr,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.lg),
                      ],
                      // Last 7 days mood chart
                      if (state.moods.isNotEmpty) ...[
                        Text(
                          'moodWeeklyTrend'.tr,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: AppSizes.fontLg,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        _MoodWeekChart(moods: state.moods.take(7).toList()),
                        const SizedBox(height: AppSizes.lg),
                      ],
                      // History
                      Text(
                        'moodHistory'.tr,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppSizes.fontLg,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      if (state.moods.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.xxl),
                            child: Text(
                              'moodNoEntries'.tr,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        )
                      else
                        ...state.moods.map(
                          (m) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSizes.sm),
                            child: _MoodEntryCard(entry: m),
                          ),
                        ),
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

// ─── Stats ────────────────────────────────────────────────────────────────────

class _MoodStatsRow extends StatelessWidget {
  const _MoodStatsRow({required this.state});

  final MoodTrackerState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(AppSizes.sm),
            child: Column(
              children: [
                const Text('📊', style: TextStyle(fontSize: 20)),
                Text(
                  state.averageMood.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSizes.fontLg,
                  ),
                ),
                Text(
                  'moodAverage'.tr,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(AppSizes.sm),
            child: Column(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 20)),
                Text(
                  '${state.currentStreak}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSizes.fontLg,
                  ),
                ),
                Text(
                  'moodStreak'.tr,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(AppSizes.sm),
            child: Column(
              children: [
                const Text('📝', style: TextStyle(fontSize: 20)),
                Text(
                  '${state.moods.length}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSizes.fontLg,
                  ),
                ),
                Text(
                  'moodTotalLogs'.tr,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Log Mood Card ────────────────────────────────────────────────────────────

class _LogMoodCard extends StatelessWidget {
  const _LogMoodCard({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext outerCtx) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        children: [
          Text(
            'moodHowAreYou'.tr,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSizes.fontLg,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: MoodLevel.values.map((mood) {
              return GestureDetector(
                onTap: () => _showMoodLogSheet(context, mood),
                child: Column(
                  children: [
                    Text(mood.emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 4),
                    Text(
                      mood.labelKey.tr,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showMoodLogSheet(BuildContext ctx, MoodLevel mood) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: ctx.read<MoodTrackerCubit>(),
        child: _MoodLogSheet(initialMood: mood),
      ),
    );
  }
}

// ─── Weekly Mood Chart ───────────────────────────────────────────────────────

class _MoodWeekChart extends StatelessWidget {
  const _MoodWeekChart({required this.moods});

  final List<MoodEntry> moods;

  @override
  Widget build(BuildContext context) {
    final reversed = moods.reversed.toList();
    return GlassCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: reversed.map((m) {
            final height = (m.mood.score / 5 * 70).toDouble();
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(m.mood.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    Container(
                      height: height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.primary.withAlpha(80),
                            AppColors.primary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${m.date.day}/${m.date.month}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─── Mood Entry Card ──────────────────────────────────────────────────────────

class _MoodEntryCard extends StatelessWidget {
  const _MoodEntryCard({required this.entry});

  final MoodEntry entry;

  @override
  Widget build(BuildContext context) {
    final dateStr = '${entry.date.day}.${entry.date.month}.${entry.date.year}';
    return GlassCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          Text(entry.mood.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.mood.labelKey.tr,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  dateStr,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: AppSizes.fontSm,
                  ),
                ),
                if (entry.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.note,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppSizes.fontSm,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (entry.factors.isNotEmpty)
            Wrap(
              spacing: 2,
              children: entry.factors.take(3).map((f) {
                final factor = kMoodFactors.firstWhere(
                  (mf) => mf.key == f,
                  orElse: () => kMoodFactors.first,
                );
                return Text(factor.emoji, style: const TextStyle(fontSize: 16));
              }).toList(),
            ),
        ],
      ),
    );
  }
}

// ─── Mood Log Sheet ──────────────────────────────────────────────────────────

class _MoodLogSheet extends StatefulWidget {
  const _MoodLogSheet({required this.initialMood});

  final MoodLevel initialMood;

  @override
  State<_MoodLogSheet> createState() => _MoodLogSheetState();
}

class _MoodLogSheetState extends State<_MoodLogSheet> {
  late MoodLevel _selectedMood;
  final _noteCtrl = TextEditingController();
  final _selectedFactors = <String>{};

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.initialMood;
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.pagePaddingH,
        right: AppSizes.pagePaddingH,
        top: AppSizes.lg,
        bottom: bottomInset + AppSizes.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Center(
              child: Text(
                _selectedMood.emoji,
                style: const TextStyle(fontSize: 56),
              ),
            ),
            Center(
              child: Text(
                _selectedMood.labelKey.tr,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppSizes.fontXl,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            // Mood selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: MoodLevel.values.map((m) {
                final isSelected = m == _selectedMood;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = m),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withAlpha(40)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : Colors.transparent,
                      ),
                    ),
                    child: Text(m.emoji, style: const TextStyle(fontSize: 28)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSizes.md),
            // Factors
            Text(
              'moodFactors'.tr,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: kMoodFactors.map((f) {
                final isSelected = _selectedFactors.contains(f.key);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (isSelected) {
                      _selectedFactors.remove(f.key);
                    } else {
                      _selectedFactors.add(f.key);
                    }
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withAlpha(50)
                          : AppColors.backgroundMid,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : AppColors.divider,
                      ),
                    ),
                    child: Text(
                      '${f.emoji} ${f.labelKey.tr}',
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSizes.md),
            // Note
            TextField(
              controller: _noteCtrl,
              maxLines: 3,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'moodNoteHint'.tr,
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.backgroundMid,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            // Save
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
                child: Text(
                  'moodSave'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    final entry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      mood: _selectedMood,
      note: _noteCtrl.text.trim(),
      factors: _selectedFactors.toList(),
    );
    context.read<MoodTrackerCubit>().addMood(entry);
    Navigator.of(context).pop();
  }
}
