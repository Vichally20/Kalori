import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Data class representing a macronutrient or secondary metric inside [GenericCalorieRingWidget].
class MacroData {
  final String label;
  final String valueText;
  final double progress;
  final Color color;
  final Color trackColor;

  const MacroData({
    required this.label,
    required this.valueText,
    required this.progress,
    required this.color,
    required this.trackColor,
  });
}

/// A generic, highly customizable circular calorie & progress tracker ring
/// (`GenericCalorieRingWidget`) that can be reused across any feature or screen in Kalori.
///
/// Can be used either with custom generic properties ([centerValue], [macros], etc.)
/// or convenient standard daily nutrition properties ([remainingCalories], [carbsCurrent], etc.).
class GenericCalorieRingWidget extends StatelessWidget {
  /// Fractional progress between `0.0` and `1.0` (or higher if over goal).
  final double progressPercent;

  /// Optional convenience parameter for remaining daily calories.
  /// If provided alongside null [centerValue], it formats to e.g. `'1,250'`.
  final int? remainingCalories;

  /// Optional convenience parameter for current carbs in grams.
  final int? carbsCurrent;

  /// Optional convenience parameter for current protein in grams.
  final int? proteinCurrent;

  /// Optional convenience parameter for current fat in grams.
  final int? fatCurrent;

  /// Main central value text override (e.g. `'1,250'`). If null, falls back to [remainingCalories].
  final String? centerValue;

  /// Top label text inside the ring (e.g. `'REMAINING'`, `'CONSUMED'`). Defaults to `'REMAINING'`.
  final String? centerLabel;

  /// Bottom unit text inside the ring (e.g. `'kcal'`, `'g'`). Defaults to `'kcal'`.
  final String? centerUnit;

  /// Custom widget to display inside the ring instead of the default label+value+unit texts.
  final Widget? centerChild;

  /// Whether to show the bottom status badge hovering over the ring arc.
  final bool showBadge;

  /// Text for the bottom status badge (e.g. `'ON TRACK'`, `'EXCEEDED'`).
  final String? badgeText;

  /// Icon for the status badge.
  final IconData? badgeIcon;

  /// Background color of the status badge.
  final Color? badgeBgColor;

  /// Text and icon color inside the status badge.
  final Color? badgeTextColor;

  /// Custom widget for the status badge, overriding default badge builder.
  final Widget? customBadge;

  /// Optional list of macros or metrics (`CARBS`, `PROTEIN`, `FAT`, etc.) to display
  /// below the ring inside the card. If null, attempts to build default macros from
  /// [carbsCurrent], [proteinCurrent], and [fatCurrent].
  final List<MacroData>? macros;

  /// Color of the progress arc. Defaults to [KaloriColors.successGreen].
  final Color? progressColor;

  /// Color of the background circle track. Defaults to [KaloriColors.surfaceContainer].
  final Color? trackColor;

  /// Overall bounding size (width and height) of the circular ring area.
  final double ringSize;

  /// Stroke width of the ring track and progress arc.
  final double strokeWidth;

  /// Whether to wrap the ring inside a standard Level 1 white card with shadow.
  final bool showCardDecoration;

  /// Custom internal padding when [showCardDecoration] is true.
  final EdgeInsetsGeometry? cardPadding;

  const GenericCalorieRingWidget({
    super.key,
    required this.progressPercent,
    this.remainingCalories,
    this.carbsCurrent,
    this.proteinCurrent,
    this.fatCurrent,
    this.centerValue,
    this.centerLabel = 'REMAINING',
    this.centerUnit = 'kcal',
    this.centerChild,
    this.showBadge = true,
    this.badgeText = 'ON TRACK',
    this.badgeIcon = Icons.check_circle_outline,
    this.badgeBgColor,
    this.badgeTextColor,
    this.customBadge,
    this.macros,
    this.progressColor,
    this.trackColor,
    this.ringSize = 230.0,
    this.strokeWidth = 20.0,
    this.showCardDecoration = true,
    this.cardPadding,
  });

