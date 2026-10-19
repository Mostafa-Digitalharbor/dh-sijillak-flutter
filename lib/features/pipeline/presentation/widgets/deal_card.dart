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
import '../../../../core/utils/initials.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/initials_badge.dart';
import '../../domain/entities/deal.dart';
import '../extensions/deal_text.dart';
import '../constants/pipeline_dimens.dart';

/// Card for one deal: title, customer, value, win probability, next step and
/// owner.
class DealCard extends StatelessWidget {
  const DealCard({super.key, required this.deal});

  final Deal deal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.customer, extra: deal.customerId),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.s16),
        radius: AppRadius.r20,
        fill: AppColors.white74,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TitleAndValue(deal: deal),
            const SizedBox(height: AppSpacing.s12),
            _ProbabilityRow(probability: deal.probability),
            const SizedBox(height: AppSpacing.s12),
            _NextActionRow(deal: deal),
          ],
        ),
      ),
    );
  }
}

class _TitleAndValue extends StatelessWidget {
  const _TitleAndValue({required this.deal});

  final Deal deal;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deal.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyBold.restyle(
                  fontSize: PipelineDimens.dealTitleFont,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.s2),
              Text(
                deal.customerName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.subtitle.restyle(
                  fontSize: PipelineDimens.dealCustomerFont,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s10),
        Text.rich(
          TextSpan(
            text: context.amount(deal.value),
            style: AppTextStyles.title.restyle(
              fontSize: PipelineDimens.dealValueFont,
              color: AppColors.primary,
            ),
            children: [
              TextSpan(
                text: context.l10n.sarSpaced,
                style: AppTextStyles.caption.restyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProbabilityRow extends StatelessWidget {
  const _ProbabilityRow({required this.probability});

  final int probability;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: probability / 100,
              minHeight: PipelineDimens.dealProgressHeight,
              backgroundColor: AppColors.borderSoft,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s10),
        Text(
          context.l10n.probabilityPct(context.digits('$probability')),
          maxLines: 1,
          style: AppTextStyles.caption.restyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textStrong,
          ),
        ),
      ],
    );
  }
}

class _NextActionRow extends StatelessWidget {
  const _NextActionRow({required this.deal});

  final Deal deal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppIcon(
          AppIcons.clock,
          size: AppSizes.iconSm,
          color: AppColors.textSubtle,
        ),
        const SizedBox(width: AppSpacing.s8),
        Expanded(
          child: Text(
            context.nextStepOf(deal, now: DateTime.now()),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.subtitle.restyle(
              fontSize: PipelineDimens.dealNextActionFont,
              color: AppColors.textSubtle,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s8),
        InitialsBadge(
          text: initialsOf(deal.ownerName, maxLetters: 1),
          size: PipelineDimens.ownerBadge,
          fontSize: PipelineDimens.ownerBadgeFont,
          background: AppColors.tint,
          foreground: AppColors.primary,
        ),
      ],
    );
  }
}
