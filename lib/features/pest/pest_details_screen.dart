import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/primary_pill_button.dart';

/// figma 50:727
///
/// built off the render, not exact node values (hit the figma api limit that
/// day), so spacing follows the token scale. worth re-checking against the
/// file at some point.
///
/// hero shows the scan photo if there is one, placeholder if not.
class PestDetailsScreen extends StatelessWidget {
  const PestDetailsScreen({this.imagePath, super.key});

  /// photo this result came from
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackdrop,
      body: Column(
        children: <Widget>[
          _header(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _HeroImage(imagePath: imagePath),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          context.tr('pest.name'),
                          style: appTextStyle(
                            size: 28,
                            lineHeight: 36,
                            weight: FontWeight.w500,
                            color: AppColors.onSurfaceStrong,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.tr('pest.scientificName'),
                          style: appTextStyle(
                            size: 14,
                            lineHeight: 20,
                            color: AppColors.onSurfaceVariant,
                          ).copyWith(fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 16),
                        _SoftCard(
                          child: Text(
                            context.tr('pest.summary'),
                            style: appTextStyle(
                              size: 14,
                              lineHeight: 20,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        _SectionHeading(
                          icon: Icons.medical_services,
                          label: context.tr('pest.treatmentGuide'),
                        ),
                        const SizedBox(height: 16),
                        _TreatmentStep(
                          number: 1,
                          active: true,
                          title: context.tr('pest.step1Title'),
                          body: context.tr('pest.step1Body'),
                        ),
                        _TreatmentStep(
                          number: 2,
                          title: context.tr('pest.step2Title'),
                          body: context.tr('pest.step2Body'),
                        ),
                        _TreatmentStep(
                          number: 3,
                          isLast: true,
                          title: context.tr('pest.step3Title'),
                          body: context.tr('pest.step3Body'),
                        ),
                        const SizedBox(height: 16),
                        _SectionHeading(
                          icon: Icons.shield,
                          iconColor: AppColors.onSurfaceVariant,
                          label: context.tr('pest.preventiveMeasures'),
                        ),
                        const SizedBox(height: 16),
                        _MeasureCard(
                          icon: Icons.eco_outlined,
                          title: context.tr('pest.measure1Title'),
                          body: context.tr('pest.measure1Body'),
                        ),
                        const SizedBox(height: 12),
                        _MeasureCard(
                          icon: Icons.science_outlined,
                          title: context.tr('pest.measure2Title'),
                          body: context.tr('pest.measure2Body'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _actionBar(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back, size: 20),
                color: AppColors.primary,
              ),
              // Expanded, not Spacer + Flexible. otherwise the title stops
              // short of the right edge.
              Expanded(
                child: Text(
                  context.tr('pest.title'),
                  textAlign: TextAlign.right,
                  style: appTextStyle(
                    size: 22,
                    lineHeight: 28,
                    weight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            PrimaryPillButton(
              label: context.tr('pest.askGemini'),
              height: 48,
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
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: <Widget>[
                    const Icon(
                      Icons.share_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    Text(
                      context.tr('pest.shareReport'),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// scan photo with the risk badge on it, or a tinted panel if there's no
/// image yet.
class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final String? path = imagePath;

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (path == null)
            const _HeroPlaceholder()
          else
            Image.file(
              File(path),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const _HeroPlaceholder(),
            ),
          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: <Widget>[
                  const Icon(
                    Icons.warning_rounded,
                    size: 14,
                    color: AppColors.error,
                  ),
                  Text(
                    context.tr('pest.highRisk'),
                    style: appTextStyle(
                      size: 12,
                      lineHeight: 16,
                      weight: FontWeight.w500,
                      color: AppColors.error,
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

class _SoftCard extends StatelessWidget {
  const _SoftCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.4)),
      ),
      child: child,
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.icon,
    required this.label,
    this.iconColor = AppColors.primary,
  });

  final IconData icon;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: <Widget>[
        Icon(icon, size: 20, color: iconColor),
        Flexible(
          child: Text(
            label,
            style: appTextStyle(
              size: 22,
              lineHeight: 28,
              weight: FontWeight.w500,
              color: AppColors.onSurfaceStrong,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// numbered step with the line joining it to the next one
class _TreatmentStep extends StatelessWidget {
  const _TreatmentStep({
    required this.number,
    required this.title,
    required this.body,
    this.active = false,
    this.isLast = false,
  });

  final int number;
  final String title;
  final String body;
  final bool active;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.primaryContainer
                      : AppColors.surfaceBackdrop,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: active ? AppColors.primary : AppColors.outline,
                  ),
                ),
                child: Text(
                  '$number',
                  style: appTextStyle(
                    size: 12,
                    lineHeight: 16,
                    weight: FontWeight.w500,
                    color: active
                        ? AppColors.onPrimaryContainer
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              if (!isLast)
                const Expanded(
                  child: VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: AppColors.outline,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: _SoftCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: appTextStyle(
                        size: 14,
                        lineHeight: 20,
                        weight: FontWeight.w500,
                        color: AppColors.onSurfaceStrong,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: appTextStyle(
                        size: 14,
                        lineHeight: 20,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeasureCard extends StatelessWidget {
  const _MeasureCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            spacing: 8,
            children: <Widget>[
              Icon(icon, size: 16, color: AppColors.onSurfaceStrong),
              Flexible(
                child: Text(
                  title,
                  style: appTextStyle(
                    size: 14,
                    lineHeight: 20,
                    weight: FontWeight.w500,
                    color: AppColors.onSurfaceStrong,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: appTextStyle(
              size: 14,
              lineHeight: 20,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primaryContainer,
      child: Icon(
        Icons.pest_control_outlined,
        size: 56,
        color: AppColors.primary.withValues(alpha: 0.35),
      ),
    );
  }
}
