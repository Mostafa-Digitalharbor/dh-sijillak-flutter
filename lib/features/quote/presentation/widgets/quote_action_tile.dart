import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../constants/quote_dimens.dart';

/// Frosted icon-over-label tile that shares or exports the quote.
class QuoteActionTile extends StatelessWidget {
  const QuoteActionTile({super.key, required this.icon, required this.label});

  /// Inner SVG markup from `AppIcons`.
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppRadius.r16);
    return Material(
      color: AppColors.white75,
      shape: RoundedRectangleBorder(
        borderRadius: shape,
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      child: InkWell(
        borderRadius: shape,
        onTap: () {},
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: QuoteDimens.actionTileHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppIcon(
                  icon,
                  size: QuoteDimens.actionIconSize,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.tajawal(
                    fontSize: QuoteDimens.actionLabelSize,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
