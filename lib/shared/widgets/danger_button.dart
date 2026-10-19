import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import 'button_label.dart';

/// Destructive action button: outlined in the error colour by default, solid
/// when [filled] (the confirm button of a destructive dialog).
class DangerButton extends StatelessWidget {
  const DangerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = false,
    this.height = AppSizes.compactButtonHeight,
    this.fontSize = 16,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppRadius.r18);
    final foreground = filled ? Colors.white : AppColors.error;
    return Material(
      color: filled ? AppColors.error : AppColors.white80,
      shape: RoundedRectangleBorder(
        borderRadius: shape,
        side: BorderSide(
          color: AppColors.error,
          width: filled ? 0 : AppSizes.borderMedium,
        ),
      ),
      child: InkWell(
        borderRadius: shape,
        onTap: onPressed,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
            child: ButtonLabel(
              label: label,
              iconColor: foreground,
              style: AppFonts.tajawal(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
