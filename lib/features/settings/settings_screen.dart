import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/surface_card.dart';
import '../help/help_screen.dart';
import 'account_screen.dart';
import 'languages_screen.dart';

/// figma 1:17514. profile card, 3 rows, sign out.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const _SettingsAppBar(),
        Expanded(
          child: ColoredBox(
            color: AppColors.surfaceBackdrop,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              children: <Widget>[
                Text(
                  context.tr('settings.title'),
                  style: appTextStyle(
                    size: 28,
                    lineHeight: 36,
                    color: AppColors.onSurfaceStrong,
                  ),
                ),
                const SizedBox(height: 32),
                const _ProfileCard(),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    context.tr('settings.general'),
                    style: appTextStyle(
                      size: 14,
                      lineHeight: 20,
                      letterSpacing: 0.1,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _SettingsList(
                  rows: <_SettingsRow>[
                    _SettingsRow(
                      icon: Icons.person_outline,
                      label: context.tr('settings.account'),
                      onTap: () => _open(context, const AccountScreen()),
                    ),
                    _SettingsRow(
                      icon: Icons.language,
                      label: context.tr('settings.language'),
                      onTap: () => _open(context, const LanguagesScreen()),
                    ),
                    _SettingsRow(
                      icon: Icons.help_outline,
                      label: context.tr('settings.help'),
                      onTap: () => _open(context, const HelpScreen()),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(child: _SignOutButton(onTap: () {})),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (BuildContext _) => screen));
  }
}

class _SettingsAppBar extends StatelessWidget {
  const _SettingsAppBar();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/app_logo.png',
                  width: 32,
                  height: 32,
                  filterQuality: FilterQuality.medium,
                  cacheWidth: 96,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.tr('app.name'),
                    style: appTextStyle(
                      size: 28,
                      lineHeight: 36,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 22,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 358x196, 96pt avatar with the name under it
class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: <Widget>[
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 44,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            context.tr('settings.profileName'),
            style: appTextStyle(
              size: 22,
              lineHeight: 28,
              color: AppColors.onSurfaceStrong,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow {
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

/// three 88pt rows with dividers between
class _SettingsList extends StatelessWidget {
  const _SettingsList({required this.rows});

  final List<_SettingsRow> rows;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          for (int i = 0; i < rows.length; i++) ...<Widget>[
            if (i > 0) const Divider(height: 1, indent: 24, endIndent: 24),
            InkWell(
              onTap: rows[i].onTap,
              child: SizedBox(
                height: 88,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.settingsBadge,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          rows[i].icon,
                          size: 20,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Text(
                          rows[i].label,
                          style: appTextStyle(
                            size: 16,
                            lineHeight: 24,
                            letterSpacing: 0.5,
                            color: AppColors.onSurfaceStrong,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 150x46 pill, icon then label
class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.onTap});

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
        decoration: BoxDecoration(
          color: AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: <Widget>[
            const Icon(
              Icons.logout,
              size: 18,
              color: AppColors.onSurfaceVariant,
            ),
            Text(
              context.tr('settings.signOut'),
              style: appTextStyle(
                size: 14,
                lineHeight: 20,
                weight: FontWeight.w500,
                letterSpacing: 0.1,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
