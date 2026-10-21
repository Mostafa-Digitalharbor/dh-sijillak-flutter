import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/initials.dart';
import '../../../../shared/widgets/initials_badge.dart';
import '../../../../shared/widgets/picker_tile.dart';
import '../../domain/entities/customer_summary.dart';
import '../constants/customer_dimens.dart';

/// One customer in the customer picker: initials, name and location.
class CustomerPickTile extends StatelessWidget {
  const CustomerPickTile({
    super.key,
    required this.customer,
    required this.onTap,
  });

  final CustomerSummary customer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PickerTile(
      title: customer.name,
      subtitle: customer.location.isEmpty ? null : customer.location,
      onTap: onTap,
      leading: InitialsBadge(
        text: initialsOf(customer.name),
        size: CustomerDimens.pickBadgeSize,
        radius: AppRadius.r12,
        fontSize: CustomerDimens.pickBadgeFont,
      ),
    );
  }
}
