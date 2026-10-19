import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/icons/app_icon.dart';
import '../../core/theme/app_colors.dart';

/// Rounded-square icon button used in screen headers.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.filled = false,
    this.iconSize = AppSizes.iconMd,
    this.strokeWidth = AppIcon.defaultStroke,
    this.fillIcon = false,
    this.size = AppSizes.iconButton,
  });

  /// Outer width/height ([AppSizes.backButton] for bordered anchors).
  final double size;

  final double iconSize;
  final double strokeWidth;

  /// Draw the icon as filled shapes (the "more" dots) instead of strokes.
  final bool fillIcon;

  /// Inner SVG markup from `AppIcons`.
  final String icon;
  final String label;
  final VoidCallback? onPressed;

  /// Solid primary background (e.g. the "+" action) instead of glass.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppRadius.r14);
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: filled ? AppColors.primary : AppColors.white72,
        shape: RoundedRectangleBorder(
          borderRadius: shape,
          side: filled
              ? BorderSide.none
              : const BorderSide(color: AppColors.glassBorder),
        ),
        child: InkWell(
          borderRadius: shape,
          onTap: onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: AppIcon(
                icon,
                size: iconSize,
                strokeWidth: strokeWidth,
                filled: fillIcon,
                color: filled ? Colors.white : AppColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
