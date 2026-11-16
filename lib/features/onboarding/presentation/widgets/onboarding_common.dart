import 'package:flutter/material.dart';
import 'package:kalori/core/theme/app_theme.dart';

/// Back arrow, 4-segment progress bar and `N OF 4`.
class OnboardingStepHeader extends StatelessWidget {
  final int current;
  final int total;
  final VoidCallback onBack;

  const OnboardingStepHeader({
    super.key,
    required this.current,
    required this.onBack,
    this.total = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.0,
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: onBack,
            icon: Icon(Icons.arrow_back_rounded, color: KaloriColors.onSurface),
          ),
          const SizedBox(width: 4.0),
          Expanded(
            child: Semantics(
              label: 'Step $current of $total',
              excludeSemantics: true,
              child: Row(
                children: [
                  for (var i = 1; i <= total; i++) ...[
                    if (i > 1) const SizedBox(width: 6.0),
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 6.0,
                        decoration: BoxDecoration(
                          color: i <= current
                              ? KaloriColors.successGreen
                              : KaloriColors.surfaceContainerHigh,
                          borderRadius: KaloriRadius.borderFull,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: KaloriSpacing.sm),
          ExcludeSemantics(
            child: Text(
              '$current OF $total',
              style: context.typography.labelCaps.copyWith(color: KaloriColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

/// Title + optional subtitle at the top of a step.
class OnboardingTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? eyebrow;

  const OnboardingTitle({super.key, required this.title, this.subtitle, this.eyebrow});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[
          Text(eyebrow!, style: context.typography.labelCaps.copyWith(color: KaloriColors.primary)),
          const SizedBox(height: 6.0),
        ],
        Semantics(
          header: true,
          child: Text(title, style: context.typography.headlineLg),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: KaloriSpacing.xs),
          Text(subtitle!, style: context.typography.bodyLg),
        ],
      ],
    );
  }
}

/// Selectable card used for sex, activity, goal and pace choices.
class OnboardingChoiceCard extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  const OnboardingChoiceCard({
    super.key,
    required this.selected,
    required this.onTap,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 14.0, vertical: KaloriSpacing.sm),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? KaloriRadius.borderLg;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: selected ? KaloriColors.successTint : KaloriColors.surfaceContainerLowest,
          borderRadius: radius,
          border: Border.all(
            color: selected ? KaloriColors.primary : KaloriColors.borderSlate,
            width: selected ? 1.5 : 1.0,
          ),
          boxShadow: selected
              ? [BoxShadow(color: KaloriColors.primary.withValues(alpha: 0.1), blurRadius: 12.0, offset: const Offset(0, 4))]
              : const [],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

/// Filled radio dot shown at the end of a choice card.
class OnboardingRadioDot extends StatelessWidget {
  final bool selected;

  const OnboardingRadioDot({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22.0,
      height: 22.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: KaloriColors.surfaceContainerLowest,
        border: Border.all(
          color: selected ? KaloriColors.primary : KaloriColors.outlineVariant,
          width: selected ? 6.0 : 2.0,
        ),
      ),
    );
  }
}

/// Small pill toggle such as `cm | ft / in`.
class OnboardingUnitToggle extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final String semanticLabel;

  const OnboardingUnitToggle({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: KaloriColors.surfaceContainerHigh,
          borderRadius: KaloriRadius.borderFull,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < labels.length; i++)
              Semantics(
                button: true,
                selected: i == selectedIndex,
                child: GestureDetector(
                  onTap: () => onChanged(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 30.0,
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == selectedIndex ? KaloriColors.surfaceContainerLowest : Colors.transparent,
                      borderRadius: KaloriRadius.borderFull,
                    ),
                    child: Text(
                      labels[i],
                      style: context.typography.bodySm.copyWith(
                        fontSize: 13.0,
                        fontWeight: i == selectedIndex ? FontWeight.w600 : FontWeight.w500,
                        color: i == selectedIndex ? KaloriColors.onSurface : KaloriColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal ruler: drag left/right to change the value in [step] increments.
class RulerPicker extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final double step;

  /// Every Nth tick is drawn taller.
  final int majorEvery;

  final ValueChanged<double> onChanged;
  final String semanticLabel;
  final String Function(double) semanticValue;

  const RulerPicker({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged,
    required this.semanticLabel,
    required this.semanticValue,
    this.majorEvery = 10,
  });

  @override
  State<RulerPicker> createState() => _RulerPickerState();
}

class _RulerPickerState extends State<RulerPicker> {
  static const double _pxPerStep = 10.0;
  double _carry = 0;

  double _clampSnap(double v) {
    final snapped = (v / widget.step).round() * widget.step;
    return snapped.clamp(widget.min, widget.max);
  }

  void _onDrag(DragUpdateDetails d) {
    _carry -= d.delta.dx;
    final steps = (_carry / _pxPerStep).truncate();
    if (steps != 0) {
      _carry -= steps * _pxPerStep;
      final next = _clampSnap(widget.value + steps * widget.step);
      if (next != widget.value) {
        widget.onChanged(next);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final up = _clampSnap(widget.value + widget.step);
    final down = _clampSnap(widget.value - widget.step);
    return Semantics(
      slider: true,
      label: widget.semanticLabel,
      value: widget.semanticValue(widget.value),
      increasedValue: widget.semanticValue(up),
      decreasedValue: widget.semanticValue(down),
      onIncrease: () => widget.onChanged(up),
      onDecrease: () => widget.onChanged(down),
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onHorizontalDragStart: (_) => _carry = 0,
        onHorizontalDragUpdate: _onDrag,
        child: ClipRRect(
          borderRadius: KaloriRadius.borderMd,
          child: Container(
            height: 44.0,
            color: KaloriColors.surfaceContainerLow,
            child: CustomPaint(
              size: Size.infinite,
              painter: _RulerPainter(
                value: widget.value,
                min: widget.min,
                max: widget.max,
                step: widget.step,
                majorEvery: widget.majorEvery,
                pxPerStep: _pxPerStep,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  final double value;
  final double min;
  final double max;
  final double step;
  final int majorEvery;
  final double pxPerStep;

  const _RulerPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.majorEvery,
    required this.pxPerStep,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final valueIndex = (value - min) / step;
    final half = (size.width / 2 / pxPerStep).ceil() + 1;
    final first = (valueIndex - half).floor();
    final last = (valueIndex + half).ceil();
    final maxIndex = ((max - min) / step).round();

    final minor = Paint()
      ..color = KaloriColors.outlineVariant
      ..strokeWidth = 1.5;
    final major = Paint()
      ..color = KaloriColors.outline
      ..strokeWidth = 2.0;

    for (var i = first; i <= last; i++) {
      if (i < 0 || i > maxIndex) {
        continue;
      }
      final x = cx + (i - valueIndex) * pxPerStep;
      final isMajor = i % majorEvery == 0;
      final h = isMajor ? 22.0 : 12.0;
      canvas.drawLine(Offset(x, size.height), Offset(x, size.height - h), isMajor ? major : minor);
    }

    final indicator = Paint()
      ..color = KaloriColors.successGreen
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, 6.0), Offset(cx, size.height), indicator);
  }

  @override
  bool shouldRepaint(covariant _RulerPainter old) => old.value != value || old.step != step;
}
