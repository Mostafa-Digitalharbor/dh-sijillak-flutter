import 'package:flutter/material.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/auth_dimens.dart';
import '../constants/auth_shadows.dart';
import 'workspace_link_copy_chip.dart';

/// Check badge, "workspace ready" title and the shareable workspace link.
class DoneSuccessHeader extends StatelessWidget {
  const DoneSuccessHeader({super.key, this.workspaceUrl});

  /// Address of the workspace just created; a sample while none exists.
  final String? workspaceUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Container(
          width: AuthDimens.doneBadge,
          height: AuthDimens.doneBadge,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: AuthShadows.doneBadge,
          ),
          child: const Center(
            child: AppIcon(
              AppIcons.check,
              size: AuthDimens.doneBadgeIcon,
              color: Colors.white,
              strokeWidth: 2.4,
            ),
          ),
        ),
        const SizedBox(height: AuthDimens.doneHeaderGap),
        Text(
          l10n.workspaceReady,
          textAlign: TextAlign.center,
          style: AppTextStyles.titleLarge,
        ),
        const SizedBox(height: AppSpacing.s14),
        Text(
          l10n.shareLinkWithTeam,
          textAlign: TextAlign.center,
          style: AppTextStyles.subtitle,
        ),
        const SizedBox(height: AppSpacing.s14),
        WorkspaceLinkCopyChip(
          url:
              workspaceUrl ??
              AppConfig.workspaceUrl(l10n.authDemoWorkspaceHandle),
        ),
      ],
    );
  }
}
