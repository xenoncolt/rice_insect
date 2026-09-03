import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Nodes 67:167 and 62:38 - a 64pt bar with a 32pt back button at x16 and a
/// 28pt title starting at x64. Shared by every settings sub-page.
class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar({required this.title, super.key});

  final String title;

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
          child: Row(
            children: <Widget>[
              const SizedBox(width: 16),
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back, size: 16),
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: appTextStyle(
                    size: 28,
                    lineHeight: 36,
                    weight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
