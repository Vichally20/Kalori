import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/history/domain/entities/day_summary.dart';
import 'package:kalori/features/history/domain/entities/period_stats.dart';
import 'package:kalori/features/history/presentation/controllers/history_controller.dart';
import 'package:kalori/features/history/presentation/utils/day_status_style.dart';
import 'package:kalori/features/history/presentation/utils/history_format.dart';
import 'package:kalori/features/history/presentation/widgets/history_common.dart';

/// Week view: average + bar chart, macro averages, habit tiles and a list of days.
class HistoryWeekView extends GetView<HistoryController> {
  const HistoryWeekView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final days = controller.focusedWeekDays;
      final stats = controller.statsFor(days);
      final previous = controller.statsFor(controller.previousWeekDays);
      final isCurrentWeek = controller.isCurrentWeek;
      final today = controller.today;
      final listedDays = days.reversed.where((d) => !d.isAfter(today)).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HistoryPeriodStepper(
            title: HistoryFormat.weekRange(days.first, days.last),
            subtitle: isCurrentWeek ? 'THIS WEEK' : null,
            onPrevious: controller.previousWeek,
            onNext: controller.canGoToNextWeek ? controller.nextWeek : null,
            previousLabel: 'Previous week',
            nextLabel: 'Next week',
          ),
          const SizedBox(height: KaloriSpacing.md),
          _WeekSummaryCard(days: days, stats: stats, previous: previous),
          const SizedBox(height: KaloriSpacing.md),
          _AverageMacrosCard(stats: stats, controller: controller),
          const SizedBox(height: KaloriSpacing.md),
          Row(
            children: [
              Expanded(
                child: HistoryStatTile(
                  label: 'LOGGED',
                  value: '${stats.loggedDays}',
                  suffix: '/${stats.elapsedDays}',
                  caption: 'days',
                ),
              ),
              const SizedBox(width: KaloriSpacing.gutter),
              Expanded(
                child: HistoryStatTile(
                  label: isCurrentWeek ? 'STREAK' : 'BEST RUN',
                  value: '${isCurrentWeek ? controller.currentStreak : controller.bestStreakIn(days)}',
                  caption: 'days in a row',
                ),
              ),
              const SizedBox(width: KaloriSpacing.gutter),
              Expanded(
                child: HistoryStatTile(
                  label: 'ON TRACK',
                  value: '${stats.onTrack}',
                  suffix: '/${stats.completedDays}',
                  caption: 'full days',
                ),
              ),
            ],
          ),
          const SizedBox(height: KaloriSpacing.lg),
          Text('Days', style: context.typography.headlineMd),
          const SizedBox(height: KaloriSpacing.sm),
          for (final day in listedDays) ...[
            _DayCard(
              summary: controller.summaryFor(day),
              status: controller.statusFor(day),
              isToday: day == today,
              onTap: () => controller.openDay(day),
            ),
            const SizedBox(height: KaloriSpacing.sm),
          ],
        ],
      );
    });
  }
}

class _WeekSummaryCard extends GetView<HistoryController> {
  final List<DateTime> days;
  final PeriodStats stats;
  final PeriodStats previous;

  const _WeekSummaryCard({required this.days, required this.stats, required this.previous});

