import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/history/presentation/utils/history_format.dart';
import 'package:kalori/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:kalori/features/onboarding/presentation/widgets/onboarding_common.dart';
import 'package:kalori/features/profile/domain/entities/user_profile.dart';
import 'package:lottie/lottie.dart';

const EdgeInsets _stepPadding = EdgeInsets.fromLTRB(
  KaloriSpacing.containerMargin,
  KaloriSpacing.lg,
  KaloriSpacing.containerMargin,
  KaloriSpacing.lg,
);

BoxDecoration _cardDecoration() => BoxDecoration(
      color: KaloriColors.surfaceContainerLowest,
      borderRadius: KaloriRadius.borderLg,
      border: Border.all(color: KaloriColors.borderSlate),
      boxShadow: [BoxShadow(color: KaloriColors.cardShadow, blurRadius: 20.0, offset: const Offset(0, 4))],
    );

// -----------------------------------------------------------------------------
// 0 · Welcome
// -----------------------------------------------------------------------------

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        KaloriSpacing.containerMargin,
        KaloriSpacing.xl,
        KaloriSpacing.containerMargin,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Semantics(
              label: 'Kalori',
              image: true,
              excludeSemantics: true,
              child: Container(
                decoration: BoxDecoration(
                  color: KaloriColors.surfaceContainerLow,
                  borderRadius: KaloriRadius.borderXl,
                ),
                padding: const EdgeInsets.all(KaloriSpacing.md),
                alignment: Alignment.center,
                child: _WordmarkAnimation(reduceMotion: reduceMotion),
              ),
            ),
          ),
          const SizedBox(height: KaloriSpacing.lg),
          const OnboardingTitle(
            title: 'Track what you eat and build your body.',
            subtitle:
                "Type or speak your meals the way you'd describe them. Kalori works out the calories and macros, including local dishes.",
          ),
        ],
      ),
    );
  }
}

/// Loops `kalori_wordmark.json`. With reduce-motion on it holds the fully drawn
/// frame (ring filled, before the fade-out) instead of the blank first frame.
class _WordmarkAnimation extends StatefulWidget {
  final bool reduceMotion;

  const _WordmarkAnimation({required this.reduceMotion});

  @override
  State<_WordmarkAnimation> createState() => _WordmarkAnimationState();
}

class _WordmarkAnimationState extends State<_WordmarkAnimation> with SingleTickerProviderStateMixin {
  /// Frame 130 of 192: every letter in place and the ring full.
  static const double _settledProgress = 130 / 192;

