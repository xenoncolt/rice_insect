import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Node 59:506 - 64pt bar carrying the logo, the app name and the profile
/// button. The profile falls back to an icon until an avatar URL exists.
///
/// The surface paints up behind the status bar while [SafeArea] keeps the
/// contents clear of it, so the bar never collides with the system clock.
class HomeTopAppBar extends StatelessWidget {
  const HomeTopAppBar({super.key});

  static const double barHeight = 64;

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
          height: barHeight,
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
                // Expanded, not Flexible plus a Spacer: two flex children
                // would split the free space between them and leave the
                // avatar short of the right edge.
                Expanded(
                  child: Text(
                    context.tr('app.name'),
                    style: AppText.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 20,
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
