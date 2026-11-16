import 'package:flutter/material.dart';
import 'package:kalori/core/theme/app_colors.dart';

/// Typography specs from DESIGN.md §3 (Inter).
///
/// Sizes and weights are fixed; colours come from a [KaloriPalette], so each theme
/// (light / dark) gets correctly coloured styles. The static getters use the active
/// palette; widgets normally read the theme's copy via `context.typography`.
class KaloriTypography {
  KaloriTypography._();

  static const String fontFamily = 'Inter';

  /// `display-num` 48/56, 700, -0.02em. The single hero number per screen.
  static TextStyle displayNumFor(KaloriPalette p) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 48.0,
        fontWeight: FontWeight.w700,
        height: 56.0 / 48.0,
        letterSpacing: -0.96,
        color: p.onSurface,
      );

  /// `headline-lg` 30/38, 700, -0.01em.
  static TextStyle headlineLgFor(KaloriPalette p) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 30.0,
        fontWeight: FontWeight.w700,
        height: 38.0 / 30.0,
        letterSpacing: -0.30,
        color: p.onSurface,
      );

  /// `headline-lg-mobile` 24/32, 700.
  static TextStyle headlineLgMobileFor(KaloriPalette p) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        height: 32.0 / 24.0,
        color: p.onSurface,
      );

  /// `headline-md` 20/28, 600.
  static TextStyle headlineMdFor(KaloriPalette p) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        height: 28.0 / 20.0,
        color: p.onSurface,
      );

  /// `body-lg` 16/24, 400.
  static TextStyle bodyLgFor(KaloriPalette p) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 24.0 / 16.0,
        color: p.neutralSlate,
      );

  /// `body-sm` 14/20, 400.
  static TextStyle bodySmFor(KaloriPalette p) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 20.0 / 14.0,
        color: p.neutralSlate,
      );

  /// `label-caps` 12/16, 700, +0.05em. Category headers (PROTEIN, CARBS, FAT).
  static TextStyle labelCapsFor(KaloriPalette p) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w700,
        height: 16.0 / 12.0,
        letterSpacing: 0.60,
        color: p.onSurfaceVariant,
      );

  // Active-palette shortcuts.
  static TextStyle get displayNum => displayNumFor(KaloriColors.current);
  static TextStyle get headlineLg => headlineLgFor(KaloriColors.current);
  static TextStyle get headlineLgMobile => headlineLgMobileFor(KaloriColors.current);
  static TextStyle get headlineMd => headlineMdFor(KaloriColors.current);
  static TextStyle get bodyLg => bodyLgFor(KaloriColors.current);
  static TextStyle get bodySm => bodySmFor(KaloriColors.current);
  static TextStyle get labelCaps => labelCapsFor(KaloriColors.current);
}

/// [ThemeExtension] carrying the Kalori text styles for one palette (`context.typography`).
class KaloriTextExtension extends ThemeExtension<KaloriTextExtension> {
  final TextStyle displayNum;
  final TextStyle headlineLg;
  final TextStyle headlineLgMobile;
  final TextStyle headlineMd;
  final TextStyle bodyLg;
  final TextStyle bodySm;
  final TextStyle labelCaps;

  const KaloriTextExtension({
    required this.displayNum,
    required this.headlineLg,
    required this.headlineLgMobile,
    required this.headlineMd,
    required this.bodyLg,
    required this.bodySm,
    required this.labelCaps,
  });

  factory KaloriTextExtension.forPalette(KaloriPalette p) => KaloriTextExtension(
        displayNum: KaloriTypography.displayNumFor(p),
        headlineLg: KaloriTypography.headlineLgFor(p),
        headlineLgMobile: KaloriTypography.headlineLgMobileFor(p),
        headlineMd: KaloriTypography.headlineMdFor(p),
        bodyLg: KaloriTypography.bodyLgFor(p),
        bodySm: KaloriTypography.bodySmFor(p),
        labelCaps: KaloriTypography.labelCapsFor(p),
      );

  /// Styles for the active palette (fallback when no theme extension is found).
  static KaloriTextExtension get standard => KaloriTextExtension.forPalette(KaloriColors.current);

  @override
  ThemeExtension<KaloriTextExtension> copyWith({
    TextStyle? displayNum,
    TextStyle? headlineLg,
    TextStyle? headlineLgMobile,
    TextStyle? headlineMd,
    TextStyle? bodyLg,
    TextStyle? bodySm,
    TextStyle? labelCaps,
  }) {
    return KaloriTextExtension(
      displayNum: displayNum ?? this.displayNum,
      headlineLg: headlineLg ?? this.headlineLg,
      headlineLgMobile: headlineLgMobile ?? this.headlineLgMobile,
      headlineMd: headlineMd ?? this.headlineMd,
      bodyLg: bodyLg ?? this.bodyLg,
      bodySm: bodySm ?? this.bodySm,
      labelCaps: labelCaps ?? this.labelCaps,
    );
  }

  @override
  ThemeExtension<KaloriTextExtension> lerp(covariant ThemeExtension<KaloriTextExtension>? other, double t) {
    if (other is! KaloriTextExtension) {
      return this;
    }
    return KaloriTextExtension(
      displayNum: TextStyle.lerp(displayNum, other.displayNum, t)!,
      headlineLg: TextStyle.lerp(headlineLg, other.headlineLg, t)!,
      headlineLgMobile: TextStyle.lerp(headlineLgMobile, other.headlineLgMobile, t)!,
      headlineMd: TextStyle.lerp(headlineMd, other.headlineMd, t)!,
      bodyLg: TextStyle.lerp(bodyLg, other.bodyLg, t)!,
      bodySm: TextStyle.lerp(bodySm, other.bodySm, t)!,
      labelCaps: TextStyle.lerp(labelCaps, other.labelCaps, t)!,
    );
  }
}
