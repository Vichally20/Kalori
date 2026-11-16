import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/core/utilities/food_icon_helper.dart';
import 'package:kalori/features/history/domain/entities/day_summary.dart';
import 'package:kalori/features/history/presentation/controllers/history_controller.dart';
import 'package:kalori/features/history/presentation/utils/day_status_style.dart';
import 'package:kalori/features/history/presentation/utils/history_format.dart';
import 'package:kalori/features/home/presentation/controllers/home_controller.dart';
import 'package:kalori/features/log/domain/entities/meal_log_entry.dart';
import 'package:kalori/features/profile/domain/entities/daily_targets.dart';
import 'package:kalori/shared/shared.dart';

/// Day detail: the selected day's ring, insight and meals, with previous / next day arrows.
class HistoryDayView extends GetView<HistoryController> {
  static String path = '/history/day';

  const HistoryDayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KaloriColors.background,
      appBar: AppBar(
        backgroundColor: KaloriColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded, color: KaloriColors.onSurface),
          onPressed: () => Get.back<void>(),
        ),
        title: Obx(() {
          final day = controller.selectedDay.value;
          final isToday = day == controller.today;
          return Text(
            isToday
                ? 'Today, ${HistoryFormat.shortDate(day)}'
                : '${HistoryFormat.weekday(day)}, ${HistoryFormat.shortDate(day)}',
            style: context.typography.headlineMd.copyWith(fontWeight: FontWeight.w700),
          );
        }),
        actions: [
          IconButton(
            tooltip: 'Previous day',
            icon: const Icon(Icons.chevron_left_rounded, color: KaloriColors.onSurfaceVariant),
            onPressed: controller.previousDay,
          ),
          Obx(
            () => IconButton(
              tooltip: 'Next day',
              icon: const Icon(Icons.chevron_right_rounded),
              color: KaloriColors.onSurfaceVariant,
              disabledColor: KaloriColors.outlineVariant,
              onPressed: controller.canGoToNextDay ? controller.nextDay : null,
            ),
          ),
          const SizedBox(width: 4.0),
        ],
      ),
      body: Obx(() {
        final summary = controller.summaryFor(controller.selectedDay.value);
        final status = summary.statusFor(controller.today);
        final isToday = status == DayStatus.inProgress;

        return ListView(
          padding: const EdgeInsets.fromLTRB(
            KaloriSpacing.containerMargin,
            KaloriSpacing.md,
            KaloriSpacing.containerMargin,
            KaloriSpacing.xl,
          ),
          children: [
            _DayRing(summary: summary, status: status),
            if (summary.hasLogs) ...[
              const SizedBox(height: KaloriSpacing.md),
              _DayInsightCard(summary: summary, status: status),
            ],
            const SizedBox(height: KaloriSpacing.lg),
            Text('Meals', style: context.typography.headlineMd),
            const SizedBox(height: KaloriSpacing.sm),
            if (summary.hasLogs)
              ..._mealGroups(summary)
            else
              _EmptyDay(isToday: isToday),
            if (isToday) ...[
              const SizedBox(height: KaloriSpacing.lg),
              OutlinedButton.icon(
                onPressed: _openLogTab,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add food'),
              ),
            ],
          ],
        );
      }),
    );
  }

  List<Widget> _mealGroups(DaySummary summary) {
    final groups = <_MealSlot, List<MealLogEntry>>{};
    for (final entry in summary.entries) {
      groups.putIfAbsent(_MealSlot.of(entry.createdAt), () => <MealLogEntry>[]).add(entry);
    }
    final widgets = <Widget>[];
    for (final slot in _MealSlot.values) {
      final entries = groups[slot];
      if (entries == null) {
        continue;
      }
      if (widgets.isNotEmpty) {
        widgets.add(const SizedBox(height: KaloriSpacing.containerMargin));
      }
      widgets.add(_MealGroup(slot: slot, entries: entries));
    }
    return widgets;
  }

  /// Logging always targets today, so this returns to the shell and opens the Log tab.
  void _openLogTab() {
    Get.back<void>();
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().changeTab(1);
    }
  }
}

