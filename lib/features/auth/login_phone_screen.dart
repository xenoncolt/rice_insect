import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/config/dev_flags.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/primary_pill_button.dart';
import '../shell/app_shell.dart';
import 'otp_screen.dart';

/// figma 1:17388
class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});

  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final TextEditingController _phone = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phone.addListener(() => setState(() {}));
    if (DevFlags.bypassOtp) {
      _phone.text = DevFlags.devPhoneNumber;
    }
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  bool get _canContinue => _phone.text.trim().length >= 11;

  /// debug only, skips the whole login
  void _skipLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const AppShell(),
      ),
      (Route<void> route) => false,
    );
  }

  void _continue() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            OtpScreen(phoneNumber: _phone.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackdrop,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surfaceBackdrop,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/app_logo.png',
                      width: 153.53,
                      height: 153.53,
                      filterQuality: FilterQuality.medium,
                      cacheWidth: 461,
                    ),
                    Text(
                      context.tr('app.name'),
                      textAlign: TextAlign.center,
                      style: appTextStyle(
                        size: 28,
                        lineHeight: 36,
                        weight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      context.tr('login.subtitle'),
                      textAlign: TextAlign.center,
                      style: appTextStyle(
                        size: 14,
                        lineHeight: 20,
                        letterSpacing: 0.25,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        style: appTextStyle(
                          size: 16,
                          lineHeight: 24,
                          color: AppColors.onSurface,
                        ),
                        decoration: InputDecoration(
                          labelText: context.tr('login.phoneLabel'),
                          hintText: context.tr('login.phoneHint'),
                          filled: true,
                          fillColor: AppColors.surfaceCard,
                          prefixIcon: const Icon(
                            Icons.phone_outlined,
                            size: 18,
                            color: AppColors.onSurfaceVariant,
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 18,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          labelStyle: appTextStyle(
                            size: 12,
                            lineHeight: 16,
                            color: AppColors.onSurfaceVariant,
                          ),
                          hintStyle: appTextStyle(
                            size: 16,
                            lineHeight: 24,
                            color: AppColors.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          border: _border(AppColors.outlineStrong),
                          enabledBorder: _border(AppColors.outlineStrong),
                          focusedBorder: _border(AppColors.primary, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryPillButton(
                      label: context.tr('login.continueAction'),
                      icon: Icons.arrow_forward,
                      iconAfterLabel: true,
                      height: 48,
                      onPressed: _canContinue ? _continue : null,
                    ),
                    if (DevFlags.bypassOtp)
                      TextButton(
                        onPressed: _skipLogin,
                        child: Text(
                          context.tr('debug.skipLogin'),
                          style: appTextStyle(
                            size: 12,
                            lineHeight: 16,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
