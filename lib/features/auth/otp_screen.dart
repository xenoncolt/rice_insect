import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/config/dev_flags.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/primary_pill_button.dart';
import '../shell/app_shell.dart';

/// figma 1:17481
///
/// figma has the 6 boxes at a fixed 48pt = 328pt, which doesn't fit in the
/// 390pt frame once the card padding is there. so they flex instead.
class OtpScreen extends StatefulWidget {
  const OtpScreen({required this.phoneNumber, super.key});

  final String phoneNumber;

  static const int digits = 6;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final List<TextEditingController> _controllers =
      List<TextEditingController>.generate(
        OtpScreen.digits,
        (_) => TextEditingController(),
      );

  late final List<FocusNode> _focusNodes = List<FocusNode>.generate(
    OtpScreen.digits,
    (_) => FocusNode()..addListener(() => setState(() {})),
  );

  @override
  void initState() {
    super.initState();
    if (DevFlags.bypassOtp) {
      for (int i = 0; i < OtpScreen.digits; i++) {
        _controllers[i].text = DevFlags.devOtpCode[i];
      }
    }
  }

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers) {
      controller.dispose();
    }
    for (final FocusNode node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _code =>
      _controllers.map((TextEditingController c) => c.text).join();

  bool get _isComplete => _code.length == OtpScreen.digits;

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < OtpScreen.digits - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _verify() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const AppShell(),
      ),
      (Route<void> route) => false,
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
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/app_logo.png',
                          width: 49,
                          height: 49,
                          filterQuality: FilterQuality.medium,
                          cacheWidth: 147,
                        ),
                        Flexible(
                          child: Text(
                            context.tr('app.name'),
                            style: appTextStyle(
                              size: 22,
                              lineHeight: 28,
                              weight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.tr('otp.title'),
                      textAlign: TextAlign.center,
                      style: appTextStyle(
                        size: 28,
                        lineHeight: 36,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.tr('otp.subtitle'),
                      textAlign: TextAlign.center,
                      style: appTextStyle(
                        size: 14,
                        lineHeight: 20,
                        letterSpacing: 0.25,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      spacing: 8,
                      children: <Widget>[
                        for (int i = 0; i < OtpScreen.digits; i++)
                          Expanded(child: _digitBox(i)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    PrimaryPillButton(
                      label: context.tr('otp.verify'),
                      height: 48,
                      onPressed: _isComplete ? _verify : null,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 4,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            context.tr('otp.noCode'),
                            style: appTextStyle(
                              size: 14,
                              lineHeight: 20,
                              letterSpacing: 0.25,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Text(
                          context.tr('otp.resend'),
                          style: appTextStyle(
                            size: 14,
                            lineHeight: 20,
                            weight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
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

  Widget _digitBox(int index) {
    final bool active = _focusNodes[index].hasFocus;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      height: 56,
      decoration: BoxDecoration(
        color: active ? AppColors.surfaceSubtle : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: active ? AppColors.primary : AppColors.outlineStrong,
          width: active ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        style: appTextStyle(
          size: 22,
          lineHeight: 28,
          weight: FontWeight.w500,
          color: AppColors.onSurface,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (String value) => _onDigitChanged(index, value),
      ),
    );
  }
}
