import 'package:flutter/material.dart';

/// Raw color palette directly reflecting [DESIGN.md] specifications for the
/// Kalori Design System.
class KaloriColors {
  KaloriColors._();

  // Material Surface Roles
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceDim = Color(0xFFCCDBF4);
  static const Color surfaceBright = Color(0xFFF8F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color surfaceContainer = Color(0xFFE6EEFF);
  static const Color surfaceContainerHigh = Color(0xFFDDE9FF);
  static const Color surfaceContainerHighest = Color(0xFFD5E3FD);
  static const Color onSurface = Color(0xFF0D1C2F);
  static const Color onSurfaceVariant = Color(0xFF3C4A42);
  static const Color inverseSurface = Color(0xFF233144);
  static const Color inverseOnSurface = Color(0xFFEBF1FF);
  static const Color surfaceVariant = Color(0xFFD5E3FD);
  static const Color surfaceTint = Color(0xFF006C49);

  // Outline Roles
  static const Color outline = Color(0xFF6C7A71);
  static const Color outlineVariant = Color(0xFFBBCABF);

  // Primary Roles
  static const Color primary = Color(0xFF006C49);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF10B981);
  static const Color onPrimaryContainer = Color(0xFF00422B);
  static const Color inversePrimary = Color(0xFF4EDEA3);

  // Secondary Roles
  static const Color secondary = Color(0xFF855300);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFEA619);
  static const Color onSecondaryContainer = Color(0xFF684000);

  // Tertiary Roles
  static const Color tertiary = Color(0xFF005AC2);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF71A1FF);
  static const Color onTertiaryContainer = Color(0xFF00367A);

  // Error Roles
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Primary Fixed Roles
  static const Color primaryFixed = Color(0xFF6FFBBE);
  static const Color primaryFixedDim = Color(0xFF4EDEA3);
  static const Color onPrimaryFixed = Color(0xFF002113);
  static const Color onPrimaryFixedVariant = Color(0xFF005236);

  // Secondary Fixed Roles
  static const Color secondaryFixed = Color(0xFFFFDDB8);
  static const Color secondaryFixedDim = Color(0xFFFFB95F);
  static const Color onSecondaryFixed = Color(0xFF2A1700);
  static const Color onSecondaryFixedVariant = Color(0xFF653E00);

  // Tertiary Fixed Roles
  static const Color tertiaryFixed = Color(0xFFD8E2FF);
  static const Color tertiaryFixedDim = Color(0xFFADC6FF);
  static const Color onTertiaryFixed = Color(0xFF001A42);
  static const Color onTertiaryFixedVariant = Color(0xFF004395);

  // Background Roles
  static const Color background = Color(0xFFF8F9FF);
  static const Color onBackground = Color(0xFF0D1C2F);

  // Brand & Semantic Colors (from DESIGN.md section)
  /// Success Green (#10B981) - Primary brand color, on-track statuses, completed goals.
  static const Color successGreen = Color(0xFF10B981);

  /// Warning Orange (#F59E0B) - Approaching daily caloric/macronutrient limits.
  static const Color warningOrange = Color(0xFFF59E0B);

  /// Neutral Slate (#334155) - Primary text & structural UI elements.
  static const Color neutralSlate = Color(0xFF334155);

  /// Light Slate (#F8FAFC) - Very light slate tint for main canvas level 0.
  static const Color lightSlate = Color(0xFFF8FAFC);

  /// Border Slate (#E2E8F0) - 1px borders for input fields and secondary cards.
  static const Color borderSlate = Color(0xFFE2E8F0);

  /// Soft Card Shadow - 0px 4px 20px rgba(51, 65, 85, 0.08).
  static const Color cardShadow = Color(0x14334155);
}

/// [ThemeExtension] providing specialized and semantic colors defined in the
/// Kalori Design System beyond standard [ColorScheme].
class KaloriColorExtension extends ThemeExtension<KaloriColorExtension> {
  // Fixed Colors
  final Color primaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixed;
  final Color onPrimaryFixedVariant;

  final Color secondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixed;
  final Color onSecondaryFixedVariant;

  final Color tertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixed;
  final Color onTertiaryFixedVariant;

  // Semantic & Brand Colors
  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color neutralSlate;
  final Color lightSlate;
  final Color borderSlate;
  final Color cardShadow;

  const KaloriColorExtension({
    required this.primaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixed,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixed,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixed,
    required this.onTertiaryFixedVariant,
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.neutralSlate,
    required this.lightSlate,
    required this.borderSlate,
    required this.cardShadow,
  });

