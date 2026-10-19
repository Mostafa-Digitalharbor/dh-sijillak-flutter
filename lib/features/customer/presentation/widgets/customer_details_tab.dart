import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/key_value_row.dart';
import '../../../invoices/presentation/extensions/invoice_dates.dart';
import '../cubit/customer_cubit.dart';

/// The details tab of the profile: contact, registration and account data as
/// label / value rows.
class CustomerDetailsTab extends StatelessWidget {
  const CustomerDetailsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final customer = context.select((CustomerCubit c) => c.state.customer!);
    final l10n = context.l10n;
    final rows = [
      (l10n.mobileNumber, customer.phone, true),
      (l10n.email, customer.email, true),
      (l10n.customerAddress, customer.address, false),
      (l10n.city, customer.city, false),
      (l10n.customerSector, customer.sector, false),
      (l10n.commercialRegNo, customer.commercialRegistration, true),
      (l10n.vatNumber, customer.vatNumber, true),
      (l10n.customerSince, context.dayMonthYear(customer.customerSince), false),
      (l10n.owner, customer.accountOwner, false),
    ];
    return GlassCard(
      radius: AppRadius.r24,
      fill: AppColors.white74,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            KeyValueRow(
              label: rows[i].$1,
              value: rows[i].$2,
              ltrValue: rows[i].$3,
              divider: i < rows.length - 1,
            ),
        ],
      ),
    );
  }
}
