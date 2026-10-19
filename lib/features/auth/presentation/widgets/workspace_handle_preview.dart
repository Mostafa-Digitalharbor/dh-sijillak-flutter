import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/dashed_border_box.dart';
import '../constants/auth_dimens.dart';
import '../cubit/company_cubit.dart';

/// Dashed card previewing the address the team will sign in through.
class WorkspaceHandlePreview extends StatelessWidget {
  const WorkspaceHandlePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final handle = context.select((CompanyCubit c) => c.state.previewHandle);
    return DashedBorderBox(
      padding: const EdgeInsets.all(AppSpacing.s14),
      fill: AppColors.white55,
      radius: AppRadius.r18,
      color: AppColors.borderDashed,
      contentBox: true,
      child: Row(
        children: [
          const AppIcon(
            AppIcons.globe,
            size: AuthDimens.handlePreviewIcon,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.teamWillSignInVia,
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  AppConfig.workspaceUrl(handle),
                  textDirection: TextDirection.ltr,
                  style: AppTextStyles.bodyBold.restyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
