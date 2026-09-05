import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/primary_pill_button.dart';
import '../pest/pest_details_screen.dart';
import '../settings/widgets/settings_app_bar.dart';
import 'widgets/activity_cards.dart';

/// figma 1:17630. hero with the detection box, diagnosis card with the
/// confidence ring, actions, then the metadata rows.
class ScanDetailScreen extends StatelessWidget {
  const ScanDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackdrop,
      body: Column(
        children: <Widget>[
          SettingsAppBar(title: context.tr('scanDetail.title')),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              children: <Widget>[
                _hero(context),
                const SizedBox(height: 32),
                _diagnosisCard(context),
                const SizedBox(height: 24),
                _actionsCard(context),
                const SizedBox(height: 24),
                _detailsCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// scan photo with a fake bounding box drawn on it
  Widget _hero(BuildContext context) {
    return Container(
      height: 268,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Icon(
              Icons.photo_outlined,
              size: 56,
              color: AppColors.outline.withValues(alpha: 0.9),
            ),
          ),
          Positioned(
            left: 142,
            top: 80,
            child: SizedBox(
              width: 128,
              height: 152,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 128,
                    height: 124,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.error, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      context.tr('scanDetail.detected'),
                      style: appTextStyle(
                        size: 12,
                        lineHeight: 16,
                        letterSpacing: 0.5,
                        color: AppColors.onPrimary,
                      ),
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

  /// confidence ring + diagnosis
  Widget _diagnosisCard(BuildContext context) {
    return ActivityCard(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                const Positioned.fill(
                  child: CircularProgressIndicator(
                    value: 0.98,
                    strokeWidth: 7,
                    backgroundColor: AppColors.progressTrack,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      context.tr('scanDetail.accuracyValue'),
                      style: appTextStyle(
                        size: 22,
                        lineHeight: 28,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      context.tr('scanDetail.accuracy'),
                      style: appTextStyle(
                        size: 12,
                        lineHeight: 16,
                        letterSpacing: 0.5,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: <Widget>[
                const Icon(
                  Icons.warning_rounded,
                  size: 13,
                  color: AppColors.onErrorContainer,
                ),
                Text(
                  context.tr('scanDetail.pestDetected'),
                  style: appTextStyle(
                    size: 12,
                    lineHeight: 16,
                    letterSpacing: 0.5,
                    color: AppColors.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('pest.name'),
            textAlign: TextAlign.center,
            style: appTextStyle(
              size: 28,
              lineHeight: 36,
              color: AppColors.onSurfaceStrong,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('pest.scientificName'),
            style: appTextStyle(
              size: 14,
              lineHeight: 20,
              letterSpacing: 0.25,
              color: AppColors.onSurfaceVariant,
            ).copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  /// white card, two follow-up buttons
  Widget _actionsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.tr('scanDetail.recommendedActions'),
            style: appTextStyle(
              size: 22,
              lineHeight: 28,
              color: AppColors.onSurfaceStrong,
            ),
          ),
          const SizedBox(height: 16),
          PrimaryPillButton(
            label: context.tr('scanDetail.askAi'),
            icon: Icons.auto_awesome,
            iconSize: 18,
            height: 48,
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const PestDetailsScreen(),
              ),
            ),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                context.tr('scanDetail.treatmentGuide'),
                style: appTextStyle(
                  size: 14,
                  lineHeight: 20,
                  weight: FontWeight.w500,
                  letterSpacing: 0.1,
                  color: AppColors.onSurfaceStrong,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// date / location / device rows
  Widget _detailsCard(BuildContext context) {
    return ActivityCard(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.tr('scanDetail.detailsTitle'),
            style: appTextStyle(
              size: 22,
              lineHeight: 28,
              color: AppColors.onSurfaceStrong,
            ),
          ),
          const SizedBox(height: 16),
          _row(context, 'scanDetail.dateLabel', 'scanDetail.dateValue'),
          const Divider(height: 24),
          _row(context, 'scanDetail.locationLabel', 'scanDetail.locationValue'),
          const Divider(height: 24),
          _row(context, 'scanDetail.deviceLabel', 'scanDetail.deviceValue'),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String labelKey, String valueKey) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            context.tr(labelKey),
            style: appTextStyle(
              size: 14,
              lineHeight: 20,
              letterSpacing: 0.25,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Text(
            context.tr(valueKey),
            textAlign: TextAlign.right,
            style: appTextStyle(
              size: 14,
              lineHeight: 20,
              weight: FontWeight.w500,
              letterSpacing: 0.25,
              color: AppColors.onSurfaceStrong,
            ),
          ),
        ),
      ],
    );
  }
}
