import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/history/domain/entities/day_summary.dart';
import 'package:kalori/features/history/domain/entities/period_stats.dart';
import 'package:kalori/features/history/presentation/controllers/history_controller.dart';
import 'package:kalori/features/history/presentation/utils/day_status_style.dart';
import 'package:kalori/features/history/presentation/utils/history_format.dart';
import 'package:kalori/features/history/presentation/widgets/history_common.dart';

/// Month view: summary, calendar (tap a day to open Day detail) and streaks.
class HistoryMonthView extends GetView<HistoryController> {
  const HistoryMonthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final days = controller.focusedMonthDays;
      final stats = controller.statsFor(days);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MonthSummaryCard(stats: stats),
          const SizedBox(height: KaloriSpacing.md),
          _MonthCalendar(days: days),
          const SizedBox(height: KaloriSpacing.md),
          Row(
            children: [
              Expanded(
                child: _StreakTile(
                  label: 'CURRENT',
                  days: controller.currentStreak,
                  icon: Icons.local_fire_department_outlined,
                  iconColor: KaloriColors.secondary,
                  iconBg: KaloriColors.secondaryFixed,
                ),
              ),
              const SizedBox(width: KaloriSpacing.gutter),
              Expanded(
                child: _StreakTile(
                  label: 'BEST RUN',
                  days: controller.bestStreakIn(days),
                  icon: Icons.emoji_events_outlined,
                  iconColor: KaloriColors.tertiary,
                  iconBg: KaloriColors.tertiaryFixed,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _MonthSummaryCard extends GetView<HistoryController> {
  final PeriodStats stats;

  const _MonthSummaryCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return HistoryCard(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, KaloriSpacing.containerMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HistoryPeriodStepper(
            title: HistoryFormat.monthYear(controller.focusedMonth.value),
            onPrevious: controller.previousMonth,
            onNext: controller.canGoToNextMonth ? controller.nextMonth : null,
            previousLabel: 'Previous month',
            nextLabel: 'Next month',
            buttonColor: KaloriColors.surfaceContainerLow,
          ),
          const SizedBox(height: KaloriSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          stats.hasAverage ? HistoryFormat.number(stats.averageCalories) : '—',
                          style: context.typography.displayNum.copyWith(
                            fontSize: 36.0,
                            height: 44.0 / 36.0,
                            letterSpacing: -0.72,
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        Text('kcal', style: context.typography.bodySm),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '${stats.loggedDays} of ${stats.elapsedDays} days logged',
                style: context.typography.bodySm,
              ),
            ],
          ),
          if (stats.elapsedDays > 0) ...[
            const SizedBox(height: KaloriSpacing.sm),
            _StatusMixBar(stats: stats),
            const SizedBox(height: KaloriSpacing.xs),
            Row(
              children: [
                _count(context, stats.onTrack, 'on track'),
                _count(context, stats.close, 'close'),
                _count(context, stats.over, 'over'),
                _count(context, stats.missed, 'missed'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _count(BuildContext context, int value, String label) {
    return Expanded(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$value ',
              style: const TextStyle(fontWeight: FontWeight.w700, color: KaloriColors.onSurface),
            ),
            TextSpan(text: label),
          ],
        ),
        style: context.typography.bodySm.copyWith(
          fontSize: 12.0,
          height: 16.0 / 12.0,
          color: KaloriColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Horizontal stacked bar of on track / close / over / missed day counts.
class _StatusMixBar extends StatelessWidget {
  final PeriodStats stats;

  const _StatusMixBar({required this.stats});

  @override
  Widget build(BuildContext context) {
    final segments = <(int, DayStatus)>[
      (stats.onTrack, DayStatus.onTrack),
      (stats.close, DayStatus.close),
      (stats.over, DayStatus.over),
      (stats.missed, DayStatus.missed),
    ].where((s) => s.$1 > 0).toList();

    if (segments.isEmpty) {
      return const SizedBox.shrink();
    }

    final children = <Widget>[];
    for (var i = 0; i < segments.length; i++) {
      if (i > 0) {
        children.add(const SizedBox(width: 2.0));
      }
      children.add(
        Expanded(
          flex: segments[i].$1,
          child: ColoredBox(color: DayStatusStyle.of(segments[i].$2).fill),
        ),
      );
    }

    return Semantics(
      label: '${stats.onTrack} on track, ${stats.close} close, '
          '${stats.over} over, ${stats.missed} missed',
      excludeSemantics: true,
      child: ClipRRect(
        borderRadius: KaloriRadius.borderFull,
        child: SizedBox(height: 10.0, child: Row(children: children)),
      ),
    );
  }
}

class _MonthCalendar extends GetView<HistoryController> {
  final List<DateTime> days;

  const _MonthCalendar({required this.days});

  @override
  Widget build(BuildContext context) {
    // DateTime.weekday: Monday = 1 … Sunday = 7, so Sunday-first offset is weekday % 7.
    final leadingBlanks = days.first.weekday % 7;
    final today = controller.today;

    return HistoryCard(
      padding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 12.0),
      child: Column(
        children: [
          Row(
            children: [
              for (final initial in HistoryFormat.weekdayInitials)
                Expanded(
                  child: Text(
                    initial,
                    textAlign: TextAlign.center,
                    style: context.typography.labelCaps.copyWith(color: KaloriColors.outline),
                  ),
                ),
            ],
          ),
          const SizedBox(height: KaloriSpacing.xs),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 6.0,
            crossAxisSpacing: 4.0,
            children: [
              for (var i = 0; i < leadingBlanks; i++) const SizedBox.shrink(),
              for (final day in days)
                _CalendarDay(
                  summary: controller.summaryFor(day),
                  status: controller.statusFor(day),
                  isToday: day == today,
                  onTap: () => controller.openDay(day),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final DaySummary summary;
  final DayStatus status;
  final bool isToday;
  final VoidCallback onTap;

  const _CalendarDay({
    required this.summary,
    required this.status,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = DayStatusStyle.of(status);
    final isFuture = status == DayStatus.future;

    final BorderSide side;
    if (isToday) {
      side = const BorderSide(color: KaloriColors.onSurface, width: 2.0);
    } else if (status == DayStatus.missed) {
      side = const BorderSide(color: KaloriColors.outlineVariant, width: 1.5);
    } else {
      side = BorderSide.none;
    }

    final description = StringBuffer(HistoryFormat.longDate(summary.date));
    if (isToday) {
      description.write(', today');
    }
    if (summary.hasLogs) {
      description.write(', ${HistoryFormat.number(summary.calories)} kcal');
    }
    if (!isFuture && style.label.isNotEmpty && !isToday) {
      description.write(', ${style.label.toLowerCase()}');
    }

    return Center(
      child: Semantics(
        button: !isFuture,
        enabled: !isFuture,
        label: description.toString(),
        excludeSemantics: true,
        child: Material(
          color: style.cellBg,
          shape: CircleBorder(side: side),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: isFuture ? null : onTap,
            child: SizedBox(
              width: 40.0,
              height: 40.0,
              child: Center(
                child: Text(
                  '${summary.date.day}',
                  style: context.typography.bodySm.copyWith(
                    color: style.cellFg,
                    fontWeight: switch (status) {
                      DayStatus.over || DayStatus.inProgress => FontWeight.w700,
                      DayStatus.onTrack || DayStatus.close => FontWeight.w600,
                      _ => FontWeight.w400,
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StreakTile extends StatelessWidget {
  final String label;
  final int days;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const _StreakTile({
    required this.label,
    required this.days,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: KaloriSpacing.sm),
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: KaloriRadius.borderLg,
        border: Border.all(color: KaloriColors.borderSlate),
      ),
      child: Row(
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(color: iconBg, borderRadius: KaloriRadius.borderMd),
            child: Icon(icon, color: iconColor, size: 22.0),
          ),
          const SizedBox(width: KaloriSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typography.labelCaps.copyWith(color: KaloriColors.outline),
                ),
                Text(
                  days == 1 ? '1 day' : '$days days',
                  style: context.typography.headlineMd.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
