import 'package:flutter/material.dart';

/// Colours lifted directly from the Figma file (Dhaner Poka, node 59:356).
/// Keep these as the single source of truth - screens should read them through
/// [Theme.of] where a Material role exists, and from here when one does not.
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

  /// Frosted panel behind the weather block and the focused OTP box.
  static const Color surfaceSubtle = Color(0xFFF2F5E9);

  // Text
  static const Color onSurface = Color(0xFF1A1C18);
  static const Color onSurfaceVariant = Color(0xFF42493B);

  // Lines
  static const Color outline = Color(0xFFC2C9B6);
  static const Color outlineStrong = Color(0xFF75796C);
  static const Color divider = Color(0xFFECEFE3);

  /// Splash progress track.
  static const Color progressTrack = Color(0xFFE1E4D8);

  /// Slightly darker body colour used by the language rows.
  static const Color onSurfaceStrong = Color(0xFF191D15);

  // Status
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);

  /// Ink on the error container - the "Pest" badge in the activity lists.
  static const Color onErrorContainer = Color(0xFF93000A);

  /// Moderate-risk badge on the pest cards.
  static const Color warning = Color(0xFFFFB800);
  static const Color tertiary = Color(0xFF7E4F72);
  static const Color tertiaryContainer = Color(0xFFFFC4ED);

  /// Soft glow behind the welcome card heading.
  static const Color decorationGlow = Color(0xFFD1E9BE);

  /// Inactive bottom-nav label, and the muted icon on timeline cards.
  static const Color navLabel = Color(0xFF5A664F);

  /// Neutral badge behind the settings list icons (#EEEEEC in the file).
  static const Color settingsBadge = Color(0xFFEEEEEC);

  /// Tint for the Video Tutorials help card.
  static const Color videoTint = Color(0xFFD7E4C7);

  /// Gemini's own accent - deliberately violet, not the app green, because the
  /// assistant is a distinct brand in the design.
  static const Color geminiAccent = Color(0xFF9B72CB);

  /// The user's chat bubble.
  static const Color chatBubble = Color(0xFFE1E4D8);

  // Camera scanner - a dark surface with its own brighter accent so the
  // viewfinder reads against a live camera feed.
  static const Color scanAccent = Color(0xFFA8E77B);
  static const Color scanGlass = Color(0xFF191D15);
}
