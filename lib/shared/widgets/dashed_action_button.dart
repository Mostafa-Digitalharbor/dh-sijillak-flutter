import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/icons/app_icon.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import 'dashed_border_box.dart';

/// Tappable dashed-outline button with a leading icon ("add product",
/// "attach receipt"). The label may wrap on narrow screens.
class DashedActionButton extends StatelessWidget {
  const DashedActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.height,
    required this.radius,
    required this.iconSize,
    required this.fontSize,
    this.iconStroke = AppIcon.defaultStroke,
    this.fill = Colors.transparent,
  });

  /// Inner SVG markup from `AppIcons`.
  final String icon;
  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double radius;
  final double iconSize;
  final double iconStroke;
  final double fontSize;

  /// Background inside the dashed outline.
  final Color fill;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(radius);
    return Material(
      color: fill,
      borderRadius: shape,
      child: InkWell(
        borderRadius: shape,
        onTap: onPressed,
        child: DashedBorderBox(
          height: height,
          radius: radius,
          strokeWidth: AppSizes.borderMedium,
          color: AppColors.dashedStrong,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppIcon(
                  icon,
                  size: iconSize,
                  color: AppColors.primary,
                  strokeWidth: iconStroke,
                ),
                const SizedBox(width: AppSpacing.s6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.tajawal(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
