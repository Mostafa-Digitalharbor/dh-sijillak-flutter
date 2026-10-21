import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../../customer/presentation/widgets/customer_row_card.dart';
import '../../../pipeline/presentation/extensions/deal_stage_l10n.dart';
import '../../domain/entities/deal_hit.dart';
import '../constants/search_dimens.dart';
import '../extensions/search_navigation.dart';
import 'amount_status_trailing.dart';

/// A deal result: title, customer, value and stage pill. Opens the customer.
class DealHitRow extends StatelessWidget {
  const DealHitRow({super.key, required this.hit});

  final DealHit hit;

  @override
  Widget build(BuildContext context) {
    return CustomerRowCard(
      onTap: () => context.openSearchResult(AppRoutes.customer, hit.customerId),
      leading: const IconTile(
        icon: AppIcons.funnel,
        size: SearchDimens.rowIconTile,
        iconSize: SearchDimens.rowIconSize,
        radius: AppRadius.r14,
      ),
      title: hit.title,
      subtitle: hit.customerName,
      trailing: AmountStatusTrailing(
        amount: hit.value,
        status: hit.stage.localized(context),
        background: AppColors.tint,
        foreground: AppColors.primary,
      ),
    );
  }
}
