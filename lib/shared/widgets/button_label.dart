import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/icons/app_icon.dart';

/// Centered icon + label used inside the button variants. It scales down
/// instead of overflowing when a translation is longer than the button.
class ButtonLabel extends StatelessWidget {
  const ButtonLabel({
    super.key,
    required this.label,
    required this.style,
    required this.iconColor,
    this.icon,
  });

  final String label;
  final TextStyle style;
  final Color iconColor;

  /// Optional leading icon (inner SVG markup from `AppIcons`).
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            AppIcon(icon!, size: AppSizes.iconMd, color: iconColor),
            const SizedBox(width: AppSpacing.s8),
          ],
          Text(label, style: style),
        ],
      ),
    );
  }
}
