import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/surface_card.dart';
import '../../pest/pest_details_screen.dart';

/// Node 59:434 - the activity feed. Rows carry placeholder content until the
/// backend lands; the shapes match the Figma frame so real data drops straight
/// in.
class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Flexible so a longer translation shortens rather than
              // overflowing the card.
              Flexible(
                child: Text(
                  context.tr('home.activity.title'),
                  style: AppText.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Text(
                  context.tr('home.activity.viewAll'),
                  style: AppText.body.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _ActivityRow(
            icon: Icons.fact_check_outlined,
            iconColor: AppColors.onSurfaceVariant,
            iconBackground: AppColors.surfaceVariant,
            title: context.tr('home.activity.scansCompleted'),
            subtitle: context.tr('home.activity.scansCompletedTime'),
            showDivider: true,
          ),
          const SizedBox(height: 24),
          _ActivityRow(
            icon: Icons.warning_rounded,
            iconColor: AppColors.error,
            iconBackground: AppColors.errorContainer,
            title: context.tr('home.activity.brownSpotAlert'),
            subtitle: context.tr('home.activity.brownSpotDetail'),
            badge: _Badge(
              label: context.tr('home.badge.actionNeeded'),
              color: AppColors.error,
            ),
            action: _InlineAction(
              label: context.tr('home.activity.viewDetails'),
              color: AppColors.error,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const PestDetailsScreen(),
                ),
              ),
            ),
            showDivider: true,
          ),
          const SizedBox(height: 24),
          _ActivityRow(
            icon: Icons.menu_book,
            iconColor: AppColors.tertiary,
            iconBackground: AppColors.tertiaryContainer,
            title: context.tr('home.activity.pestGuideUpdated'),
            subtitle: context.tr('home.activity.pestGuideDetail'),
            badge: _Badge(
              label: context.tr('home.badge.isNew'),
              color: AppColors.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    this.badge,
    this.action,
    this.showDivider = false,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final Widget? badge;
  final Widget? action;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: showDivider ? 17 : 0),
            decoration: showDivider
                ? const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.divider),
                    ),
                  )
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: Text(title, style: AppText.titleMedium)),
                    if (badge != null) ...<Widget>[
                      const SizedBox(width: 8),
                      badge!,
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: AppText.bodyMuted),
                if (action != null) ...<Widget>[
                  const SizedBox(height: 4),
                  action!,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(label.toUpperCase(), style: AppText.badge),
    );
  }
}

class _InlineAction extends StatelessWidget {
  const _InlineAction({required this.label, required this.color, this.onTap});

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(label, style: AppText.body.copyWith(color: color)),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward, size: 14, color: color),
          ],
        ),
      ),
    );
  }
}
