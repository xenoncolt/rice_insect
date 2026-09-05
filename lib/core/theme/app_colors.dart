import 'package:flutter/material.dart';

/// colours straight from the figma file.
/// single source of truth, don't hardcode hex anywhere else.
abstract final class AppColors {
  const AppColors._();

  // Brand / primary
  static const Color primary = Color(0xFF356B0A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFD1E9BE);
  static const Color onPrimaryContainer = Color(0xFF336907);

  // Surfaces
  static const Color surface = Color(0xFFF9FAF7);
  static const Color surfaceBackdrop = Color(0xFFF8FBEE);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE7E9DD);
  static const Color navBar = Color(0xFFECEFE3);

  /// weather panel + focused otp box
  static const Color surfaceSubtle = Color(0xFFF2F5E9);

  // Text
  static const Color onSurface = Color(0xFF1A1C18);
  static const Color onSurfaceVariant = Color(0xFF42493B);

  // Lines
  static const Color outline = Color(0xFFC2C9B6);
  static const Color outlineStrong = Color(0xFF75796C);
  static const Color divider = Color(0xFFECEFE3);

  /// splash progress bar track
  static const Color progressTrack = Color(0xFFE1E4D8);

  /// bit darker than onSurface, language rows use it
  static const Color onSurfaceStrong = Color(0xFF191D15);

  // Status
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);

  /// text on errorContainer (the "Pest" badge)
  static const Color onErrorContainer = Color(0xFF93000A);

  /// moderate risk badge
  static const Color warning = Color(0xFFFFB800);
  static const Color tertiary = Color(0xFF7E4F72);
  static const Color tertiaryContainer = Color(0xFFFFC4ED);

  /// blurred glow in the welcome card
  static const Color decorationGlow = Color(0xFFD1E9BE);

  /// inactive nav label + muted timeline icons
  static const Color navLabel = Color(0xFF5A664F);

  /// grey circle behind the settings row icons
  static const Color settingsBadge = Color(0xFFEEEEEC);

  /// video tutorials card tint
  static const Color videoTint = Color(0xFFD7E4C7);

  /// gemini purple. not the app green on purpose, it's their brand.
  static const Color geminiAccent = Color(0xFF9B72CB);

  /// user chat bubble
  static const Color chatBubble = Color(0xFFE1E4D8);

  // scanner colours. dark + a brighter green so it shows over the camera.
  static const Color scanAccent = Color(0xFFA8E77B);
  static const Color scanGlass = Color(0xFF191D15);
}
