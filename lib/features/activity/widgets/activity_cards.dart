import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// shared card shell for the activity lists. #F2F5E9, 16 radius.
class ActivityCard extends StatelessWidget {
  const ActivityCard({
    required this.child,
    this.padding = EdgeInsets.zero,
    this.onTap,
    this.clip = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        clipBehavior: clip ? Clip.antiAlias : Clip.none,
        decoration: BoxDecoration(
          color: AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// the "Pest" / "Healthy" pill
class TypeBadge extends StatelessWidget {
  const TypeBadge({required this.label, required this.pest, super.key});

  final String label;
  final bool pest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: pest ? AppColors.errorContainer : AppColors.scanAccent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: <Widget>[
          Icon(
            pest ? Icons.warning_rounded : Icons.check_circle_outline,
            size: 10,
            color: pest ? AppColors.onErrorContainer : AppColors.onPrimaryContainer,
          ),
          Text(
            label,
            style: appTextStyle(
              size: 12,
              lineHeight: 16,
              letterSpacing: 0.5,
              color: pest
                  ? AppColors.onErrorContainer
                  : AppColors.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class ScanEntry {
  const ScanEntry({
    required this.title,
    required this.pest,
    required this.date,
    required this.block,
  });

  final String title;
  final bool pest;
  final String date;
  final String block;
}

/// 103pt row: thumb, title + badge, date, block
class ScanEntryCard extends StatelessWidget {
  const ScanEntryCard({
    required this.entry,
    required this.pestLabel,
    required this.healthyLabel,
    this.onTap,
    super.key,
  });

  final ScanEntry entry;
  final String pestLabel;
  final String healthyLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ActivityCard(
      onTap: onTap,
      padding: const EdgeInsets.all(17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.photo_outlined,
              size: 24,
              color: AppColors.outline.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        entry.title,
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
                    const SizedBox(width: 8),
                    TypeBadge(
                      label: entry.pest ? pestLabel : healthyLabel,
                      pest: entry.pest,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _MetaRow(icon: Icons.schedule, label: entry.date),
                const SizedBox(height: 3),
                _MetaRow(icon: Icons.place_outlined, label: entry.block),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 13, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: appTextStyle(
              size: 14,
              lineHeight: 20,
              letterSpacing: 0.25,
              color: AppColors.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// timeline entry with the tinted icon badge
class TimelineCard extends StatelessWidget {
  const TimelineCard({
    required this.title,
    required this.body,
    required this.time,
    required this.tint,
    required this.icon,
    required this.iconColor,
    this.badge,
    super.key,
  });

  final String title;
  final String body;
  final String time;
  final Color tint;
  final IconData icon;
  final Color iconColor;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return ActivityCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: appTextStyle(
                    size: 16,
                    lineHeight: 24,
                    weight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: appTextStyle(
                    size: 14,
                    lineHeight: 20,
                    letterSpacing: 0.25,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  spacing: 8,
                  children: <Widget>[
                    if (badge != null)
                      // Flexible or a long badge pushes the time off the card
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.scanAccent.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badge!,
                            style: appTextStyle(
                              size: 12,
                              lineHeight: 16,
                              weight: FontWeight.w500,
                              letterSpacing: 0.5,
                              color: AppColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    Text(
                      time,
                      style: appTextStyle(
                        size: 12,
                        lineHeight: 16,
                        weight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: AppColors.onSurfaceVariant,
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

enum PestRisk { high, moderate, low }

/// photo, risk badge, then the details and an action button
class PestCard extends StatelessWidget {
  const PestCard({
    required this.name,
    required this.time,
    required this.location,
    required this.body,
    required this.risk,
    required this.riskLabel,
    required this.typeLabel,
    required this.action,
    this.onAction,
    super.key,
  });

  final String name;
  final String time;
  final String location;
  final String body;
  final PestRisk risk;
  final String riskLabel;
  final String typeLabel;
  final String action;
  final VoidCallback? onAction;

  Color get _riskFill => switch (risk) {
    PestRisk.high => AppColors.error,
    PestRisk.moderate => AppColors.warning,
    PestRisk.low => AppColors.scanAccent,
  };

  Color get _riskInk =>
      risk == PestRisk.high ? AppColors.onPrimary : AppColors.onSurface;

  @override
  Widget build(BuildContext context) {
    return ActivityCard(
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 192,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: ColoredBox(
                    color: AppColors.surfaceVariant,
                    child: Icon(
                      Icons.pest_control_outlined,
                      size: 48,
                      color: AppColors.outline.withValues(alpha: 0.9),
                    ),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _riskFill,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 6,
                      children: <Widget>[
                        Icon(Icons.warning_rounded, size: 13, color: _riskInk),
                        Text(
                          riskLabel,
                          style: appTextStyle(
                            size: 12,
                            lineHeight: 16,
                            weight: FontWeight.w500,
                            letterSpacing: 0.5,
                            color: _riskInk,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        name,
                        style: appTextStyle(
                          size: 22,
                          lineHeight: 28,
                          weight: FontWeight.w500,
                          color: AppColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: appTextStyle(
                        size: 12,
                        lineHeight: 16,
                        weight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    TypeBadge(label: typeLabel, pest: true),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetaRow(
                        icon: Icons.place_outlined,
                        label: location,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  body,
                  style: appTextStyle(
                    size: 14,
                    lineHeight: 20,
                    letterSpacing: 0.25,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert,
                        size: 18,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      label: action,
                      filled: risk == PestRisk.high,
                      onTap: onAction,
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: appTextStyle(
            size: 14,
            lineHeight: 20,
            weight: FontWeight.w500,
            letterSpacing: 0.1,
            color: filled ? AppColors.onPrimary : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
