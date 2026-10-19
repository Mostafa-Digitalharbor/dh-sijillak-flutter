import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/home_summary.dart';
import '../constants/home_dimens.dart';
import '../cubit/home_cubit.dart';
import 'sales_bars.dart';

/// Hero card with this month's sales, its growth badge and a mini bar chart.
class SalesCard extends StatelessWidget {
  const SalesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final summary = context.select((HomeCubit c) => c.state.overview!.summary);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        boxShadow: HomeDimens.salesShadow,
      ),
      child: Stack(
        children: [
          const _GlowBlob(),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s18),
            child: _SalesContent(summary: summary),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: HomeDimens.salesGlowTop,
      left: HomeDimens.salesGlowLeft,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: HomeDimens.salesGlowBlur,
          sigmaY: HomeDimens.salesGlowBlur,
        ),
        child: Container(
          width: HomeDimens.salesGlowSize,
          height: HomeDimens.salesGlowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent.withValues(
              alpha: HomeDimens.salesGlowAlpha,
            ),
          ),
        ),
      ),
    );
  }
}

class _SalesContent extends StatelessWidget {
  const _SalesContent({required this.summary});

  final HomeSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.salesThisMonth,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.subtitle.restyle(
                  color: AppColors.onPrimaryMuted,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s10,
                vertical: AppSpacing.s4,
              ),
              decoration: BoxDecoration(
                color: AppColors.white16,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                context.l10n.salesGrowthBadge(
                  context.digits('${summary.salesGrowthPercent}'),
                ),
                style: AppTextStyles.captionBold.restyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s14),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                context.amount(summary.monthlySales),
                style: AppTextStyles.titleLarge.restyle(
                  fontSize: HomeDimens.salesAmountFont,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: AppSpacing.s6),
              Text(
                context.l10n.sar,
                style: AppTextStyles.subtitle.restyle(
                  fontSize: HomeDimens.salesCurrencyFont,
                  color: AppColors.onPrimaryMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s14),
        SalesBars(values: summary.salesBarFractions),
      ],
    );
  }
}
