import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/locale_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/primary_pill_button.dart';
import '../auth/login_phone_screen.dart';

/// Node 25:119. Picking a row switches the app locale immediately, so the rest
/// of the flow is already in the chosen language.
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  Locale? _selected;

  @override
  Widget build(BuildContext context) {
    final LocaleController controller = LocaleScope.of(context);
    final Locale selected = _selected ?? controller.value;

    return Scaffold(
      backgroundColor: AppColors.surfaceBackdrop,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: <Widget>[
              Text(
                context.tr('language.title'),
                textAlign: TextAlign.center,
                style: appTextStyle(
                  size: 28,
                  lineHeight: 36,
                  weight: FontWeight.w700,
                  letterSpacing: -0.7,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceBackdrop,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    _LanguageOption(
                      label: context.tr('language.bengali'),
                      selected: selected.languageCode == 'bn',
                      onTap: () => _select(controller, const Locale('bn')),
                    ),
                    const SizedBox(height: 12),
                    _LanguageOption(
                      label: context.tr('language.english'),
                      selected: selected.languageCode == 'en',
                      onTap: () => _select(controller, const Locale('en')),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              PrimaryPillButton(
                icon: Icons.arrow_forward,
                iconSize: 20,
                width: 120,
                height: 50,
                onPressed: _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _select(LocaleController controller, Locale locale) {
    setState(() => _selected = locale);
    controller.value = locale;
  }

  void _continue() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LoginPhoneScreen(),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: appTextStyle(
                  size: 14,
                  lineHeight: 20,
                  weight: FontWeight.w500,
                  letterSpacing: 0.1,
                  color: AppColors.onSurfaceStrong,
                ),
              ),
            ),
            _Radio(selected: selected),
          ],
        ),
      ),
    );
  }
}

/// Filled disc with a cut-out centre when chosen, hollow ring when not.
class _Radio extends StatelessWidget {
  const _Radio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surfaceBackdrop,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.outlineStrong,
        ),
      ),
      child: Center(
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          scale: selected ? 1 : 0,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.surfaceBackdrop,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
