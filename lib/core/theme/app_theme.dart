import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Type scale from the Figma file. Inter carries the Latin glyphs; Noto Sans
/// Bengali is registered as a fallback so Bengali strings from the translation
/// files render instead of falling back to tofu boxes.
TextStyle appTextStyle({
  required double size,
  required double lineHeight,
  FontWeight weight = FontWeight.w400,
  double? letterSpacing,
  Color? color,
}) {
  return TextStyle(
    fontFamily: 'Inter',
    fontFamilyFallback: const <String>['NotoSansBengali'],
    fontSize: size,
    height: lineHeight / size,
    fontWeight: weight,
    // Both fonts are variable, so the weight has to be driven through the
    // `wght` axis - `fontWeight` alone would only pick the default instance.
    fontVariations: <FontVariation>[
      FontVariation('wght', weight.value.toDouble()),
    ],
    letterSpacing: letterSpacing,
    color: color,
  );
}

abstract final class AppText {
  const AppText._();

  /// 36/40, -0.9 tracking - the weather temperature.
  static TextStyle get display => appTextStyle(
    size: 36,
    lineHeight: 40,
    weight: FontWeight.w500,
    letterSpacing: -0.9,
    color: AppColors.onSurface,
  );

  /// 16/24 medium - card and list headings.
  static TextStyle get titleMedium => appTextStyle(
    size: 16,
    lineHeight: 24,
    weight: FontWeight.w500,
    color: AppColors.onSurface,
  );

  /// 16/24 regular - body copy and most labels.
  static TextStyle get body =>
      appTextStyle(size: 16, lineHeight: 24, color: AppColors.onSurface);

  static TextStyle get bodyMuted =>
      appTextStyle(size: 16, lineHeight: 24, color: AppColors.onSurfaceVariant);

  /// 12/18 medium - weather metrics.
  static TextStyle get caption => appTextStyle(
    size: 12,
    lineHeight: 18,
    weight: FontWeight.w500,
    color: AppColors.onSurfaceVariant,
  );

  /// 10/15 medium, 0.25 tracking, uppercase - status badges.
  static TextStyle get badge => appTextStyle(
    size: 10,
    lineHeight: 15,
    weight: FontWeight.w500,
    letterSpacing: 0.25,
    color: Colors.white,
  );
}

abstract final class AppTheme {
  const AppTheme._();

  /// Corner radius used by every card in the design.
  static const double cardRadius = 24;

  static ThemeData get light {
    const ColorScheme scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.primary,
      onSecondary: AppColors.onPrimary,
      secondaryContainer: AppColors.surfaceVariant,
      onSecondaryContainer: AppColors.onSurfaceVariant,
      tertiary: AppColors.tertiary,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.tertiary,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.divider,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.surfaceBackdrop,
      fontFamily: 'Inter',
      fontFamilyFallback: const <String>['NotoSansBengali'],
      splashFactory: InkSparkle.splashFactory,
      textTheme: TextTheme(
        displaySmall: AppText.display,
        titleMedium: AppText.titleMedium,
        bodyLarge: AppText.body,
        bodyMedium: AppText.bodyMuted,
        bodySmall: AppText.caption,
        labelSmall: AppText.badge,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
