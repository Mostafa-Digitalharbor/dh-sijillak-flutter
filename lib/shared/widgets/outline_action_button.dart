import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import 'button_label.dart';

/// Primary-coloured outlined button (secondary CTA beside a [PrimaryButton]).
class OutlineActionButton extends StatelessWidget {
  const OutlineActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = AppSizes.compactButtonHeight,
    this.fontSize = 16,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Optional leading icon (inner SVG markup from `AppIcons`).
  final String? icon;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppRadius.r16);
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: shape,
        side: const BorderSide(
          color: AppColors.primary,
          width: AppSizes.borderMedium,
        ),
      ),
      child: InkWell(
        borderRadius: shape,
        onTap: onPressed,
        child: SizedBox(
          // content-box: the border adds its width on both sides.
          height: height + AppSizes.borderMedium * 2,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
            child: ButtonLabel(
              label: label,
              icon: icon,
              iconColor: AppColors.primary,
              style: AppFonts.tajawal(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
