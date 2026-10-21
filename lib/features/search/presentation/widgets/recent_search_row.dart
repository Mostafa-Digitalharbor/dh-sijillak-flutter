import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../constants/search_dimens.dart';

/// One remembered query; tapping it searches again.
class RecentSearchRow extends StatelessWidget {
  const RecentSearchRow({super.key, required this.query, required this.onTap});

  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: query,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: GlassCard(
          padding: const EdgeInsets.all(AppSpacing.s14),
          radius: AppRadius.r16,
          fill: AppColors.white74,
          shadow: false,
          child: Row(
            children: [
              const AppIcon(
                AppIcons.clock,
                size: SearchDimens.recentIconSize,
                color: AppColors.textSubtle,
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Text(
                  query,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
