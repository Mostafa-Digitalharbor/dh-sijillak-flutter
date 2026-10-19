import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/customer_summary.dart';
import '../constants/customer_dimens.dart';
import 'customer_list_tile.dart';

/// The customer rows, or a message when there are none to show.
class CustomersListBody extends StatelessWidget {
  const CustomersListBody({
    super.key,
    required this.customers,
    required this.filtered,
  });

  final List<CustomerSummary> customers;

  /// Whether a search is narrowing the list (changes the empty message).
  final bool filtered;

  @override
  Widget build(BuildContext context) {
    if (customers.isEmpty) {
      final l10n = context.l10n;
      return Padding(
        padding: const EdgeInsets.only(top: CustomerDimens.emptyTopSpace),
        child: Text(
          filtered ? l10n.customersNoResults : l10n.customersEmpty,
          textAlign: TextAlign.center,
          style: AppTextStyles.subtitle,
        ),
      );
    }
    return Column(
      children: [
        for (final customer in customers) ...[
          CustomerListTile(customer: customer),
          const SizedBox(height: AppSpacing.s10),
        ],
      ],
    );
  }
}
