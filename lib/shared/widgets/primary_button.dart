import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text_styles.dart';
import 'button_label.dart';

/// Solid brand-coloured call-to-action button.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = AppSizes.buttonHeight,
    this.radius = AppRadius.r18,
    this.enabled = true,
    this.icon,
    this.fontSize = 17,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double radius;
  final bool enabled;

  /// Optional leading icon (inner SVG markup from `AppIcons`).
  final String? icon;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final active = enabled && onPressed != null;
    final shape = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: active ? AppShadows.cta : null,
      ),
      child: Material(
        color: active ? AppColors.primary : AppColors.disabled,
        borderRadius: shape,
        child: InkWell(
          borderRadius: shape,
          onTap: active ? onPressed : null,
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
              child: ButtonLabel(
                label: label,
                icon: icon,
                style: AppTextStyles.button.restyle(fontSize: fontSize),
                iconColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
