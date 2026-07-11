import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

export 'app_colors.dart';
export 'app_spacing.dart';
export 'app_typography.dart';

/// The central [ThemeData] configuration for the Kalori application, strictly
/// implementing the **Modern Minimalism** design language specified in [DESIGN.md].
class KaloriTheme {
  KaloriTheme._();

  /// Constructs the light [ThemeData] with integrated [KaloriColorExtension],
  /// [KaloriTextExtension], and [KaloriSpacingExtension].
  static ThemeData get light {
    const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: KaloriColors.primary,
      onPrimary: KaloriColors.onPrimary,
      primaryContainer: KaloriColors.primaryContainer,
      onPrimaryContainer: KaloriColors.onPrimaryContainer,
      secondary: KaloriColors.secondary,
      onSecondary: KaloriColors.onSecondary,
      secondaryContainer: KaloriColors.secondaryContainer,
      onSecondaryContainer: KaloriColors.onSecondaryContainer,
      tertiary: KaloriColors.tertiary,
      onTertiary: KaloriColors.onTertiary,
      tertiaryContainer: KaloriColors.tertiaryContainer,
      onTertiaryContainer: KaloriColors.onTertiaryContainer,
      error: KaloriColors.error,
      onError: KaloriColors.onError,
      errorContainer: KaloriColors.errorContainer,
      onErrorContainer: KaloriColors.onErrorContainer,
      surface: KaloriColors.surface,
      onSurface: KaloriColors.onSurface,
      surfaceContainerHighest: KaloriColors.surfaceContainerHighest,
      onSurfaceVariant: KaloriColors.onSurfaceVariant,
      outline: KaloriColors.outline,
      outlineVariant: KaloriColors.outlineVariant,
      inverseSurface: KaloriColors.inverseSurface,
      onInverseSurface: KaloriColors.inverseOnSurface,
      inversePrimary: KaloriColors.inversePrimary,
      surfaceTint: KaloriColors.surfaceTint,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: KaloriColors.background,
      fontFamily: KaloriTypography.fontFamily,
      textTheme: const TextTheme(
        displayLarge: KaloriTypography.displayNum,
        headlineLarge: KaloriTypography.headlineLg,
        headlineMedium: KaloriTypography.headlineLgMobile,
        headlineSmall: KaloriTypography.headlineMd,
        bodyLarge: KaloriTypography.bodyLg,
        bodyMedium: KaloriTypography.bodySm,
        labelSmall: KaloriTypography.labelCaps,
      ),
      // Cards & Containers (Level 1: Pure White, Rounded-lg: 16px, subtle soft shadow)
      cardTheme: CardThemeData(
        color: KaloriColors.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KaloriRadius.lg),
          side: const BorderSide(color: KaloriColors.borderSlate, width: 1.0),
        ),
      ),
      // Primary Call-to-Actions (Buttons: rounded-xl 24px, min height 48px, Success Green)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: KaloriColors.successGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(48.0),
          padding: const EdgeInsets.symmetric(
            horizontal: KaloriSpacing.lg,
            vertical: KaloriSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KaloriRadius.xl),
          ),
          textStyle: KaloriTypography.headlineMd.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      // Secondary Call-to-Actions (Ghost style, subtle border, rounded-xl)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: KaloriColors.neutralSlate,
          minimumSize: const Size.fromHeight(48.0),
          padding: const EdgeInsets.symmetric(
            horizontal: KaloriSpacing.lg,
            vertical: KaloriSpacing.sm,
          ),
          side: const BorderSide(color: KaloriColors.borderSlate, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KaloriRadius.xl),
          ),
          textStyle: KaloriTypography.bodyLg.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Input Fields (Search bars: rounded-xl 24px, light grey/blue background)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: KaloriColors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: KaloriSpacing.md,
          vertical: KaloriSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KaloriRadius.xl),
          borderSide: const BorderSide(color: KaloriColors.borderSlate, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KaloriRadius.xl),
          borderSide: const BorderSide(color: KaloriColors.borderSlate, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KaloriRadius.xl),
          borderSide: const BorderSide(color: KaloriColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KaloriRadius.xl),
          borderSide: const BorderSide(color: KaloriColors.error, width: 1.0),
        ),
        hintStyle: KaloriTypography.bodyLg.copyWith(
          color: KaloriColors.outline,
        ),
      ),
      // Chips (Dietary tags with label-caps and subtle tint)
      chipTheme: ChipThemeData(
        backgroundColor: KaloriColors.surfaceContainerLow,
        labelStyle: KaloriTypography.labelCaps,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KaloriRadius.defaultRadius),
          side: const BorderSide(color: KaloriColors.borderSlate),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: KaloriSpacing.xs,
          vertical: KaloriSpacing.base,
        ),
      ),
      extensions: const [
        KaloriColorExtension.light,
        KaloriTextExtension.standard,
        KaloriSpacingExtension.standard,
      ],
    );
  }
}

/// Convenient extensions on [BuildContext] to access Kalori theme extensions
/// directly without boilerplate `Theme.of(context).extension<...>()`.
extension KaloriThemeContext on BuildContext {
  /// Access semantic and specialized colors from [KaloriColorExtension].
  KaloriColorExtension get colors {
    return Theme.of(this).extension<KaloriColorExtension>() ??
        KaloriColorExtension.light;
  }

  /// Access specialized typography styles from [KaloriTextExtension].
  KaloriTextExtension get typography {
    return Theme.of(this).extension<KaloriTextExtension>() ??
        KaloriTextExtension.standard;
  }

  /// Access spacing and corner radii from [KaloriSpacingExtension].
  KaloriSpacingExtension get spacing {
    return Theme.of(this).extension<KaloriSpacingExtension>() ??
        KaloriSpacingExtension.standard;
  }

  /// Shortcut for checking if the current theme is dark mode.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
