import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../../customer/presentation/widgets/customer_row_card.dart';
import '../../../invoices/presentation/extensions/invoice_l10n.dart';
import '../../../invoices/presentation/extensions/invoice_status_style.dart';
import '../../domain/entities/invoice_hit.dart';
import '../constants/search_dimens.dart';
import '../extensions/search_navigation.dart';
import 'amount_status_trailing.dart';

/// An invoice result: number, customer, amount and status pill.
class InvoiceHitRow extends StatelessWidget {
  const InvoiceHitRow({super.key, required this.hit});

  final InvoiceHit hit;

  @override
  Widget build(BuildContext context) {
    return CustomerRowCard(
      onTap: () => context.openSearchResult(AppRoutes.invoice, hit.number),
      leading: const IconTile(
        icon: AppIcons.doc,
        size: SearchDimens.rowIconTile,
        iconSize: SearchDimens.rowIconSize,
        radius: AppRadius.r14,
      ),
      title: hit.customer,
      subtitle: context.l10n.invoiceNo(context.digits('${hit.number}')),
      trailing: AmountStatusTrailing(
        amount: hit.amount,
        status: hit.status.localized(context),
        background: hit.status.background,
        foreground: hit.status.foreground,
      ),
    );
  }
}