  @override
  Widget build(BuildContext context) {
    final goal = controller.calorieGoal;
    final difference = goal - stats.averageCalories;
    final String goalText;
    if (!stats.hasAverage) {
      goalText = 'No completed days yet';
    } else if (difference >= 0) {
      goalText = '${HistoryFormat.number(difference)} kcal under your ${HistoryFormat.number(goal)} goal';
    } else {
      goalText = '${HistoryFormat.number(-difference)} kcal over your ${HistoryFormat.number(goal)} goal';
    }

    return HistoryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DAILY AVERAGE',
                      style: context.typography.labelCaps.copyWith(
                        color: KaloriColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          stats.hasAverage ? HistoryFormat.number(stats.averageCalories) : '—',
                          style: context.typography.displayNum,
                        ),
                        const SizedBox(width: 6.0),
                        Text('kcal', style: context.typography.bodySm),
                      ],
                    ),
                    Text(goalText, style: context.typography.bodySm),
                  ],
                ),
              ),
              if (stats.hasAverage && previous.hasAverage)
                _TrendPill(current: stats.averageCalories, previous: previous.averageCalories),
            ],
          ),
          const SizedBox(height: KaloriSpacing.containerMargin),
          _WeekBarChart(days: days),
          const SizedBox(height: KaloriSpacing.md),
          Divider(color: KaloriColors.borderSlate, height: 1.0),
          const SizedBox(height: KaloriSpacing.sm),
          const Wrap(
            spacing: 14.0,
            runSpacing: 8.0,
            children: [
              _LegendItem(status: DayStatus.onTrack, label: 'On track'),
              _LegendItem(status: DayStatus.close, label: 'Close'),
              _LegendItem(status: DayStatus.over, label: 'Over'),
              _LegendItem(status: DayStatus.inProgress, label: 'Today'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendPill extends StatelessWidget {
  final int current;
  final int previous;

  const _TrendPill({required this.current, required this.previous});

  @override
  Widget build(BuildContext context) {
    final percent = previous == 0 ? 0 : ((current - previous) / previous * 100).round();
    final isDown = percent <= 0;
    final sign = percent < 0 ? '−' : (percent > 0 ? '+' : '');
    return Semantics(
      label: '${percent.abs()} percent ${isDown ? 'lower' : 'higher'} than last week',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isDown ? KaloriColors.primaryContainer : KaloriColors.surfaceContainerHigh,
          borderRadius: KaloriRadius.borderFull,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDown ? Icons.trending_down_rounded : Icons.trending_up_rounded,
              size: 14.0,
              color: isDown ? KaloriColors.onPrimaryContainer : KaloriColors.onSurfaceVariant,
            ),
            const SizedBox(width: 4.0),
            Text(
              '$sign${percent.abs()}% vs last',
              style: context.typography.labelCaps.copyWith(
                color: isDown ? KaloriColors.onPrimaryContainer : KaloriColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 7 bars, one per day, with a dashed goal line. Tapping a bar opens that day.
class _WeekBarChart extends GetView<HistoryController> {
  final List<DateTime> days;

  static const double _plotHeight = 140.0;
  static const double _labelHeight = 16.0;

  const _WeekBarChart({required this.days});

  @override
  Widget build(BuildContext context) {
    final goal = controller.calorieGoal;
    final today = controller.today;
    final summaries = days.map(controller.summaryFor).toList();
    final maxCalories = summaries.fold<int>(0, (m, s) => math.max(m, s.calories));
    final scaleMax = math.max(goal * 1.2, maxCalories.toDouble());
    final goalOffset = goal / scaleMax * _plotHeight;

    return Column(
      children: [
        SizedBox(
          height: _plotHeight + _labelHeight + 4.0,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: goalOffset,
                child: const CustomPaint(size: Size(double.infinity, 1.5), painter: _DashedLinePainter()),
              ),
              Positioned(
                right: 0,
                bottom: goalOffset + 4.0,
                child: Container(
                  color: KaloriColors.surfaceContainerLowest,
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    'GOAL ${HistoryFormat.number(goal)}',
                    style: context.typography.labelCaps.copyWith(
                      fontSize: 10.0,
                      height: 12.0 / 10.0,
                      color: KaloriColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < summaries.length; i++) ...[
                      if (i > 0) const SizedBox(width: 10.0),
                      Expanded(
                        child: _Bar(
                          summary: summaries[i],
                          status: summaries[i].statusFor(today),
                          height: summaries[i].calories / scaleMax * _plotHeight,
                          onTap: () => controller.openDay(summaries[i].date),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: KaloriSpacing.xs),
        Row(
          children: [
            for (var i = 0; i < days.length; i++) ...[
              if (i > 0) const SizedBox(width: 10.0),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: days[i] == today
                      ? BoxDecoration(
                          color: KaloriColors.onSurface,
                          borderRadius: KaloriRadius.borderFull,
                        )
                      : null,
                  child: Text(
                    HistoryFormat.weekdayInitials[i],
                    style: context.typography.labelCaps.copyWith(
                      color: days[i] == today ? KaloriColors.onPrimary : KaloriColors.outline,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final DaySummary summary;
  final DayStatus status;
  final double height;
  final VoidCallback onTap;

  const _Bar({
    required this.summary,
    required this.status,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (status == DayStatus.future) {
      return const SizedBox.shrink();
    }

    final style = DayStatusStyle.of(status);
    final isMissed = status == DayStatus.missed;
    final isToday = status == DayStatus.inProgress;
    final label = summary.hasLogs ? HistoryFormat.number(summary.calories) : '—';
    final labelColor = switch (status) {
      DayStatus.over => KaloriColors.error,
      DayStatus.close => KaloriColors.secondary,
      DayStatus.inProgress => KaloriColors.primary,
      DayStatus.missed => KaloriColors.outline,
      _ => KaloriColors.onSurfaceVariant,
    };

    final BoxDecoration decoration;
    if (isToday) {
      decoration = BoxDecoration(
        color: KaloriColors.successTint,
        border: Border.all(color: KaloriColors.successGreen, width: 1.5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0), bottom: Radius.circular(4.0)),
      );
    } else if (isMissed) {
      decoration = BoxDecoration(color: style.fill, borderRadius: KaloriRadius.borderSm);
    } else {
      decoration = BoxDecoration(
        color: style.fill,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0), bottom: Radius.circular(4.0)),
      );
    }

    return Semantics(
      button: true,
      label: '${HistoryFormat.weekday(summary.date)}, '
          '${summary.hasLogs ? '$label kcal' : 'nothing logged'}'
          '${style.label.isEmpty ? '' : ', ${style.label.toLowerCase()}'}',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: context.typography.labelCaps.copyWith(
                  fontSize: 10.0,
                  height: 12.0 / 10.0,
                  letterSpacing: 0,
                  fontWeight: status == DayStatus.over ? FontWeight.w700 : FontWeight.w600,
                  color: labelColor,
                ),
              ),
            ),
            const SizedBox(height: 4.0),
            Container(
              constraints: const BoxConstraints(maxWidth: 28.0),
              height: isMissed ? 6.0 : math.max(height, 6.0),
              decoration: decoration,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = KaloriColors.outline
      ..strokeWidth = 1.5;
    const dash = 5.0;
    const gap = 4.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(math.min(x + dash, size.width), 0), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) => false;
}

class _LegendItem extends StatelessWidget {
  final DayStatus status;
  final String label;

  const _LegendItem({required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    final isToday = status == DayStatus.inProgress;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: isToday ? KaloriColors.successTint : DayStatusStyle.of(status).fill,
            border: isToday ? Border.all(color: KaloriColors.successGreen, width: 1.5) : null,
            borderRadius: BorderRadius.circular(3.0),
          ),
        ),
        const SizedBox(width: 6.0),
        Text(
          label,
          style: context.typography.bodySm.copyWith(
            fontSize: 12.0,
            height: 16.0 / 12.0,
            color: KaloriColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _AverageMacrosCard extends StatelessWidget {
  final PeriodStats stats;
  final HistoryController controller;

  const _AverageMacrosCard({required this.stats, required this.controller});

  @override
  Widget build(BuildContext context) {
    return HistoryCard(
      padding: const EdgeInsets.symmetric(horizontal: KaloriSpacing.containerMargin, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AVERAGE MACROS / DAY',
            style: context.typography.labelCaps.copyWith(color: KaloriColors.onSurfaceVariant),
          ),
          const SizedBox(height: KaloriSpacing.sm),
          Row(
            children: [
              _macro(context, 'CARBS', stats.averageCarbs, controller.targets.carbs, KaloriColors.tertiary,
                  KaloriColors.surfaceContainerHigh),
              const SizedBox(width: KaloriSpacing.md),
              _macro(context, 'PROTEIN', stats.averageProtein, controller.targets.protein, KaloriColors.primary,
                  KaloriColors.surfaceContainerHighest),
              const SizedBox(width: KaloriSpacing.md),
              _macro(context, 'FAT', stats.averageFat, controller.targets.fat, KaloriColors.secondary,
                  KaloriColors.secondaryFixed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _macro(BuildContext context, String label, int value, int goal, Color color, Color track) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.typography.labelCaps.copyWith(color: color)),
          const SizedBox(height: 6.0),
          HistoryProgressBar(value: goal == 0 ? 0 : value / goal, color: color, trackColor: track),
          const SizedBox(height: 6.0),
          Text.rich(
            TextSpan(
              text: '${value}g',
              children: [
                TextSpan(
                  text: ' / $goal',
                  style: context.typography.bodySm.copyWith(
                    fontSize: 12.0,
                    color: KaloriColors.outline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            style: context.typography.bodyLg.copyWith(
              fontWeight: FontWeight.w700,
              color: KaloriColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final DaySummary summary;
  final DayStatus status;
  final bool isToday;
  final VoidCallback onTap;

  const _DayCard({
    required this.summary,
    required this.status,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = DayStatusStyle.of(status);
    final isMissed = status == DayStatus.missed;
    final itemCount = summary.entries.length;
    final itemsText = isMissed ? 'nothing logged' : '$itemCount ${itemCount == 1 ? 'item' : 'items'}';
    final title = isToday ? 'Today' : HistoryFormat.weekday(summary.date);
    final over = summary.calories - summary.calorieGoal;
    final badgeLabel = status == DayStatus.over ? 'OVER +${HistoryFormat.number(over)}' : null;

    return Material(
      color: KaloriColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: KaloriRadius.borderLg,
        side: BorderSide(
          color: isMissed ? KaloriColors.outlineVariant : KaloriColors.borderSlate,
          width: isMissed ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        borderRadius: KaloriRadius.borderLg,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: context.typography.bodyLg.copyWith(
                            fontWeight: FontWeight.w600,
                            color: KaloriColors.onSurface,
                          ),
                        ),
                        Text(
                          '${HistoryFormat.shortDate(summary.date)} • $itemsText',
                          style: context.typography.bodySm.copyWith(color: KaloriColors.outline),
                        ),
                      ],
                    ),
                  ),
                  if (!isMissed)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: HistoryFormat.number(summary.calories),
                            children: [
                              TextSpan(
                                text: ' / ${HistoryFormat.number(summary.calorieGoal)}',
                                style: context.typography.bodySm.copyWith(
                                  fontSize: 12.0,
                                  color: KaloriColors.outline,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          style: context.typography.bodyLg.copyWith(
                            fontWeight: FontWeight.w700,
                            color: KaloriColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        DayStatusBadge(status: status, label: badgeLabel),
                      ],
                    )
                  else
                    Icon(Icons.chevron_right_rounded, color: KaloriColors.outline),
                ],
              ),
              if (!isMissed) ...[
                const SizedBox(height: 10.0),
                HistoryProgressBar(value: summary.progress, color: style.fill),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
