import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/customer_dimens.dart';

/// Tinted tile with an icon over a label (call, message, email, location).
class ContactAction extends StatelessWidget {
  const ContactAction({super.key, required this.icon, required this.label});

  /// Inner SVG markup from `AppIcons`.
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.r16);
    return Material(
      color: AppColors.tint,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: () {},
        child: SizedBox(
          height: CustomerDimens.contactHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(
                icon,
                size: CustomerDimens.contactIcon,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.s4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: AppTextStyles.caption.restyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
