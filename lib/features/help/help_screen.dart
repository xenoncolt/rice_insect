import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/primary_pill_button.dart';
import '../../core/widgets/surface_card.dart';
import '../settings/widgets/settings_app_bar.dart';

/// Node 52:991 (Help).
///
/// Geometry from the node tree: two 358x190 quick-link cards, each with a
/// 128pt decorative disc bleeding off its top-right corner and a 48pt icon
/// badge, then a 358x221 contact box with a filled and an outlined action.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackdrop,
      body: Column(
        children: <Widget>[
          SettingsAppBar(title: context.tr('help.title')),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              children: <Widget>[
                Text(
                  context.tr('help.heading'),
                  style: appTextStyle(
                    size: 16,
                    lineHeight: 24,
                    weight: FontWeight.w500,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 32),
                _QuickLinkCard(
                  icon: Icons.menu_book_outlined,
                  title: context.tr('help.manualTitle'),
                  body: context.tr('help.manualBody'),
                  tint: AppColors.primaryContainer,
                ),
                const SizedBox(height: 16),
                _QuickLinkCard(
                  icon: Icons.play_circle_outline,
                  title: context.tr('help.videosTitle'),
                  body: context.tr('help.videosBody'),
                  tint: AppColors.videoTint,
                ),
                const SizedBox(height: 28),
                const _ContactBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  const _QuickLinkCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.tint,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      clipContents: true,
      color: AppColors.surfaceSubtle.withValues(alpha: 0.7),
      padding: const EdgeInsets.all(25),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          // Node 52:1014 - a 128pt disc hanging off the top-right corner.
          Positioned(
            right: -64,
            top: -56,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: tint,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Icon(icon, size: 22, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: appTextStyle(
                  size: 16,
                  lineHeight: 24,
                  color: AppColors.onSurfaceStrong,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: appTextStyle(
                  size: 16,
                  lineHeight: 24,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactBox extends StatelessWidget {
  const _ContactBox();

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: <Widget>[
              const Icon(
                Icons.support_agent,
                size: 20,
                color: AppColors.primary,
              ),
              Flexible(
                child: Text(
                  context.tr('help.contactTitle'),
                  style: appTextStyle(
                    size: 16,
                    lineHeight: 24,
                    color: AppColors.onSurfaceStrong,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            context.tr('help.contactBody'),
            textAlign: TextAlign.center,
            style: appTextStyle(
              size: 16,
              lineHeight: 24,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          PrimaryPillButton(
            label: context.tr('help.chatSupport'),
            icon: Icons.chat_bubble_outline,
            iconSize: 20,
            height: 49,
            labelStyle: appTextStyle(
              size: 16,
              lineHeight: 24,
              color: AppColors.onPrimary,
            ),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: <Widget>[
                  const Icon(
                    Icons.mail_outline,
                    size: 20,
                    color: AppColors.onSurfaceStrong,
                  ),
                  Flexible(
                    child: Text(
                      context.tr('help.emailSupport'),
                      style: appTextStyle(
                        size: 16,
                        lineHeight: 24,
                        color: AppColors.onSurfaceStrong,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
