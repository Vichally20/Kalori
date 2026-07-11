import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Static typography definitions strictly reflecting the `typography` specs in [DESIGN.md].
///
/// Uses the **Inter** font family (`fontFamily: 'Inter'`), calibrated with exact
/// fontSize, fontWeight, lineHeight (as `height`), and letterSpacing.
class KaloriTypography {
  KaloriTypography._();

  static const String fontFamily = 'Inter';

  /// `display-num`
  /// fontFamily: Inter, fontSize: 48px, fontWeight: 700, lineHeight: 56px, letterSpacing: -0.02em (-0.96px)
  /// Data-First: Used for the main calorie counter.
  static const TextStyle displayNum = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48.0,
    fontWeight: FontWeight.w700,
    height: 56.0 / 48.0,
    letterSpacing: -0.96, // -0.02 * 48
    color: KaloriColors.onSurface,
  );

  /// `headline-lg`
  /// fontFamily: Inter, fontSize: 30px, fontWeight: 700, lineHeight: 38px, letterSpacing: -0.01em (-0.30px)
  static const TextStyle headlineLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30.0,
    fontWeight: FontWeight.w700,
    height: 38.0 / 30.0,
    letterSpacing: -0.30, // -0.01 * 30
    color: KaloriColors.onSurface,
  );

  /// `headline-lg-mobile`
  /// fontFamily: Inter, fontSize: 24px, fontWeight: 700, lineHeight: 32px
  static const TextStyle headlineLgMobile = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    height: 32.0 / 24.0,
    color: KaloriColors.onSurface,
  );

  /// `headline-md`
  /// fontFamily: Inter, fontSize: 20px, fontWeight: 600, lineHeight: 28px
  static const TextStyle headlineMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    height: 28.0 / 20.0,
    color: KaloriColors.onSurface,
  );

  /// `body-lg`
  /// fontFamily: Inter, fontSize: 16px, fontWeight: 400, lineHeight: 24px
  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 24.0 / 16.0,
    color: KaloriColors.neutralSlate,
  );

  /// `body-sm`
  /// fontFamily: Inter, fontSize: 14px, fontWeight: 400, lineHeight: 20px
  static const TextStyle bodySm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 20.0 / 14.0,
    color: KaloriColors.neutralSlate,
  );

  /// `label-caps`
  /// fontFamily: Inter, fontSize: 12px, fontWeight: 700, lineHeight: 16px, letterSpacing: 0.05em (0.60px)
  /// Hierarchy: Used for category headers (e.g., PROTEIN, CARBS, FATS).
  static const TextStyle labelCaps = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    height: 16.0 / 12.0,
    letterSpacing: 0.60, // 0.05 * 12
    color: KaloriColors.onSurfaceVariant,
  );
}

/// [ThemeExtension] providing exact text style tokens from [DESIGN.md] so that
/// widgets can access them seamlessly via `Theme.of(context).extension<KaloriTextExtension>()`.
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

  /// Standard typography extension matching exact [DESIGN.md] specifications.
  static const KaloriTextExtension standard = KaloriTextExtension(
    displayNum: KaloriTypography.displayNum,
    headlineLg: KaloriTypography.headlineLg,
    headlineLgMobile: KaloriTypography.headlineLgMobile,
    headlineMd: KaloriTypography.headlineMd,
    bodyLg: KaloriTypography.bodyLg,
    bodySm: KaloriTypography.bodySm,
    labelCaps: KaloriTypography.labelCaps,
  );

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
  ThemeExtension<KaloriTextExtension> lerp(
    covariant ThemeExtension<KaloriTextExtension>? other,
    double t,
  ) {
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
