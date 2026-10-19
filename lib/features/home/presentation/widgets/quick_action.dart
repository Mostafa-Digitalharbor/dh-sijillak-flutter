import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/home_dimens.dart';

/// One shortcut tile: a frosted icon square with a caption underneath.
class QuickAction extends StatelessWidget {
  const QuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  /// Inner SVG markup from `AppIcons`.
  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.r18);
    return Expanded(
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: HomeDimens.quickActionBox,
              height: HomeDimens.quickActionBox,
              decoration: BoxDecoration(
                color: AppColors.white75,
                borderRadius: radius,
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Center(
                child: AppIcon(
                  icon,
                  size: HomeDimens.quickActionIcon,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.captionBold.restyle(
                color: AppColors.textStrong,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