/// Meal grouping by time of day.
enum _MealSlot {
  breakfast('BREAKFAST'),
  lunch('LUNCH'),
  snack('SNACK'),
  dinner('DINNER');

  final String label;

  const _MealSlot(this.label);

  static _MealSlot of(DateTime time) {
    if (time.hour < 11) {
      return _MealSlot.breakfast;
    }
    if (time.hour < 15) {
      return _MealSlot.lunch;
    }
    if (time.hour < 18) {
      return _MealSlot.snack;
    }
    return _MealSlot.dinner;
  }
}

class _DayRing extends StatelessWidget {
  final DaySummary summary;
  final DayStatus status;

  const _DayRing({required this.summary, required this.status});

  @override
  Widget build(BuildContext context) {
    final style = DayStatusStyle.of(status);
    final showBadge = status != DayStatus.missed;
    return GenericCalorieRingWidget(
      progressPercent: summary.progress,
      centerLabel: 'EATEN',
      centerValue: HistoryFormat.number(summary.calories),
      centerUnit: 'of ${HistoryFormat.number(summary.calorieGoal)} kcal',
      ringSize: 180.0,
      strokeWidth: 16.0,
      progressColor: status == DayStatus.inProgress ? KaloriColors.successGreen : style.fill,
      showBadge: showBadge,
      badgeText: showBadge ? style.label : null,
      badgeIcon: style.icon,
      badgeBgColor: style.badgeBg,
      badgeTextColor: style.badgeFg,
      macros: _macros(Get.find<HistoryController>().targets),
    );
  }

  List<MacroData> _macros(DailyTargets t) {
    double share(int value, int goal) => goal <= 0 ? 0 : value / goal;
    return [
      MacroData(
        label: 'CARBS',
        valueText: '${summary.carbs}g',
        progress: share(summary.carbs, t.carbs),
        color: KaloriColors.tertiary,
        trackColor: KaloriColors.surfaceContainerHigh,
      ),
      MacroData(
        label: 'PROTEIN',
        valueText: '${summary.protein}g',
        progress: share(summary.protein, t.protein),
        color: KaloriColors.primary,
        trackColor: KaloriColors.surfaceContainerHighest,
      ),
      MacroData(
        label: 'FAT',
        valueText: '${summary.fat}g',
        progress: share(summary.fat, t.fat),
        color: KaloriColors.secondary,
        trackColor: KaloriColors.secondaryFixed,
      ),
    ];
  }
}

/// Dark insight card (same style as Tip of the Day) with a rule-based note about the day.
class _DayInsightCard extends StatelessWidget {
  final DaySummary summary;
  final DayStatus status;

  const _DayInsightCard({required this.summary, required this.status});

  @override
  Widget build(BuildContext context) {
    final (title, body) = _insight();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: KaloriSpacing.lg, vertical: KaloriSpacing.containerMargin),
      decoration: BoxDecoration(
        color: KaloriColors.inverseSurface,
        borderRadius: KaloriRadius.borderLg,
        boxShadow: const [
          BoxShadow(color: KaloriColors.cardShadow, blurRadius: 20.0, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DAY INSIGHT',
            style: context.typography.labelCaps.copyWith(color: KaloriColors.inversePrimary),
          ),
          const SizedBox(height: KaloriSpacing.xs),
          Text(
            title,
            style: context.typography.headlineMd.copyWith(
              fontSize: 18.0,
              height: 24.0 / 18.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            body,
            style: context.typography.bodySm.copyWith(color: KaloriColors.outlineVariant),
          ),
        ],
      ),
    );
  }

  (String, String) _insight() {
    final proteinGoal = Get.find<HistoryController>().targets.protein;
    final proteinShare = proteinGoal == 0 ? 1.0 : summary.protein / proteinGoal;
    if (status == DayStatus.over) {
      final over = HistoryFormat.number(summary.calories - summary.calorieGoal);
      return (
        'You went $over kcal over your goal.',
        'One lighter meal tomorrow evens it out. Swapping fried sides for vegetables is an easy start.',
      );
    }
    if (proteinShare < 0.6) {
      return (
        'Protein was low at ${summary.protein}g.',
        'Adding beans, moi moi, eggs or fish to a meal would close most of the gap.',
      );
    }
    if (status == DayStatus.close) {
      return (
        'You landed close to your goal.',
        'Nice control. Keep an eye on late-evening snacks.',
      );
    }
    if (status == DayStatus.inProgress) {
      final left = summary.calorieGoal - summary.calories;
      return left >= 0
          ? ('${HistoryFormat.number(left)} kcal left today.', 'You have room for a balanced dinner.')
          : ("You are over today's goal.", 'Keep the rest of the day light.');
    }
    return (
      'A balanced day.',
      'You stayed within your goal with ${summary.protein}g of protein.',
    );
  }
}

