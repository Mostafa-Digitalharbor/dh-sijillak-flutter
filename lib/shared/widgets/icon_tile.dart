import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/icons/app_icon.dart';
import '../../core/theme/app_colors.dart';

/// A tinted rounded square holding an icon (feature rows, toggles, intros).
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.icon,
    this.size = 40,
    this.iconSize = AppSpacing.s20,
    this.radius = AppRadius.r13,
    this.background = AppColors.tint,
    this.foreground = AppColors.primary,
    this.strokeWidth = 1.8,
  });

  /// Inner SVG markup from `AppIcons`.
  final String icon;
  final double size;
  final double iconSize;
  final double radius;
  final Color background;
  final Color foreground;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: AppIcon(
        icon,
        size: iconSize,
        color: foreground,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
