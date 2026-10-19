import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/initials.dart';
import '../../../../shared/widgets/initials_badge.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../domain/entities/customer_summary.dart';
import '../constants/customer_dimens.dart';
import 'customer_row_card.dart';

/// One row of the customers list: initials badge, name, "city · sector" and
/// the amount due (or the open-deals count when nothing is owed).
class CustomerListTile extends StatelessWidget {
  const CustomerListTile({super.key, required this.customer});

  final CustomerSummary customer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return CustomerRowCard(
      onTap: () => context.push(AppRoutes.customer, extra: customer.id),
      leading: InitialsBadge(
        text: initialsOf(customer.name),
        size: CustomerDimens.rowBadgeSize,
        radius: AppRadius.r14,
        fontSize: CustomerDimens.rowBadgeFont,
      ),
      title: customer.name,
      subtitle: customer.location,
      trailing: customer.amountDue > 0
          ? StatusPill(
              text: l10n.customerDuePill(
                l10n.amountSar(context.amount(customer.amountDue)),
              ),
              background: AppColors.overdueBg,
              foreground: AppColors.error,
            )
          : Text(
              l10n.customerOpenDealsCount(
                context.digits('${customer.openDeals}'),
              ),
              style: AppTextStyles.caption,
            ),
    );
  }
}
