import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/auth_dimens.dart';
import '../constants/auth_shadows.dart';
import '../utils/phone_mask.dart';

/// Phone badge, title and "code sent to the masked number" text of the OTP step.
class OtpIntro extends StatelessWidget {
  const OtpIntro({super.key, required this.phone});

  /// The number as typed on the account step; shown masked.
  final String phone;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        const SizedBox(height: AuthDimens.otpIntroTopGap),
        Container(
          width: AuthDimens.otpBadgeSize,
          height: AuthDimens.otpBadgeSize,
          decoration: BoxDecoration(
            color: AppColors.white80,
            borderRadius: BorderRadius.circular(AppRadius.r22),
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: AuthShadows.otpBadge,
          ),
          child: const Center(
            child: AppIcon(
              AppIcons.phoneDevice,
              size: AuthDimens.otpBadgeIcon,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s10),
        Text(
          l10n.otpTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.title.restyle(fontSize: AuthDimens.otpTitleFont),
        ),
        const SizedBox(height: AppSpacing.s10),
        Text(
          l10n.otpSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.subtitle.restyle(height: 1.6),
        ),
        Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            style: AppTextStyles.subtitle.restyle(height: 1.6),
            children: [
              TextSpan(
                text: '${context.digits(maskPhone(phone))} ',
                style: AppTextStyles.subtitle.restyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Text(
                    l10n.edit,
                    style: AppTextStyles.link.restyle(
                      fontSize: AuthDimens.editFont,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