  /// Standard light color extension values adhering strictly to [DESIGN.md].
  static const KaloriColorExtension light = KaloriColorExtension(
    primaryFixed: KaloriColors.primaryFixed,
    primaryFixedDim: KaloriColors.primaryFixedDim,
    onPrimaryFixed: KaloriColors.onPrimaryFixed,
    onPrimaryFixedVariant: KaloriColors.onPrimaryFixedVariant,
    secondaryFixed: KaloriColors.secondaryFixed,
    secondaryFixedDim: KaloriColors.secondaryFixedDim,
    onSecondaryFixed: KaloriColors.onSecondaryFixed,
    onSecondaryFixedVariant: KaloriColors.onSecondaryFixedVariant,
    tertiaryFixed: KaloriColors.tertiaryFixed,
    tertiaryFixedDim: KaloriColors.tertiaryFixedDim,
    onTertiaryFixed: KaloriColors.onTertiaryFixed,
    onTertiaryFixedVariant: KaloriColors.onTertiaryFixedVariant,
    success: KaloriColors.successGreen,
    onSuccess: Colors.white,
    warning: KaloriColors.warningOrange,
    onWarning: Colors.white,
    neutralSlate: KaloriColors.neutralSlate,
    lightSlate: KaloriColors.lightSlate,
    borderSlate: KaloriColors.borderSlate,
    cardShadow: KaloriColors.cardShadow,
  );

  @override
  ThemeExtension<KaloriColorExtension> copyWith({
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? onSecondaryFixed,
    Color? onSecondaryFixedVariant,
    Color? tertiaryFixed,
    Color? tertiaryFixedDim,
    Color? onTertiaryFixed,
    Color? onTertiaryFixedVariant,
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? neutralSlate,
    Color? lightSlate,
    Color? borderSlate,
    Color? cardShadow,
  }) {
    return KaloriColorExtension(
      primaryFixed: primaryFixed ?? this.primaryFixed,
      primaryFixedDim: primaryFixedDim ?? this.primaryFixedDim,
      onPrimaryFixed: onPrimaryFixed ?? this.onPrimaryFixed,
      onPrimaryFixedVariant: onPrimaryFixedVariant ?? this.onPrimaryFixedVariant,
      secondaryFixed: secondaryFixed ?? this.secondaryFixed,
      secondaryFixedDim: secondaryFixedDim ?? this.secondaryFixedDim,
      onSecondaryFixed: onSecondaryFixed ?? this.onSecondaryFixed,
      onSecondaryFixedVariant: onSecondaryFixedVariant ?? this.onSecondaryFixedVariant,
      tertiaryFixed: tertiaryFixed ?? this.tertiaryFixed,
      tertiaryFixedDim: tertiaryFixedDim ?? this.tertiaryFixedDim,
      onTertiaryFixed: onTertiaryFixed ?? this.onTertiaryFixed,
      onTertiaryFixedVariant: onTertiaryFixedVariant ?? this.onTertiaryFixedVariant,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      neutralSlate: neutralSlate ?? this.neutralSlate,
      lightSlate: lightSlate ?? this.lightSlate,
      borderSlate: borderSlate ?? this.borderSlate,
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  ThemeExtension<KaloriColorExtension> lerp(
    covariant ThemeExtension<KaloriColorExtension>? other,
    double t,
  ) {
    if (other is! KaloriColorExtension) {
      return this;
    }
    return KaloriColorExtension(
      primaryFixed: Color.lerp(primaryFixed, other.primaryFixed, t)!,
      primaryFixedDim: Color.lerp(primaryFixedDim, other.primaryFixedDim, t)!,
      onPrimaryFixed: Color.lerp(onPrimaryFixed, other.onPrimaryFixed, t)!,
      onPrimaryFixedVariant: Color.lerp(onPrimaryFixedVariant, other.onPrimaryFixedVariant, t)!,
      secondaryFixed: Color.lerp(secondaryFixed, other.secondaryFixed, t)!,
      secondaryFixedDim: Color.lerp(secondaryFixedDim, other.secondaryFixedDim, t)!,
      onSecondaryFixed: Color.lerp(onSecondaryFixed, other.onSecondaryFixed, t)!,
      onSecondaryFixedVariant: Color.lerp(onSecondaryFixedVariant, other.onSecondaryFixedVariant, t)!,
      tertiaryFixed: Color.lerp(tertiaryFixed, other.tertiaryFixed, t)!,
      tertiaryFixedDim: Color.lerp(tertiaryFixedDim, other.tertiaryFixedDim, t)!,
      onTertiaryFixed: Color.lerp(onTertiaryFixed, other.onTertiaryFixed, t)!,
      onTertiaryFixedVariant: Color.lerp(onTertiaryFixedVariant, other.onTertiaryFixedVariant, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      neutralSlate: Color.lerp(neutralSlate, other.neutralSlate, t)!,
      lightSlate: Color.lerp(lightSlate, other.lightSlate, t)!,
      borderSlate: Color.lerp(borderSlate, other.borderSlate, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
    );
  }
}