class _MealGroup extends StatelessWidget {
  final _MealSlot slot;
  final List<MealLogEntry> entries;

  const _MealGroup({required this.slot, required this.entries});

  @override
  Widget build(BuildContext context) {
    var subtotal = 0;
    for (final entry in entries) {
      subtotal += entry.foodItem!.nutritionalInfo.calories;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, KaloriSpacing.xs),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${slot.label} · ${HistoryFormat.time(entries.first.createdAt)}',
                  style: context.typography.labelCaps.copyWith(color: KaloriColors.onSurfaceVariant),
                ),
              ),
              Text(
                '${HistoryFormat.number(subtotal)} kcal',
                style: context.typography.bodySm.copyWith(
                  fontWeight: FontWeight.w700,
                  color: KaloriColors.onSurface,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: KaloriSpacing.md),
          decoration: BoxDecoration(
            color: KaloriColors.surfaceContainerLowest,
            borderRadius: KaloriRadius.borderLg,
            border: Border.all(color: KaloriColors.borderSlate),
          ),
          child: Column(
            children: [
              for (var i = 0; i < entries.length; i++) ...[
                if (i > 0) const Divider(color: KaloriColors.borderSlate, height: 1.0),
                _MealItemRow(entry: entries[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MealItemRow extends StatelessWidget {
  final MealLogEntry entry;

  const _MealItemRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final food = entry.foodItem!;
    final icon = FoodIconHelper.getIconForFood(food.title);
    return SizedBox(
      height: 60.0,
      child: Row(
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(color: icon.iconBgColor, borderRadius: KaloriRadius.borderMd),
            child: Icon(icon.icon, color: icon.iconColor, size: 20.0),
          ),
          const SizedBox(width: KaloriSpacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typography.bodyLg.copyWith(
                    fontWeight: FontWeight.w600,
                    color: KaloriColors.onSurface,
                    height: 22.0 / 16.0,
                  ),
                ),
                if (food.subtitle.isNotEmpty)
                  Text(
                    food.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.bodySm.copyWith(
                      fontSize: 13.0,
                      height: 18.0 / 13.0,
                      color: KaloriColors.outline,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: KaloriSpacing.xs),
          Text(
            HistoryFormat.number(food.nutritionalInfo.calories),
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

class _EmptyDay extends StatelessWidget {
  final bool isToday;

  const _EmptyDay({required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KaloriSpacing.lg, horizontal: KaloriSpacing.lg),
      child: Column(
        children: [
          Container(
            width: 72.0,
            height: 72.0,
            decoration: const BoxDecoration(
              color: KaloriColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.no_meals_outlined, size: 34.0, color: KaloriColors.primary),
          ),
          const SizedBox(height: KaloriSpacing.md),
          Text(
            'Nothing logged',
            style: context.typography.headlineMd.copyWith(fontSize: 18.0, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: KaloriSpacing.xs),
          Text(
            isToday ? 'Log a meal to start today.' : 'No meals were logged on this day.',
            textAlign: TextAlign.center,
            style: context.typography.bodySm,
          ),
        ],
      ),
    );
  }
}