  late final AnimationController _controller = AnimationController(vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _start() {
    if (widget.reduceMotion) {
      _controller.value = _settledProgress;
    } else {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _WordmarkAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reduceMotion != widget.reduceMotion && _controller.duration != null) {
      _controller.stop();
      _start();
    }
  }

  @override
  Widget build(BuildContext context) {
    // The asset is drawn for light surfaces; recolour the ink letters and the ring track
    // from the active palette so the wordmark reads in dark mode too.
    final ink = KaloriColors.onSurface;
    return Lottie.asset(
      'assets/lottie/kalori_wordmark.json',
      controller: _controller,
      fit: BoxFit.contain,
      delegates: LottieDelegates(
        values: [
          for (final letter in const ['K', 'A', 'L', 'R']) ValueDelegate.strokeColor([letter, '**'], value: ink),
          ValueDelegate.strokeColor(const ['O', 'O track', '**'], value: KaloriColors.surfaceContainerHigh),
        ],
      ),
      onLoaded: (composition) {
        _controller.duration = composition.duration;
        _start();
      },
      errorBuilder: (context, error, stack) => Text(
        'KALORI',
        style: context.typography.displayNum.copyWith(fontWeight: FontWeight.w900),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 1 · About you
// -----------------------------------------------------------------------------

class AboutStep extends GetView<OnboardingController> {
  const AboutStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: _stepPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!controller.isEditing) ...[
            const OnboardingTitle(
              title: 'Tell us about you',
              subtitle: 'We use this to estimate how much energy your body burns each day.',
            ),
            const SizedBox(height: 28.0),
          ],
          const _FieldLabel('What should we call you?'),
          TextField(
            controller: controller.nameController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            style: context.typography.bodyLg.copyWith(color: KaloriColors.onSurface),
            decoration: const InputDecoration(
              hintText: 'Your first name',
              contentPadding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
            ),
          ),
          const SizedBox(height: KaloriSpacing.lg),
          const _FieldLabel('Sex'),
          Obx(
            () => Row(
              children: [
                for (final s in Sex.values) ...[
                  if (s != Sex.values.first) const SizedBox(width: KaloriSpacing.sm),
                  Expanded(
                    child: OnboardingChoiceCard(
                      selected: controller.sex.value == s,
                      onTap: () => controller.sex.value = s,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (controller.sex.value == s) ...[
                            Icon(Icons.check_rounded, size: 18.0, color: KaloriColors.primary),
                            const SizedBox(width: 6.0),
                          ],
                          Text(
                            s == Sex.male ? 'Male' : 'Female',
                            style: context.typography.bodyLg.copyWith(
                              fontWeight: controller.sex.value == s ? FontWeight.w600 : FontWeight.w500,
                              color: controller.sex.value == s ? KaloriColors.primary : KaloriColors.neutralSlate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: KaloriSpacing.xs),
          Text(
            'Only used in the calorie formula. Bodies burn energy a little differently.',
            style: context.typography.bodySm.copyWith(fontSize: 13.0, color: KaloriColors.onSurfaceVariant),
          ),
          const SizedBox(height: KaloriSpacing.lg),
          const _FieldLabel('Age'),
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: KaloriColors.surfaceContainerLowest,
              borderRadius: KaloriRadius.borderXl,
              border: Border.all(color: KaloriColors.borderSlate),
            ),
            child: Obx(
              () => Row(
                children: [
                  _RoundIconButton(
                    icon: Icons.remove_rounded,
                    tooltip: 'Decrease age',
                    onPressed: controller.age.value > OnboardingController.minAge
                        ? () => controller.changeAge(-1)
                        : null,
                  ),
                  Expanded(
                    child: Semantics(
                      label: 'Age ${controller.age.value} years',
                      excludeSemantics: true,
                      child: Text.rich(
                        TextSpan(
                          text: '${controller.age.value}',
                          style: context.typography.headlineLg.copyWith(fontSize: 32.0),
                          children: [TextSpan(text: '  years', style: context.typography.bodyLg)],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  _RoundIconButton(
                    icon: Icons.add_rounded,
                    tooltip: 'Increase age',
                    onPressed: controller.age.value < OnboardingController.maxAge
                        ? () => controller.changeAge(1)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2 · Your body
// -----------------------------------------------------------------------------

class BodyStep extends GetView<OnboardingController> {
  const BodyStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: _stepPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!controller.isEditing) ...[
            const OnboardingTitle(
              title: 'Your height and weight',
              subtitle: 'A rough number is fine. You can update your weight any time from Profile.',
            ),
            const SizedBox(height: KaloriSpacing.lg),
          ],
          Obx(
            () => _MeasureCard(
              label: 'HEIGHT',
              toggle: OnboardingUnitToggle(
                labels: const ['cm', 'ft / in'],
                selectedIndex: controller.heightInFeet.value ? 1 : 0,
                onChanged: (i) => controller.heightInFeet.value = i == 1,
                semanticLabel: 'Height unit',
              ),
              value: controller.formatHeightValue(controller.heightCm.value),
              unit: controller.heightInFeet.value ? '' : 'cm',
              ruler: RulerPicker(
                value: controller.heightCm.value,
                min: OnboardingController.minHeightCm,
                max: OnboardingController.maxHeightCm,
                step: 1,
                onChanged: controller.setHeight,
                semanticLabel: 'Height',
                semanticValue: (v) => controller.heightInFeet.value
                    ? controller.formatHeightValue(v)
                    : '${v.round()} centimetres',
              ),
            ),
          ),
          const SizedBox(height: KaloriSpacing.md),
          Obx(
            () => _MeasureCard(
              label: 'CURRENT WEIGHT',
              toggle: OnboardingUnitToggle(
                labels: const ['kg', 'lb'],
                selectedIndex: controller.weightInLb.value ? 1 : 0,
                onChanged: (i) => controller.setWeightInLb(i == 1),
                semanticLabel: 'Weight unit',
              ),
              value: controller.formatWeight(controller.weightKg.value).split(' ').first,
              unit: controller.weightInLb.value ? 'lb' : 'kg',
              ruler: RulerPicker(
                value: controller.weightKg.value,
                min: OnboardingController.minWeightKg,
                max: OnboardingController.maxWeightKg,
                step: 0.5,
                onChanged: controller.setWeight,
                semanticLabel: 'Weight',
                semanticValue: controller.formatWeight,
              ),
            ),
          ),
          const SizedBox(height: KaloriSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lock_outline_rounded, size: 16.0, color: KaloriColors.onSurfaceVariant),
              const SizedBox(width: KaloriSpacing.xs),
              Expanded(
                child: Text(
                  'Stored only on this phone. Never shared.',
                  style: context.typography.bodySm.copyWith(fontSize: 13.0, color: KaloriColors.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MeasureCard extends StatelessWidget {
  final String label;
  final Widget toggle;
  final String value;
  final String unit;
  final Widget ruler;

  const _MeasureCard({
    required this.label,
    required this.toggle,
    required this.value,
    required this.unit,
    required this.ruler,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(KaloriSpacing.containerMargin, 16.0, KaloriSpacing.containerMargin, 20.0),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label, style: context.typography.labelCaps.copyWith(color: KaloriColors.onSurfaceVariant)),
              ),
              toggle,
            ],
          ),
          const SizedBox(height: KaloriSpacing.xs),
          ExcludeSemantics(
            child: Text.rich(
              TextSpan(
                text: value,
                style: context.typography.displayNum,
                children: [if (unit.isNotEmpty) TextSpan(text: ' $unit', style: context.typography.bodyLg)],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: KaloriSpacing.xs),
          ruler,
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3 · Activity
// -----------------------------------------------------------------------------

class ActivityStep extends GetView<OnboardingController> {
  const ActivityStep({super.key});

  static const Map<ActivityLevel, IconData> _icons = {
    ActivityLevel.sedentary: Icons.desktop_windows_outlined,
    ActivityLevel.light: Icons.directions_walk_rounded,
    ActivityLevel.moderate: Icons.directions_run_rounded,
    ActivityLevel.veryActive: Icons.local_fire_department_outlined,
    ActivityLevel.athlete: Icons.emoji_events_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: _stepPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!controller.isEditing) ...[
            const OnboardingTitle(
              title: 'How active are you?',
              subtitle: 'Think about a normal week, not your best one.',
            ),
            const SizedBox(height: KaloriSpacing.containerMargin),
          ],
          Obx(
            () => Column(
              children: [
                for (final level in ActivityLevel.values) ...[
                  OnboardingChoiceCard(
                    selected: controller.activity.value == level,
                    onTap: () => controller.activity.value = level,
                    child: Row(
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: controller.activity.value == level
                                ? KaloriColors.primaryContainer
                                : KaloriColors.surfaceContainerLow,
                            borderRadius: KaloriRadius.borderMd,
                          ),
                          child: Icon(
                            _icons[level],
                            size: 20.0,
                            color: controller.activity.value == level
                                ? KaloriColors.onPrimaryContainer
                                : KaloriColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: KaloriSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                level.label,
                                style: context.typography.bodyLg.copyWith(
                                  fontWeight: controller.activity.value == level ? FontWeight.w700 : FontWeight.w600,
                                  color: KaloriColors.onSurface,
                                ),
                              ),
                              Text(
                                level.description,
                                style: context.typography.bodySm.copyWith(
                                  fontSize: 13.0,
                                  color: KaloriColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: KaloriSpacing.xs),
                        OnboardingRadioDot(selected: controller.activity.value == level),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 4 · Goal
// -----------------------------------------------------------------------------

class GoalStep extends GetView<OnboardingController> {
  const GoalStep({super.key});

  /// A getter (not a stored field) so the colours follow the active palette.
  static Map<GoalType, (IconData, Color)> get _goalIcons => {
    GoalType.lose: (Icons.trending_down_rounded, KaloriColors.primary),
    GoalType.maintain: (Icons.swap_horiz_rounded, KaloriColors.tertiary),
    GoalType.gain: (Icons.trending_up_rounded, KaloriColors.secondary),
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: _stepPadding,
      child: Obx(() {
        final goal = controller.goal.value;
        final targets = controller.preview;
        final error = controller.goalError;
        final date = controller.goalDate;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!controller.isEditing) ...[
              const OnboardingTitle(title: "What's your goal?"),
              const SizedBox(height: KaloriSpacing.md),
            ],
            Row(
              children: [
                for (final g in GoalType.values) ...[
                  if (g != GoalType.values.first) const SizedBox(width: 10.0),
                  Expanded(
                    child: OnboardingChoiceCard(
                      selected: goal == g,
                      onTap: () => controller.setGoal(g),
                      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 6.0),
                      child: Column(
                        children: [
                          Icon(_goalIcons[g]!.$1, color: _goalIcons[g]!.$2),
                          const SizedBox(height: 6.0),
                          Text(
                            g.label,
                            textAlign: TextAlign.center,
                            style: context.typography.bodySm.copyWith(
                              fontSize: 15.0,
                              fontWeight: goal == g ? FontWeight.w700 : FontWeight.w500,
                              color: KaloriColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (goal != GoalType.maintain) ...[
              const SizedBox(height: KaloriSpacing.lg),
              const _FieldLabel('Target weight'),
              TextField(
                controller: controller.targetController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: context.typography.bodyLg.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: KaloriColors.onSurface,
                ),
                decoration: InputDecoration(
                  suffixText: controller.weightInLb.value ? 'lb' : 'kg',
                  errorText: error,
                  errorMaxLines: 2,
                  helperText: error == null ? _differenceText() : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                ),
              ),
              const SizedBox(height: KaloriSpacing.lg),
              const _FieldLabel('How fast?'),
              Row(
                children: [
                  for (final p in GoalPace.values) ...[
                    if (p != GoalPace.values.first) const SizedBox(width: KaloriSpacing.xs),
                    Expanded(child: _PaceCard(pace: p, selected: controller.pace.value == p)),
                  ],
                ],
              ),
            ],
            const SizedBox(height: KaloriSpacing.containerMargin),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
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
                    decoration: BoxDecoration(
                      color: KaloriColors.tertiaryFixed,
                      borderRadius: KaloriRadius.borderMd,
                    ),
                    child: Icon(Icons.calendar_today_outlined, size: 20.0, color: KaloriColors.tertiary),
                  ),
                  const SizedBox(width: KaloriSpacing.sm),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'About '),
                          TextSpan(
                            text: '${HistoryFormat.number(targets.calories)} kcal',
                            style: TextStyle(fontWeight: FontWeight.w700, color: KaloriColors.onSurface),
                          ),
                          const TextSpan(text: ' a day. '),
                          if (goal == GoalType.maintain)
                            TextSpan(text: 'Enough to stay at ${controller.formatWeight(controller.weightKg.value)}.')
                          else if (error == null && date != null) ...[
                            TextSpan(text: "You'd reach ${controller.formatWeight(controller.targetWeightKg.value)} around "),
                            TextSpan(
                              text: '${HistoryFormat.shortDate(date)}, ${date.year}',
                              style: TextStyle(fontWeight: FontWeight.w700, color: KaloriColors.onSurface),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ],
                      ),
                      style: context.typography.bodySm,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  String _differenceText() {
    final diff = (controller.weightKg.value - controller.targetWeightKg.value).abs();
    final direction = controller.goal.value == GoalType.lose ? 'below' : 'above';
    return '${controller.formatWeight(diff)} $direction your current ${controller.formatWeight(controller.weightKg.value)}.';
  }
}

class _PaceCard extends GetView<OnboardingController> {
  final GoalPace pace;
  final bool selected;

  const _PaceCard({required this.pace, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        OnboardingChoiceCard(
          selected: selected,
          onTap: () => controller.pace.value = pace,
          borderRadius: BorderRadius.circular(14.0),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  pace.label,
                  style: context.typography.bodySm.copyWith(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: KaloriColors.onSurface,
                  ),
                ),
                Text(
                  '${controller.formatPace(pace.kgPerWeek)} / wk',
                  style: context.typography.bodySm.copyWith(fontSize: 12.0, color: KaloriColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
        if (pace == GoalPace.steady)
          Positioned(
            top: -9.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
              decoration: BoxDecoration(color: KaloriColors.primary, borderRadius: KaloriRadius.borderFull),
              child: Text(
                'SUGGESTED',
                style: context.typography.labelCaps.copyWith(
                  fontSize: 10.0,
                  height: 14.0 / 10.0,
                  letterSpacing: 0.5,
                  color: KaloriColors.onPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 5 · Your plan
// -----------------------------------------------------------------------------

class PlanStep extends GetView<OnboardingController> {
  const PlanStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: _stepPadding.copyWith(top: KaloriSpacing.xs),
      child: Obx(() {
        final draft = controller.draft;
        final t = controller.preview;
        final date = controller.goalDate;
        final adjustmentLabel = switch (draft.goal) {
          GoalType.lose => '− To lose ${controller.formatPace(draft.pace.kgPerWeek)} a week',
          GoalType.gain => '+ To gain ${controller.formatPace(draft.pace.kgPerWeek)} a week',
          GoalType.maintain => 'To maintain your weight',
        };
        final total = t.protein * 4 + t.carbs * 4 + t.fat * 9;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OnboardingTitle(eyebrow: 'YOUR PLAN IS READY', title: "Here's your daily target, ${draft.firstName}"),
            const SizedBox(height: KaloriSpacing.containerMargin),
            Container(
              padding: const EdgeInsets.all(KaloriSpacing.containerMargin),
              decoration: _cardDecoration(),
              child: Row(
                children: [
                  Semantics(
                    label: '${HistoryFormat.number(t.calories)} kilocalories a day',
                    excludeSemantics: true,
                    child: SizedBox(
                      width: 132.0,
                      height: 132.0,
                      child: CustomPaint(
                        painter: _MacroRingPainter(
                          fractions: total == 0
                              ? const [0, 0, 0]
                              : [t.protein * 4 / total, t.carbs * 4 / total, t.fat * 9 / total],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                HistoryFormat.number(t.calories),
                                style: context.typography.headlineLg.copyWith(height: 36.0 / 30.0),
                              ),
                              Text('kcal / day', style: context.typography.bodySm.copyWith(fontSize: 13.0)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: KaloriSpacing.containerMargin),
                  Expanded(
                    child: Column(
                      children: [
                        _MacroRow(color: KaloriColors.primary, label: 'PROTEIN', grams: t.protein),
                        const SizedBox(height: KaloriSpacing.sm),
                        _MacroRow(color: KaloriColors.tertiary, label: 'CARBS', grams: t.carbs),
                        const SizedBox(height: KaloriSpacing.sm),
                        _MacroRow(color: KaloriColors.secondary, label: 'FAT', grams: t.fat),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: KaloriSpacing.md),
            Container(
              padding: const EdgeInsets.fromLTRB(KaloriSpacing.containerMargin, 16.0, KaloriSpacing.containerMargin, 16.0),
              decoration: BoxDecoration(
                color: KaloriColors.surfaceContainerLowest,
                borderRadius: KaloriRadius.borderLg,
                border: Border.all(color: KaloriColors.borderSlate),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'HOW WE WORKED IT OUT',
                    style: context.typography.labelCaps.copyWith(color: KaloriColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: KaloriSpacing.xs),
                  _SumRow(label: 'Your body at rest', value: '${HistoryFormat.number(t.bmr)} kcal'),
                  _SumRow(
                    label: '× ${draft.activity.label} (${draft.activity.multiplier})',
                    value: '${HistoryFormat.number(t.tdee)} kcal',
                  ),
                  _SumRow(
                    label: adjustmentLabel,
                    value: t.adjustment == 0
                        ? '0 kcal'
                        : '${t.adjustment > 0 ? '+' : '−'}${HistoryFormat.number(t.adjustment.abs())} kcal',
                    valueColor: t.adjustment < 0 ? KaloriColors.error : null,
                  ),
                  if (t.floorApplied)
                    const _SumRow(label: 'Raised to the safe minimum', value: ''),
                  Divider(color: KaloriColors.borderSlate, height: 16.0),
                  _SumRow(
                    label: 'Daily target',
                    value: '${HistoryFormat.number(t.calories)} kcal',
                    bold: true,
                    valueColor: KaloriColors.primary,
                  ),
                ],
              ),
            ),
            if (draft.goal != GoalType.maintain && date != null) ...[
              const SizedBox(height: KaloriSpacing.md),
              _Timeline(
                from: controller.formatWeight(draft.weightKg),
                to: controller.formatWeight(draft.targetWeightKg),
                weeks: t.weeksToGoal ?? 0,
                date: date,
              ),
            ],
            const SizedBox(height: KaloriSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, size: 16.0, color: KaloriColors.onSurfaceVariant),
                const SizedBox(width: KaloriSpacing.xs),
                Expanded(
                  child: Text(
                    'Estimates, not medical advice. We never set a target below 1,500 kcal for men or 1,200 kcal for women.',
                    style: context.typography.bodySm.copyWith(fontSize: 13.0, color: KaloriColors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _MacroRow extends StatelessWidget {
  final Color color;
  final String label;
  final int grams;

  const _MacroRow({required this.color, required this.label, required this.grams});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3.0)),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(label, style: context.typography.labelCaps.copyWith(color: KaloriColors.onSurfaceVariant)),
        ),
        Text('${grams}g', style: context.typography.bodyLg.copyWith(fontWeight: FontWeight.w700, color: KaloriColors.onSurface)),
      ],
    );
  }
}

class _SumRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  const _SumRow({required this.label, required this.value, this.bold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.typography.bodySm.copyWith(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                color: bold ? KaloriColors.onSurface : KaloriColors.neutralSlate,
              ),
            ),
          ),
          Text(
            value,
            style: context.typography.bodySm.copyWith(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              color: valueColor ?? KaloriColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  final String from;
  final String to;
  final int weeks;
  final DateTime date;

  const _Timeline({required this.from, required this.to, required this.weeks, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(KaloriSpacing.containerMargin, 16.0, KaloriSpacing.containerMargin, 16.0),
      decoration: BoxDecoration(color: KaloriColors.surfaceContainerLow, borderRadius: KaloriRadius.borderLg),
      child: Column(
        children: [
          Row(
            children: [
              Text(from, style: context.typography.bodyLg.copyWith(fontWeight: FontWeight.w700, color: KaloriColors.onSurface)),
              Expanded(
                child: Text(
                  'about $weeks ${weeks == 1 ? 'week' : 'weeks'}',
                  textAlign: TextAlign.center,
                  style: context.typography.bodySm.copyWith(fontSize: 13.0, color: KaloriColors.onSurfaceVariant),
                ),
              ),
              Text(to, style: context.typography.bodyLg.copyWith(fontWeight: FontWeight.w700, color: KaloriColors.primary)),
            ],
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 12.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 6.0,
                  decoration: BoxDecoration(
                    color: KaloriColors.surfaceContainerHigh,
                    borderRadius: KaloriRadius.borderFull,
                  ),
                ),
                Align(alignment: Alignment.centerLeft, child: _Dot(color: KaloriColors.onSurface)),
                Align(alignment: Alignment.centerRight, child: _Dot(color: KaloriColors.successGreen)),
              ],
            ),
          ),
          const SizedBox(height: KaloriSpacing.xs),
          Row(
            children: [
              Text('Today', style: context.typography.bodySm.copyWith(fontSize: 12.0, color: KaloriColors.onSurfaceVariant)),
              const Spacer(),
              Text(
                'Around ${HistoryFormat.shortDate(date)}, ${date.year}',
                style: context.typography.bodySm.copyWith(fontSize: 12.0, color: KaloriColors.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;

  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(width: 12.0, height: 12.0, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}

/// Three arcs (protein, carbs, fat) proportional to their share of calories.
class _MacroRingPainter extends CustomPainter {
  final List<double> fractions;

  const _MacroRingPainter({required this.fractions});

  static final List<Color> _colors = [KaloriColors.primary, KaloriColors.tertiary, KaloriColors.secondary];

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 12.0;
    final rect = Rect.fromLTWH(stroke / 2, stroke / 2, size.width - stroke, size.height - stroke);
    const gap = 0.04;
    var start = -math.pi / 2;
    for (var i = 0; i < fractions.length; i++) {
      final sweep = fractions[i] * 2 * math.pi;
      if (sweep > gap) {
        final paint = Paint()
          ..color = _colors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke;
        canvas.drawArc(rect, start, sweep - gap, false, paint);
      }
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _MacroRingPainter old) => old.fractions != fractions;
}

// -----------------------------------------------------------------------------
// Small shared bits
// -----------------------------------------------------------------------------

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: KaloriSpacing.xs),
      child: Text(
        text,
        style: context.typography.bodySm.copyWith(fontWeight: FontWeight.w600, color: KaloriColors.onSurface),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const _RoundIconButton({required this.icon, required this.tooltip, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: KaloriColors.surfaceContainerLow,
        fixedSize: const Size(44.0, 44.0),
      ),
      icon: Icon(icon, color: onPressed == null ? KaloriColors.outlineVariant : KaloriColors.onSurface),
    );
  }
}
