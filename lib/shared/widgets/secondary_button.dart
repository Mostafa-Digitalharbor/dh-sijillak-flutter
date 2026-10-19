import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import 'button_label.dart';

/// Frosted button with a hairline border (the quieter of two CTAs).
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = AppSizes.compactButtonHeight,
    this.radius = AppRadius.r18,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w800,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Optional leading icon (inner SVG markup from `AppIcons`).
  final String? icon;
  final double height;
  final double radius;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(radius);
    return Material(
      color: AppColors.white80,
      shape: RoundedRectangleBorder(
        borderRadius: shape,
        side: const BorderSide(color: AppColors.borderButton),
      ),
      child: InkWell(
        borderRadius: shape,
        onTap: onPressed,
        child: SizedBox(
          // content-box: the hairline border adds its width on both sides.
          height: height + AppSizes.borderThin * 2,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
            child: ButtonLabel(
              label: label,
              icon: icon,
              iconColor: AppColors.primary,
              style: AppFonts.tajawal(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
