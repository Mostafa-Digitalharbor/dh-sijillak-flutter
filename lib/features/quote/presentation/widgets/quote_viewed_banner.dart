import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/formatting/calendar_days.dart';
import '../../../../shared/formatting/time_l10n.dart';
import '../constants/quote_dimens.dart';

/// Notice that the customer has opened the quote and how long it stays valid.
class QuoteViewedBanner extends StatelessWidget {
  const QuoteViewedBanner({
    super.key,
    required this.viewedAt,
    required this.validUntil,
  });

  final DateTime viewedAt;
  final DateTime validUntil;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final time = context.clockTime(viewedAt);
    final viewed = viewedAt.calendarDaysUntil(DateTime.now()) == 0
        ? l10n.quoteViewedToday(time)
        : l10n.quoteViewedOn(context.shortDate(viewedAt), time);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s14,
        vertical: AppSpacing.s10,
      ),
      decoration: BoxDecoration(
        color: AppColors.tint,
        borderRadius: BorderRadius.circular(AppRadius.r14),
      ),
      child: Row(
        children: [
          const AppIcon(
            AppIcons.eye,
            size: QuoteDimens.bannerIconSize,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Text(
              l10n.quoteViewedBanner(viewed, context.shortDate(validUntil)),
              style: AppTextStyles.captionBold.restyle(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
