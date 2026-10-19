import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/dashed_border_box.dart';
import '../../../../shared/widgets/initials_badge.dart';
import '../constants/auth_dimens.dart';
import '../cubit/registration_cubit.dart';

/// Tappable dashed drop-zone: empty prompt, or the chosen logo mark.
class LogoUploadBox extends StatelessWidget {
  const LogoUploadBox({super.key, required this.hasLogo});

  final bool hasLogo;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: AppColors.white60,
      borderRadius: BorderRadius.circular(AppRadius.r22),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.r22),
        onTap: () => context.read<RegistrationCubit>().edit(
          (d) => d.copyWith(hasLogo: !d.hasLogo),
        ),
        child: DashedBorderBox(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
          radius: AppRadius.r22,
          strokeWidth: AuthDimens.uploadBoxStroke,
          color: AppColors.dashedStrong,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AuthDimens.uploadBoxContentMinHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: hasLogo
                  ? [
                      InitialsBadge(
                        text: l10n.authDemoBrandInitial,
                        size: AuthDimens.logoMarkSize,
                        radius: AuthDimens.logoMarkRadius,
                        background: AppColors.brandSlate,
                        fontSize: AuthDimens.logoMarkFont,
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      Text(
                        l10n.uploadedTapToChange,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.label.restyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ]
                  : [
                      const AppIcon(
                        AppIcons.upload,
                        size: AuthDimens.uploadIcon,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      Text(
                        l10n.uploadLogo,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyBold.restyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      Text(
                        l10n.logoRequirements,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption,
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
