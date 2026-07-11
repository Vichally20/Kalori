import 'package:flutter/material.dart';

/// Spacing and padding constants defined in the `spacing` section of [DESIGN.md].
class KaloriSpacing {
  KaloriSpacing._();

  static const double base = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double containerMargin = 20.0;
  static const double gutter = 12.0;
}

/// Corner radius constants (`rounded`) defined in [DESIGN.md].
class KaloriRadius {
  KaloriRadius._();

  /// `sm: 0.25rem` -> 4px
  static const double sm = 4.0;

  /// `DEFAULT: 0.5rem` -> 8px
  static const double defaultRadius = 8.0;

  /// `md: 0.75rem` -> 12px
  static const double md = 12.0;

  /// `lg: 1rem` -> 16px (Primary Cards container setting)
  static const double lg = 16.0;

  /// `xl: 1.5rem` -> 24px (Primary buttons/Search inputs)
  static const double xl = 24.0;

  /// `full: 9999px` -> Pill-shapes / end-caps
  static const double full = 9999.0;

  // Convenient BorderRadius getters
  static final BorderRadius borderSm = BorderRadius.circular(sm);
  static final BorderRadius borderDefault = BorderRadius.circular(defaultRadius);
  static final BorderRadius borderMd = BorderRadius.circular(md);
  static final BorderRadius borderLg = BorderRadius.circular(lg);
  static final BorderRadius borderXl = BorderRadius.circular(xl);
  static final BorderRadius borderFull = BorderRadius.circular(full);
}

/// [ThemeExtension] for spacing and border radii to allow context-based theme access.
class KaloriSpacingExtension extends ThemeExtension<KaloriSpacingExtension> {
  // Spacing
  final double base;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double containerMargin;
  final double gutter;

  // Radii
  final double radiusSm;
  final double radiusDefault;
  final double radiusMd;
  final double radiusLg;
  final double radiusXl;
  final double radiusFull;

  const KaloriSpacingExtension({
    required this.base,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.containerMargin,
    required this.gutter,
    required this.radiusSm,
    required this.radiusDefault,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusXl,
    required this.radiusFull,
  });

  static const KaloriSpacingExtension standard = KaloriSpacingExtension(
    base: KaloriSpacing.base,
    xs: KaloriSpacing.xs,
    sm: KaloriSpacing.sm,
    md: KaloriSpacing.md,
    lg: KaloriSpacing.lg,
    xl: KaloriSpacing.xl,
    containerMargin: KaloriSpacing.containerMargin,
    gutter: KaloriSpacing.gutter,
    radiusSm: KaloriRadius.sm,
    radiusDefault: KaloriRadius.defaultRadius,
    radiusMd: KaloriRadius.md,
    radiusLg: KaloriRadius.lg,
    radiusXl: KaloriRadius.xl,
    radiusFull: KaloriRadius.full,
  );

  @override
  ThemeExtension<KaloriSpacingExtension> copyWith({
    double? base,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? containerMargin,
    double? gutter,
    double? radiusSm,
    double? radiusDefault,
    double? radiusMd,
    double? radiusLg,
    double? radiusXl,
    double? radiusFull,
  }) {
    return KaloriSpacingExtension(
      base: base ?? this.base,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      containerMargin: containerMargin ?? this.containerMargin,
      gutter: gutter ?? this.gutter,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusDefault: radiusDefault ?? this.radiusDefault,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      radiusXl: radiusXl ?? this.radiusXl,
      radiusFull: radiusFull ?? this.radiusFull,
    );
  }

  @override
  ThemeExtension<KaloriSpacingExtension> lerp(
    covariant ThemeExtension<KaloriSpacingExtension>? other,
    double t,
  ) {
    if (other is! KaloriSpacingExtension) {
      return this;
    }
    return KaloriSpacingExtension(
      base: _lerpDouble(base, other.base, t),
      xs: _lerpDouble(xs, other.xs, t),
      sm: _lerpDouble(sm, other.sm, t),
      md: _lerpDouble(md, other.md, t),
      lg: _lerpDouble(lg, other.lg, t),
      xl: _lerpDouble(xl, other.xl, t),
      containerMargin: _lerpDouble(containerMargin, other.containerMargin, t),
      gutter: _lerpDouble(gutter, other.gutter, t),
      radiusSm: _lerpDouble(radiusSm, other.radiusSm, t),
      radiusDefault: _lerpDouble(radiusDefault, other.radiusDefault, t),
      radiusMd: _lerpDouble(radiusMd, other.radiusMd, t),
      radiusLg: _lerpDouble(radiusLg, other.radiusLg, t),
      radiusXl: _lerpDouble(radiusXl, other.radiusXl, t),
      radiusFull: _lerpDouble(radiusFull, other.radiusFull, t),
    );
  }

  double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}
