import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalori/core/theme/app_colors.dart';
import 'package:kalori/core/theme/app_spacing.dart';
import 'package:kalori/core/theme/app_typography.dart';

export 'app_colors.dart';
export 'app_spacing.dart';
export 'app_typography.dart';

/// Light and dark [ThemeData] for Kalori (DESIGN.md), each built from its own [KaloriPalette].
class KaloriTheme {
  KaloriTheme._();

  static ThemeData get light => _build(KaloriPalette.light);

  static ThemeData get dark => _build(KaloriPalette.dark);

  static ThemeData _build(KaloriPalette p) {
    final isDark = p.isDark;
    final colorScheme = ColorScheme(
      brightness: p.brightness,
      primary: p.primary,
      onPrimary: p.onPrimary,
      primaryContainer: p.primaryContainer,
      onPrimaryContainer: p.onPrimaryContainer,
      secondary: p.secondary,
      onSecondary: p.onSecondary,
      secondaryContainer: p.secondaryContainer,
      onSecondaryContainer: p.onSecondaryContainer,
      tertiary: p.tertiary,
      onTertiary: p.onTertiary,
      tertiaryContainer: p.tertiaryContainer,
      onTertiaryContainer: p.onTertiaryContainer,
      error: p.error,
      onError: p.onError,
      errorContainer: p.errorContainer,
      onErrorContainer: p.onErrorContainer,
      surface: p.surface,
      onSurface: p.onSurface,
      surfaceContainerLowest: p.surfaceContainerLowest,
      surfaceContainerLow: p.surfaceContainerLow,
      surfaceContainer: p.surfaceContainer,
      surfaceContainerHigh: p.surfaceContainerHigh,
      surfaceContainerHighest: p.surfaceContainerHighest,
      onSurfaceVariant: p.onSurfaceVariant,
      outline: p.outline,
      outlineVariant: p.outlineVariant,
      inverseSurface: p.inverseSurface,
      onInverseSurface: p.inverseOnSurface,
      inversePrimary: p.inversePrimary,
      surfaceTint: p.surfaceTint,
      scrim: p.scrim,
    );
    final text = KaloriTextExtension.forPalette(p);
    final overlay = isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: p.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: p.background,
      canvasColor: p.background,
      fontFamily: KaloriTypography.fontFamily,
      textTheme: TextTheme(
        displayLarge: text.displayNum,
        headlineLarge: text.headlineLg,
        headlineMedium: text.headlineLgMobile,
        headlineSmall: text.headlineMd,
        titleLarge: text.headlineMd,
        bodyLarge: text.bodyLg,
        bodyMedium: text.bodySm,
        labelSmall: text.labelCaps,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: overlay,
      ),
      iconTheme: IconThemeData(color: p.onSurface),
      dividerTheme: DividerThemeData(color: p.borderSlate),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: text.headlineMd.copyWith(fontWeight: FontWeight.w700),
        contentTextStyle: text.bodySm,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.background,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: p.scrim,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: p.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        headerForegroundColor: p.onSurface,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: p.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        textStyle: text.bodyLg.copyWith(color: p.onSurface),
      ),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: p.primary)),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? Colors.white : p.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? p.successGreen : p.surfaceContainerHigh,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? Colors.transparent : p.outline,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.primary),
      snackBarTheme: SnackBarThemeData(backgroundColor: p.inverseSurface),
      // Cards & containers: level 1, rounded-lg 16px, 1px border.
      cardTheme: CardThemeData(
        color: p.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KaloriRadius.lg),
          side: BorderSide(color: p.borderSlate),
        ),
      ),
      // Primary call to action: success green, rounded-xl, min height 48.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.successGreen,
          foregroundColor: Colors.white,
          disabledBackgroundColor: p.surfaceContainerHigh,
          disabledForegroundColor: p.outline,
          elevation: 0,
          minimumSize: const Size.fromHeight(48.0),
          padding: const EdgeInsets.symmetric(horizontal: KaloriSpacing.lg, vertical: KaloriSpacing.sm),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KaloriRadius.xl)),
          textStyle: text.headlineMd.copyWith(color: Colors.white),
        ),
      ),
      // Secondary call to action: ghost with a subtle border.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.neutralSlate,
          minimumSize: const Size.fromHeight(48.0),
          padding: const EdgeInsets.symmetric(horizontal: KaloriSpacing.lg, vertical: KaloriSpacing.sm),
          side: BorderSide(color: p.borderSlate),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KaloriRadius.xl)),
          textStyle: text.bodyLg.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      // Inputs: rounded-xl, tinted fill.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(horizontal: KaloriSpacing.md, vertical: KaloriSpacing.sm),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KaloriRadius.xl),
          borderSide: BorderSide(color: p.borderSlate),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KaloriRadius.xl),
          borderSide: BorderSide(color: p.borderSlate),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KaloriRadius.xl),
          borderSide: BorderSide(color: p.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KaloriRadius.xl),
          borderSide: BorderSide(color: p.error),
        ),
        hintStyle: text.bodyLg.copyWith(color: p.outline),
        suffixStyle: text.bodyLg.copyWith(color: p.outline),
        helperStyle: text.bodySm.copyWith(fontSize: 12.0, color: p.onSurfaceVariant),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: p.primary,
        selectionHandleColor: p.primary,
        selectionColor: p.primary.withValues(alpha: 0.3),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.surfaceContainerLow,
        labelStyle: text.labelCaps,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KaloriRadius.defaultRadius),
          side: BorderSide(color: p.borderSlate),
        ),
        padding: const EdgeInsets.symmetric(horizontal: KaloriSpacing.xs, vertical: KaloriSpacing.base),
      ),
      extensions: [
        KaloriColorExtension(p),
        text,
        KaloriSpacingExtension.standard,
      ],
    );
  }
}

/// Shortcuts for the Kalori theme extensions.
extension KaloriThemeContext on BuildContext {
  /// The palette of the theme this widget is built under.
  KaloriPalette get colors => (Theme.of(this).extension<KaloriColorExtension>() ?? KaloriColorExtension.light).palette;

  KaloriTextExtension get typography =>
      Theme.of(this).extension<KaloriTextExtension>() ?? KaloriTextExtension.standard;

  KaloriSpacingExtension get spacing =>
      Theme.of(this).extension<KaloriSpacingExtension>() ?? KaloriSpacingExtension.standard;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
