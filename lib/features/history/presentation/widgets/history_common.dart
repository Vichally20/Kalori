import 'package:flutter/material.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/history/domain/entities/day_summary.dart';
import 'package:kalori/features/history/presentation/controllers/history_controller.dart';
import 'package:kalori/features/history/presentation/utils/day_status_style.dart';

/// Level 1 white card used throughout History.
class HistoryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const HistoryCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(KaloriSpacing.containerMargin),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: KaloriRadius.borderLg,
        border: Border.all(color: KaloriColors.borderSlate),
        boxShadow: const [
          BoxShadow(color: KaloriColors.cardShadow, blurRadius: 20.0, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

/// Small pill showing a day's status (ON TRACK, CLOSE, OVER…).
class DayStatusBadge extends StatelessWidget {
  final DayStatus status;
  final String? label;

  const DayStatusBadge({super.key, required this.status, this.label});

  @override
  Widget build(BuildContext context) {
    final style = DayStatusStyle.of(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(color: style.badgeBg, borderRadius: KaloriRadius.borderFull),
      child: Text(
        label ?? style.label,
        style: context.typography.labelCaps.copyWith(
          fontSize: 10.0,
          height: 14.0 / 10.0,
          letterSpacing: 0.5,
          color: style.badgeFg,
        ),
      ),
    );
  }
}

/// Week / Month segmented control.
class HistoryRangeSwitch extends StatelessWidget {
  final HistoryRange value;
  final ValueChanged<HistoryRange> onChanged;

  const HistoryRangeSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerHigh,
        borderRadius: KaloriRadius.borderFull,
      ),
      child: Row(
        children: [
          _segment(context, HistoryRange.month, 'Month'),
          const SizedBox(width: 4.0),
          _segment(context, HistoryRange.week, 'Week'),
        ],
      ),
    );
  }

  Widget _segment(BuildContext context, HistoryRange range, String label) {
    final selected = value == range;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        child: GestureDetector(
          onTap: () => onChanged(range),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: 36.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? KaloriColors.surfaceContainerLowest : Colors.transparent,
              borderRadius: KaloriRadius.borderFull,
              boxShadow: selected
                  ? const [
                      BoxShadow(color: Color(0x1A334155), blurRadius: 8.0, offset: Offset(0, 2)),
                    ]
                  : const [],
            ),
            child: Text(
              label,
              style: context.typography.bodySm.copyWith(
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? KaloriColors.onSurface : KaloriColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Previous / title / next row used for weeks and months.
class HistoryPeriodStepper extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;
  final String previousLabel;
  final String nextLabel;

  /// Fill of the enabled arrow buttons. Use [KaloriColors.surfaceContainerLow] inside a white card.
  final Color buttonColor;

  const HistoryPeriodStepper({
    super.key,
    required this.title,
    required this.onPrevious,
    required this.onNext,
    required this.previousLabel,
    required this.nextLabel,
    this.subtitle,
    this.buttonColor = KaloriColors.surfaceContainerLowest,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _arrow(Icons.chevron_left_rounded, onPrevious, previousLabel),
        Expanded(
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.typography.bodyLg.copyWith(
                  fontWeight: FontWeight.w600,
                  color: KaloriColors.onSurface,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: context.typography.labelCaps.copyWith(color: KaloriColors.outline),
                ),
            ],
          ),
        ),
        _arrow(Icons.chevron_right_rounded, onNext, nextLabel),
      ],
    );
  }

  Widget _arrow(IconData icon, VoidCallback? onTap, String label) {
    final enabled = onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Material(
        color: enabled ? buttonColor : KaloriColors.surfaceContainerLow,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 44.0,
            height: 44.0,
            child: Icon(
              icon,
              color: enabled ? KaloriColors.onSurface : KaloriColors.outlineVariant,
            ),
          ),
        ),
      ),
    );
  }
}

/// Small white stat tile: LABEL, big value, caption.
class HistoryStatTile extends StatelessWidget {
  final String label;
  final String value;
  final String? suffix;
  final String caption;

  const HistoryStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.caption,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: KaloriSpacing.xs),
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: KaloriRadius.borderLg,
        border: Border.all(color: KaloriColors.borderSlate),
      ),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.typography.labelCaps.copyWith(color: KaloriColors.outline),
          ),
          const SizedBox(height: 4.0),
          Text.rich(
            TextSpan(
              text: value,
              children: [
                if (suffix != null)
                  TextSpan(
                    text: suffix,
                    style: context.typography.bodySm.copyWith(color: KaloriColors.outline),
                  ),
              ],
            ),
            style: context.typography.headlineLgMobile,
          ),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.typography.bodySm.copyWith(fontSize: 12.0, height: 16.0 / 12.0),
          ),
        ],
      ),
    );
  }
}

/// Thin rounded progress bar.
class HistoryProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final Color trackColor;

  const HistoryProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.trackColor = KaloriColors.surfaceContainer,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: KaloriRadius.borderFull,
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: 6.0,
        backgroundColor: trackColor,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
