import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/currency_amount.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../pipeline/domain/entities/deal_stage.dart';
import '../../../pipeline/presentation/extensions/deal_stage_l10n.dart';
import '../../domain/entities/customer_deal.dart';
import '../constants/customer_dimens.dart';
import '../cubit/customer_cubit.dart';
import 'customer_row_card.dart';
import 'customer_section_list.dart';

/// The deals tab of the profile: stage, title, expected value, probability.
class CustomerDealsTab extends StatelessWidget {
  const CustomerDealsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final section = context.select((CustomerCubit c) => c.state.deals);
    return CustomerSectionList<CustomerDeal>(
      section: section,
      onRetry: context.read<CustomerCubit>().loadDeals,
      emptyText: context.l10n.customerNoDeals,
      itemBuilder: (context, deal) => CustomerRowCard(
        leading: const IconTile(
          icon: AppIcons.funnel,
          size: CustomerDimens.rowIconTile,
          iconSize: CustomerDimens.rowIconSize,
          radius: AppRadius.r14,
        ),
        title: deal.title,
        subtitle: context.l10n.probabilityPct(
          context.digits('${deal.probability}'),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CurrencyAmount(
              amount: deal.value,
              amountStyle: AppTextStyles.bodyBold.restyle(
                fontWeight: FontWeight.w800,
              ),
              currencyStyle: AppTextStyles.caption.restyle(
                fontSize: CustomerDimens.rowCurrencySize,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.s4),
            StatusPill(
              text: deal.stage.localized(context),
              background: deal.stage == DealStage.won
                  ? AppColors.paidBg
                  : AppColors.tint,
              foreground: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
