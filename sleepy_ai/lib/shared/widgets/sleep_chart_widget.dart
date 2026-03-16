import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/shared/models/entities.dart';

/// Haftalık uyku grafiği — fl_chart bar chart.
/// const constructor ile optimize edilmiş, minimal rebuild.
class SleepChartWidget extends StatelessWidget {
  const SleepChartWidget({
    super.key,
    required this.sleepLogs,
    this.targetHours = 8.0,
  });

  final List<SleepEntity> sleepLogs;
  final double targetHours;

  static const List<String> _days = [
    'Pzt',
    'Sal',
    'Çar',
    'Per',
    'Cum',
    'Cmt',
    'Paz',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 12,
          minY: 0,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => AppColors.backgroundCard,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toStringAsFixed(1)}sa\n${_days[groupIndex]}',
                  const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppSizes.fontSm,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= _days.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    _days[index],
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: AppSizes.fontXs,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 4,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}sa',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: AppSizes.fontXs,
                  ),
                ),
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 4,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: AppColors.divider, strokeWidth: 0.5),
          ),
          borderData: FlBorderData(show: false),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: targetHours,
                color: AppColors.accentTeal.withAlpha(150),
                strokeWidth: 1.5,
                dashArray: [5, 4],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  labelResolver: (_) => 'Hedef ${targetHours.toInt()}sa',
                  style: const TextStyle(
                    color: AppColors.accentTeal,
                    fontSize: AppSizes.fontXs,
                  ),
                ),
              ),
            ],
          ),
          barGroups: _buildBarGroups(),
        ),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(7, (index) {
      final hours = index < sleepLogs.length
          ? sleepLogs[index].duration.inMinutes / 60.0
          : 0.0;
      final color = _getBarColor(hours);

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: hours,
            color: color,
            width: 18,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusSm),
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [color.withAlpha(150), color],
            ),
          ),
        ],
      );
    });
  }

  Color _getBarColor(double hours) {
    if (hours >= 8) return AppColors.scoreExcellent;
    if (hours >= 7) return AppColors.scoreGood;
    if (hours >= 6) return AppColors.scoreFair;
    if (hours > 0) return AppColors.scorePoor;
    return AppColors.surfaceVariant;
  }
}
