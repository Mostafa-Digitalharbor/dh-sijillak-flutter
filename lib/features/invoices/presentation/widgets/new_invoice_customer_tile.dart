import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/party_header.dart';
import '../constants/invoices_dimens.dart';

/// Tappable customer selector at the top of a new invoice.
class NewInvoiceCustomerTile extends StatelessWidget {
  const NewInvoiceCustomerTile({super.key, required this.customer});

  static const double _badgeFontSize = 16;

  final String customer;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppRadius.r20);
    return Material(
      color: AppColors.white74,
      shape: RoundedRectangleBorder(
        borderRadius: shape,
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      child: InkWell(
        borderRadius: shape,
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s14),
          child: PartyHeader(
            name: customer,
            eyebrow: context.l10n.customerLabel,
            badgeSize: InvoicesDimens.customerBadge,
            badgeFontSize: _badgeFontSize,
            nameSize: InvoicesDimens.partyNameSize,
            lineGap: AppSpacing.s2,
            trailing: Text(context.l10n.change, style: AppTextStyles.link),
          ),
        ),
      ),
    );
  }
}
