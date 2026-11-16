import 'package:flutter/material.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/history/domain/entities/day_summary.dart';

/// Colors and labels for a [DayStatus] (DESIGN.md §2.5).
class DayStatusStyle {
  final String label;

  /// Chart bar / progress bar color.
  final Color fill;

  final Color badgeBg;
  final Color badgeFg;

  /// Calendar day circle.
  final Color cellBg;
  final Color cellFg;

  final IconData? icon;

  const DayStatusStyle({
    required this.label,
    required this.fill,
    required this.badgeBg,
    required this.badgeFg,
    required this.cellBg,
    required this.cellFg,
    this.icon,
  });

  static DayStatusStyle of(DayStatus status) {
    return switch (status) {
      DayStatus.onTrack => DayStatusStyle(
          label: 'ON TRACK',
          fill: KaloriColors.successGreen,
          badgeBg: KaloriColors.primaryContainer,
          badgeFg: KaloriColors.onPrimaryContainer,
          cellBg: KaloriColors.successGreen,
          cellFg: KaloriColors.onPrimaryContainer,
          icon: Icons.check_circle_outline,
        ),
      DayStatus.close => DayStatusStyle(
          label: 'CLOSE',
          fill: KaloriColors.warningOrange,
          badgeBg: KaloriColors.secondaryContainer,
          badgeFg: KaloriColors.onSecondaryContainer,
          cellBg: KaloriColors.secondaryContainer,
          cellFg: KaloriColors.onSecondaryContainer,
          icon: Icons.warning_amber_rounded,
        ),
      DayStatus.over => DayStatusStyle(
          label: 'OVER',
          fill: KaloriColors.error,
          badgeBg: KaloriColors.errorContainer,
          badgeFg: KaloriColors.onErrorContainer,
          cellBg: KaloriColors.errorContainer,
          cellFg: KaloriColors.onErrorContainer,
          icon: Icons.error_outline_rounded,
        ),
      DayStatus.missed => DayStatusStyle(
          label: 'MISSED',
          fill: KaloriColors.surfaceContainerHigh,
          badgeBg: KaloriColors.surfaceContainerHigh,
          badgeFg: KaloriColors.onSurfaceVariant,
          cellBg: Colors.transparent,
          cellFg: KaloriColors.outline,
        ),
      DayStatus.inProgress => DayStatusStyle(
          label: 'IN PROGRESS',
          fill: KaloriColors.successGreen,
          badgeBg: KaloriColors.successTint,
          badgeFg: KaloriColors.primary,
          cellBg: KaloriColors.successTint,
          cellFg: KaloriColors.onSurface,
          icon: Icons.schedule_rounded,
        ),
      DayStatus.future => DayStatusStyle(
          label: '',
          fill: KaloriColors.surfaceContainer,
          badgeBg: Colors.transparent,
          badgeFg: KaloriColors.outline,
          cellBg: Colors.transparent,
          cellFg: KaloriColors.outline,
        ),
    };
  }
}
