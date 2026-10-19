import 'package:flutter/material.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/dashed_border_box.dart';
import '../../../../shared/widgets/initials_badge.dart';
import '../constants/auth_dimens.dart';
import '../constants/auth_shadows.dart';
import 'login_preview_bar.dart';
import 'workspace_url_chip.dart';

/// Miniature login page shown on the brand step.
class LoginPreviewCard extends StatelessWidget {
  const LoginPreviewCard({
    super.key,
    required this.hasLogo,
    required this.handle,
  });

  final bool hasLogo;

  /// Workspace handle typed in step 1; a sample is shown while it is empty.
  final String handle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AuthDimens.previewMaxWidth),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AuthDimens.previewPad),
        decoration: BoxDecoration(
          color: AppColors.white60,
          borderRadius: BorderRadius.circular(AppRadius.r28),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: AuthShadows.previewCard,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AuthDimens.previewHeaderPadSide,
                AuthDimens.previewHeaderPadTop,
                AuthDimens.previewHeaderPadSide,
                AuthDimens.previewHeaderPadBottom,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.r20),
              ),
              child: Column(
                children: [
                  if (hasLogo)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InitialsBadge(
                          text: l10n.authDemoBrandInitial,
                          size: AuthDimens.previewMarkSize,
                          radius: AppRadius.r11,
                          background: AppColors.brandSlate,
                          fontSize: AuthDimens.previewMarkFont,
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        Flexible(
                          child: Text(
                            l10n.authDemoBrandName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyBold.restyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    DashedBorderBox(
                      width: AuthDimens.previewLogoSlotWidth,
                      height: AuthDimens.previewLogoSlotHeight,
                      radius: AppRadius.r10,
                      color: AppColors.borderDashed,
                      contentBox: true,
                      child: Center(
                        child: Text(
                          l10n.companyLogo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption,
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.s10),
                  WorkspaceUrlChip(
                    url: AppConfig.workspaceUrl(
                      handle.isEmpty ? l10n.authDemoWorkspaceHandle : handle,
                    ),
                    fontSize: AuthDimens.previewChipFont,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AuthDimens.previewChipPadX,
                      vertical: AuthDimens.previewChipPadY,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AuthDimens.previewBodyPadSide,
                AuthDimens.previewBodyPadTop,
                AuthDimens.previewBodyPadSide,
                AuthDimens.previewBodyPadBottom,
              ),
              child: Column(
                children: [
                  LoginPreviewBar(
                    height: AuthDimens.previewBarHeight,
                    bordered: true,
                  ),
                  SizedBox(height: AppSpacing.s6),
                  LoginPreviewBar(
                    height: AuthDimens.previewBarHeight,
                    bordered: true,
                  ),
                  SizedBox(height: AppSpacing.s6),
                  LoginPreviewBar(
                    height: AuthDimens.previewButtonHeight,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