  @override
  Widget build(BuildContext context) {
    // Resolve macro list either from override [macros] or from convenience parameters
    final List<MacroData> resolvedMacros = macros ?? _resolveConvenienceMacros();

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular Progress Ring & Center Content
        SizedBox(
          width: ringSize,
          height: ringSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Custom Ring Painter
              SizedBox(
                width: ringSize - strokeWidth,
                height: ringSize - strokeWidth,
                child: CustomPaint(
                  painter: _CalorieRingPainter(
                    progress: progressPercent,
                    trackColor: trackColor ?? KaloriColors.surfaceContainer,
                    progressColor: progressColor ?? KaloriColors.successGreen,
                    strokeWidth: strokeWidth,
                  ),
                ),
              ),
              // Center Content Breakdown
              centerChild ?? _buildDefaultCenter(context),
              // Status Badge
              if (showBadge && (customBadge != null || badgeText != null))
                Positioned(
                  bottom: 6,
                  child: customBadge ?? _buildDefaultBadge(context),
                ),
            ],
          ),
        ),

        // Optional Macros / Secondary Metrics Breakdown
        if (resolvedMacros.isNotEmpty) ...[
          const SizedBox(height: KaloriSpacing.lg),
          const Divider(color: KaloriColors.borderSlate, height: 1.0),
          const SizedBox(height: KaloriSpacing.md),
          Row(
            children: resolvedMacros.asMap().entries.map((entry) {
              final int idx = entry.key;
              final MacroData data = entry.value;
              return Expanded(
                child: Row(
                  children: [
                    if (idx > 0) const SizedBox(width: KaloriSpacing.md),
                    Expanded(child: _buildMacroColumn(context, data)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );

    if (!showCardDecoration) {
      return content;
    }

    return Container(
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(KaloriRadius.lg),
        border: Border.all(color: KaloriColors.borderSlate, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: KaloriColors.cardShadow,
            blurRadius: 20.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: cardPadding ??
          const EdgeInsets.only(
            top: KaloriSpacing.lg,
            left: KaloriSpacing.lg,
            right: KaloriSpacing.lg,
            bottom: KaloriSpacing.md,
          ),
      child: content,
    );
  }

  List<MacroData> _resolveConvenienceMacros() {
    if (carbsCurrent == null && proteinCurrent == null && fatCurrent == null) {
      return const [];
    }
    final int carbs = carbsCurrent ?? 0;
    final int protein = proteinCurrent ?? 0;
    final int fat = fatCurrent ?? 0;

    return [
      MacroData(
        label: 'CARBS',
        valueText: '${carbs}g',
        progress: carbs / 200.0,
        color: KaloriColors.tertiary,
        trackColor: KaloriColors.surfaceContainerHigh,
      ),
      MacroData(
        label: 'PROTEIN',
        valueText: '${protein}g',
        progress: protein / 180.0,
        color: KaloriColors.primary,
        trackColor: KaloriColors.surfaceContainerHighest,
      ),
      MacroData(
        label: 'FAT',
        valueText: '${fat}g',
        progress: fat / 70.0,
        color: KaloriColors.secondary,
        trackColor: KaloriColors.secondaryFixed,
      ),
    ];
  }

  Widget _buildDefaultCenter(BuildContext context) {
    final String valueText = centerValue ??
        (remainingCalories != null ? _formatNumber(remainingCalories!) : '0');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (centerLabel != null && centerLabel!.isNotEmpty) ...[
          Text(
            centerLabel!,
            style: context.typography.labelCaps.copyWith(
              color: KaloriColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Text(
          valueText,
          style: context.typography.displayNum,
        ),
        if (centerUnit != null && centerUnit!.isNotEmpty) ...[
          Text(
            centerUnit!,
            style: context.typography.bodySm.copyWith(
              color: KaloriColors.neutralSlate,
            ),
          ),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDefaultBadge(BuildContext context) {
    final Color bg = badgeBgColor ?? KaloriColors.successGreen;
    final Color fg = badgeTextColor ?? KaloriColors.onPrimaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14.0,
        vertical: 6.0,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(KaloriRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badgeIcon != null) ...[
            Icon(
              badgeIcon,
              size: 16.0,
              color: fg,
            ),
            const SizedBox(width: 4),
          ],
          if (badgeText != null)
            Text(
              badgeText!,
              style: context.typography.labelCaps.copyWith(
                color: fg,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMacroColumn(BuildContext context, MacroData data) {
    return Column(
      children: [
        Text(
          data.label,
          style: context.typography.labelCaps.copyWith(
            color: KaloriColors.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(KaloriRadius.full),
          child: LinearProgressIndicator(
            value: data.progress.clamp(0.0, 1.0),
            minHeight: 6.0,
            backgroundColor: data.trackColor,
            valueColor: AlwaysStoppedAnimation<Color>(data.color),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.valueText,
          style: context.typography.bodyLg.copyWith(
            fontWeight: FontWeight.w700,
            color: KaloriColors.onSurface,
          ),
        ),
      ],
    );
  }

  String _formatNumber(int value) {
    if (value >= 1000) {
      final String str = value.toString();
      return '${str.substring(0, str.length - 3)},${str.substring(str.length - 3)}';
    }
    return value.toString();
  }
}

class _CalorieRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  _CalorieRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track Paint
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Progress Paint
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw full track circle
    canvas.drawCircle(center, radius, trackPaint);

    // Draw progress arc starting from top center (-pi / 2)
    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CalorieRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
