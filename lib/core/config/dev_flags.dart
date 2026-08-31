import 'package:flutter/foundation.dart';

/// Debug-only shortcuts through the login flow.
///
/// Everything here is a `const` derived from [kDebugMode], so the branches are
/// tree-shaken out of release builds - a release APK cannot skip the OTP even
/// if someone flips a flag at runtime.
///
/// Override from the command line when you want the real flow in a debug build:
///
/// ```
/// flutter run --dart-define=BYPASS_OTP=false
/// ```
abstract final class DevFlags {
  const DevFlags._();

  /// Prefills the phone and OTP fields and reveals the "skip login" shortcut.
  static const bool bypassOtp =
      kDebugMode && bool.fromEnvironment('BYPASS_OTP', defaultValue: true);

  /// Dropped into the phone field so `Continue` is tappable straight away.
  static const String devPhoneNumber = '01700000000';

  /// Dropped into the six OTP boxes so `Verify Code` is tappable straight away.
  static const String devOtpCode = '123456';
}
