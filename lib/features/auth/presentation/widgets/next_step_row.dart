import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/auth_dimens.dart';

/// Numbered "next step" row with a trailing chevron.
class NextStepRow extends StatelessWidget {
  const NextStepRow({
    super.key,
    required this.number,
    required this.text,
    this.showDivider = false,
  });

  /// Already localised step number.
  final String number;
  final String text;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.borderSoft))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: AuthDimens.stepCircle,
              height: AuthDimens.stepCircle,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.tint,
                shape: BoxShape.circle,
              ),
              child: Text(
                number,
                style: AppTextStyles.link.restyle(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(child: Text(text, style: AppTextStyles.bodyBold)),
            const AppIcon(
              AppIcons.chevronLeft,
              size: AuthDimens.stepChevron,
              color: AppColors.navInactive,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
