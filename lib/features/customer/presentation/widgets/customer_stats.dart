import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../constants/customer_constants.dart';
import '../cubit/customer_cubit.dart';
import 'customer_stat_tile.dart';

/// Three headline figures: total sales, amount due and open deals.
class CustomerStats extends StatelessWidget {
  const CustomerStats({super.key});

  @override
  Widget build(BuildContext context) {
    final customer = context.select((CustomerCubit c) => c.state.customer!);
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: CustomerStatTile(
            label: l10n.totalSales,
            value: l10n.amountThousands(
              context.digits(
                '${(customer.totalSales / CustomerConstants.salesUnit).round()}',
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s10),
        Expanded(
          child: CustomerStatTile(
            label: l10n.amountDue,
            value: context.amount(customer.amountDue),
            valueColor: AppColors.overdue,
          ),
        ),
        const SizedBox(width: AppSpacing.s10),
        Expanded(
          child: CustomerStatTile(
            label: l10n.openDeals,
            value: context.digits('${customer.openDeals}'),
          ),
        ),
      ],
    );
  }
}
