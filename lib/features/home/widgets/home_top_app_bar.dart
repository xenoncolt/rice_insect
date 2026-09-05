import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// figma 59:506. 64pt bar: logo, name, profile. profile is just an icon
/// until there's a real avatar.
///
/// background paints behind the status bar but SafeArea pushes the contents
/// down, otherwise it sits under the clock.
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
                // Expanded here, not Flexible + Spacer. two flex children
                // split the space and the avatar ends up short of the edge.
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
