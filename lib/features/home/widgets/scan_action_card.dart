import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_pill_button.dart';
import '../../../core/widgets/surface_card.dart';

/// Node 59:419 - the primary call to action. The scanner badge breathes gently
/// so the card reads as the live entry point on the screen.
class ScanActionCard extends StatefulWidget {
  const ScanActionCard({this.onScanPressed, super.key});

  final VoidCallback? onScanPressed;

  @override
  State<ScanActionCard> createState() => _ScanActionCardState();
}

class _ScanActionCardState extends State<ScanActionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat(reverse: true);

  late final Animation<double> _scale = Tween<double>(
    begin: 1,
    end: 1.06,
  ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(41),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ScaleTransition(
            scale: _scale,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.document_scanner_outlined,
                size: 27.5,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            context.tr('home.scan.title'),
            style: AppText.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('home.scan.subtitle'),
            style: AppText.bodyMuted,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          PrimaryPillButton(
            label: context.tr('home.scan.button'),
            icon: Icons.photo_camera_outlined,
            iconSize: 20,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            labelStyle: AppText.body.copyWith(color: AppColors.onPrimary),
            onPressed: widget.onScanPressed,
          ),
        ],
      ),
    );
  }
}
