import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';

/// Stand-in for destinations whose Figma frames are not built yet.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.titleKey, super.key});

  final String titleKey;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(context.tr(titleKey), style: AppText.titleMedium),
          const SizedBox(height: 4),
          Text(context.tr('placeholder.comingSoon'), style: AppText.bodyMuted),
        ],
      ),
    );
  }
}
