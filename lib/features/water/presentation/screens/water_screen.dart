import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/services/water_service.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/history/presentation/utils/history_format.dart';

/// Water tracker: today's glasses, daily goal and the last 7 days.
class WaterView extends StatelessWidget {
  static String path = '/water';
  static const int mlPerGlass = 250;

  const WaterView({super.key});

  @override
  Widget build(BuildContext context) {
    final water = Get.find<WaterService>();
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
          icon: Icon(Icons.arrow_back_rounded, color: KaloriColors.onSurface),
          onPressed: () => Get.back<void>(),
        ),
        title: Text('Water', style: context.typography.headlineMd.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: Obx(() {
        final today = water.today;
        final goal = water.goal.value;
        final now = DateTime.now();
        final week = [for (var i = 6; i >= 0; i--) DateTime(now.year, now.month, now.day - i)];

        return ListView(
          padding: const EdgeInsets.fromLTRB(
            KaloriSpacing.containerMargin,
            KaloriSpacing.xs,
            KaloriSpacing.containerMargin,
            KaloriSpacing.xl,
          ),
          children: [
            _TodayCard(
              glasses: today,
              goal: goal,
              onAdd: water.addGlass,
              onRemove: today > 0 ? water.removeGlass : null,
              onSetTo: (n) => water.setGlasses(DateTime.now(), n),
            ),
            const SizedBox(height: KaloriSpacing.md),
            _GoalRow(goal: goal, onChange: water.setGoal),
            Padding(
              padding: const EdgeInsets.fromLTRB(4.0, KaloriSpacing.lg, 4.0, KaloriSpacing.xs),
              child: Text('LAST 7 DAYS', style: context.typography.labelCaps.copyWith(color: KaloriColors.onSurfaceVariant)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: KaloriSpacing.md, vertical: KaloriSpacing.xs),
              decoration: BoxDecoration(
                color: KaloriColors.surfaceContainerLowest,
                borderRadius: KaloriRadius.borderLg,
                border: Border.all(color: KaloriColors.borderSlate),
              ),
              child: Column(
                children: [
                  for (final day in week.reversed)
                    _DayRow(
                      label: day.day == now.day && day.month == now.month
                          ? 'Today'
                          : '${HistoryFormat.weekday(day).substring(0, 3)}, ${HistoryFormat.shortDate(day)}',
                      glasses: water.glassesOn(day),
                      goal: goal,
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _TodayCard extends StatelessWidget {
  final int glasses;
  final int goal;
  final VoidCallback onAdd;
  final VoidCallback? onRemove;
  final ValueChanged<int> onSetTo;

  const _TodayCard({
    required this.glasses,
    required this.goal,
    required this.onAdd,
    required this.onRemove,
    required this.onSetTo,
  });

  @override
  Widget build(BuildContext context) {
    final reached = glasses >= goal;
    return Container(
      padding: const EdgeInsets.all(KaloriSpacing.containerMargin),
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: KaloriRadius.borderLg,
        border: Border.all(color: KaloriColors.borderSlate),
        boxShadow: [BoxShadow(color: KaloriColors.cardShadow, blurRadius: 20.0, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text('TODAY', style: context.typography.labelCaps.copyWith(color: KaloriColors.onSurfaceVariant)),
          const SizedBox(height: KaloriSpacing.xs),
          Row(
            children: [
              _RoundButton(icon: Icons.remove_rounded, tooltip: 'Remove a glass', onPressed: onRemove),
              Expanded(
                child: Semantics(
                  label: '$glasses of $goal glasses',
                  excludeSemantics: true,
                  child: Column(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: '$glasses',
                          style: context.typography.displayNum,
                          children: [TextSpan(text: ' / $goal', style: context.typography.headlineMd.copyWith(color: KaloriColors.outline))],
                        ),
                      ),
                      Text(
                        reached
                            ? 'Goal reached · ${HistoryFormat.number(glasses * WaterView.mlPerGlass)} ml'
                            : '${HistoryFormat.number(glasses * WaterView.mlPerGlass)} ml · ${goal - glasses} to go',
                        style: context.typography.bodySm.copyWith(
                          color: reached ? KaloriColors.primary : KaloriColors.neutralSlate,
                          fontWeight: reached ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _RoundButton(icon: Icons.add_rounded, tooltip: 'Add a glass', onPressed: onAdd, filled: true),
            ],
          ),
          const SizedBox(height: KaloriSpacing.md),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6.0,
            runSpacing: 6.0,
            children: [
              for (var i = 0; i < goal; i++)
                Semantics(
                  button: true,
                  label: 'Set to ${i + 1} glasses',
                  excludeSemantics: true,
                  child: InkWell(
                    borderRadius: KaloriRadius.borderMd,
                    onTap: () => onSetTo(i < glasses && i == glasses - 1 ? i : i + 1),
                    child: Container(
                      width: 34.0,
                      height: 42.0,
                      decoration: BoxDecoration(
                        color: i < glasses ? KaloriColors.tertiaryFixed : KaloriColors.surfaceContainerLow,
                        borderRadius: KaloriRadius.borderMd,
                      ),
                      child: Icon(
                        i < glasses ? Icons.water_drop : Icons.water_drop_outlined,
                        size: 20.0,
                        color: i < glasses ? KaloriColors.tertiary : KaloriColors.outlineVariant,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: KaloriSpacing.xs),
          Text(
            'One glass = ${WaterView.mlPerGlass} ml. Tap a drop to set the count.',
            style: context.typography.bodySm.copyWith(fontSize: 12.0, color: KaloriColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  final int goal;
  final ValueChanged<int> onChange;

  const _GoalRow({required this.goal, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: KaloriSpacing.md, right: 6.0),
      height: 56.0,
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: KaloriRadius.borderLg,
        border: Border.all(color: KaloriColors.borderSlate),
      ),
      child: Row(
        children: [
          Expanded(child: Text('Daily goal', style: context.typography.bodyLg.copyWith(color: KaloriColors.onSurface))),
          IconButton(
            tooltip: 'Lower goal',
            onPressed: goal > 1 ? () => onChange(goal - 1) : null,
            icon: const Icon(Icons.remove_rounded),
          ),
          Text('$goal glasses', style: context.typography.bodyLg.copyWith(fontWeight: FontWeight.w600, color: KaloriColors.onSurface)),
          IconButton(
            tooltip: 'Raise goal',
            onPressed: goal < WaterService.maxPerDay ? () => onChange(goal + 1) : null,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  final String label;
  final int glasses;
  final int goal;

  const _DayRow({required this.label, required this.glasses, required this.goal});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.0,
      child: Row(
        children: [
          SizedBox(
            width: 104.0,
            child: Text(label, style: context.typography.bodySm.copyWith(color: KaloriColors.onSurface, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: KaloriRadius.borderFull,
              child: LinearProgressIndicator(
                value: goal == 0 ? 0 : (glasses / goal).clamp(0.0, 1.0),
                minHeight: 6.0,
                backgroundColor: KaloriColors.surfaceContainer,
                valueColor: AlwaysStoppedAnimation<Color>(KaloriColors.tertiary),
              ),
            ),
          ),
          SizedBox(
            width: 56.0,
            child: Text(
              '$glasses / $goal',
              textAlign: TextAlign.end,
              style: context.typography.bodySm.copyWith(fontWeight: FontWeight.w600, color: KaloriColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool filled;

  const _RoundButton({required this.icon, required this.tooltip, required this.onPressed, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        fixedSize: const Size(52.0, 52.0),
        backgroundColor: filled ? KaloriColors.tertiary : KaloriColors.surfaceContainerLow,
        foregroundColor: filled ? KaloriColors.onTertiary : KaloriColors.onSurface,
        disabledBackgroundColor: KaloriColors.surfaceContainerLow,
      ),
      icon: Icon(icon),
    );
  }
}
