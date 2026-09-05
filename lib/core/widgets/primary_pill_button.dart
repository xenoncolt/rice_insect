import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'press_scale.dart';

/// the green pill button. every screen uses it, they only differ in size,
/// text style and which side the icon sits on.
class PrimaryPillButton extends StatelessWidget {
  const PrimaryPillButton({
    this.label,
    this.icon,
    this.onPressed,
    this.iconAfterLabel = false,
    this.height,
    this.width = double.infinity,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.iconSize = 12,
    this.labelStyle,
    super.key,
  }) : assert(
         label != null || icon != null,
         'A button needs a label, an icon, or both',
       );

  final String? label;
  final IconData? icon;
  final VoidCallback? onPressed;

  /// login/language put the arrow after the text, scan button leads with it
  final bool iconAfterLabel;

  final double? height;

  /// null = shrink to fit the label
  final double? width;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final Widget? iconWidget = icon == null
        ? null
        : Icon(icon, size: iconSize, color: AppColors.onPrimary);

    final Widget? labelWidget = label == null
        ? null
        : Flexible(
            child: Text(
              label!,
              style:
                  labelStyle ??
                  appTextStyle(
                    size: 14,
                    lineHeight: 20,
                    weight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: AppColors.onPrimary,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );

    final List<Widget> children = <Widget>[
      if (!iconAfterLabel) ?iconWidget,
      ?labelWidget,
      if (iconAfterLabel) ?iconWidget,
    ];

    return PressScale(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(999),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: children,
        ),
      ),
    );
  }
}
