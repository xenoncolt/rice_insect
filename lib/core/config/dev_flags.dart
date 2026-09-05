import 'package:flutter/foundation.dart';


abstract final class DevFlags {
  const DevFlags._();

  /// prefills phone + otp and shows the skip button
  static const bool bypassOtp =
      kDebugMode && bool.fromEnvironment('BYPASS_OTP', defaultValue: true);

  /// goes in the phone field so Continue is enabled right away
  static const String devPhoneNumber = '01700000000';

  /// goes in the otp boxes so Verify is enabled right away
  static const String devOtpCode = '123456';
}
