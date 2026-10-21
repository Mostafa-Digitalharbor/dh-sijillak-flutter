import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/home_dimens.dart';

/// Frosted global search box at the top of the dashboard. It is a read-only
/// pill: tapping anywhere on it opens the search screen.
class HomeSearchField extends StatelessWidget {
  const HomeSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.search,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.push(AppRoutes.search),
        child: Container(
          height: HomeDimens.searchHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s14),
          decoration: BoxDecoration(
            color: AppColors.white72,
            borderRadius: BorderRadius.circular(AppRadius.r16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            children: [
              const AppIcon(
                AppIcons.search,
                size: AppSizes.iconMd,
                color: AppColors.navInactive,
              ),
              const SizedBox(width: AppSpacing.s10),
              Expanded(
                child: Text(
                  context.l10n.searchHint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subtitle.restyle(
                    color: AppColors.navInactive,
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
