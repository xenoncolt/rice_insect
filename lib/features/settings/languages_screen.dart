import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/locale_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/primary_pill_button.dart';
import '../../core/widgets/surface_card.dart';
import 'widgets/settings_app_bar.dart';

/// Node 62:83 (Settings - Languages).
///
/// Geometry from the node tree: a 358x276 card holding an icon-and-heading row,
/// the description, and two 310x54 radio rows, with Cancel and Save buttons in
/// a 358x46 action area beneath it.
///
/// This is the only way to change language after onboarding, so Save actually
/// applies the locale.
class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  Locale? _pending;

  @override
  Widget build(BuildContext context) {
    final LocaleController controller = LocaleScope.of(context);
    final Locale selected = _pending ?? controller.value;

    return Scaffold(
      backgroundColor: AppColors.surfaceBackdrop,
      body: Column(
        children: <Widget>[
          SettingsAppBar(title: context.tr('languages.title')),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                SurfaceCard(
                  color: AppColors.surfaceSubtle,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.language,
                            size: 22,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.tr('languages.cardTitle'),
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
                      const SizedBox(height: 16),
                      Text(
                        context.tr('languages.description'),
                        style: appTextStyle(
                          size: 14,
                          lineHeight: 20,
                          letterSpacing: 0.25,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _LanguageRow(
                        label: context.tr('language.english'),
                        selected: selected.languageCode == 'en',
                        onTap: () =>
                            setState(() => _pending = const Locale('en')),
                      ),
                      const SizedBox(height: 12),
                      _LanguageRow(
                        label: context.tr('language.bengali'),
                        selected: selected.languageCode == 'bn',
                        onTap: () =>
                            setState(() => _pending = const Locale('bn')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16,
                  children: <Widget>[
                    Flexible(
                      child: _ResetButton(
                        label: context.tr('languages.reset'),
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    Flexible(
                      child: PrimaryPillButton(
                        label: context.tr('languages.save'),
                        height: 46,
                        width: null,
                        onPressed: () {
                          controller.value = selected;
                          Navigator.of(context).maybePop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Node 62:103 - a 310x54 row with the label at x17 and the radio at the right.
class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
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
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 17),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.divider,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Center(
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  scale: selected ? 1 : 0,
                  child: const Icon(
                    Icons.check,
                    size: 14,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 33),
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(999)),
        child: Text(
          label,
          style: appTextStyle(
            size: 14,
            lineHeight: 20,
            weight: FontWeight.w500,
            letterSpacing: 0.1,
            color: AppColors.primary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
