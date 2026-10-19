import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/currency_amount.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../invoices/presentation/extensions/invoice_dates.dart';
import '../../../invoices/presentation/extensions/invoice_l10n.dart';
import '../../../invoices/presentation/extensions/invoice_status_style.dart';
import '../../domain/entities/customer_invoice.dart';
import '../constants/customer_dimens.dart';
import '../cubit/customer_cubit.dart';
import 'customer_row_card.dart';
import 'customer_section_list.dart';

/// The invoices tab of the profile: number, date, amount and status. Tapping
/// a row opens the invoice.
class CustomerInvoicesTab extends StatelessWidget {
  const CustomerInvoicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final section = context.select((CustomerCubit c) => c.state.invoices);
    return CustomerSectionList<CustomerInvoice>(
      section: section,
      onRetry: context.read<CustomerCubit>().loadInvoices,
      emptyText: context.l10n.customerNoInvoices,
      itemBuilder: (context, invoice) => CustomerRowCard(
        onTap: () => context.push(AppRoutes.invoice, extra: invoice.number),
        leading: const IconTile(
          icon: AppIcons.doc,
          size: CustomerDimens.rowIconTile,
          iconSize: CustomerDimens.rowIconSize,
          radius: AppRadius.r14,
        ),
        title: context.l10n.customerInvoiceTitle(
          context.digits('${invoice.number}'),
        ),
        subtitle: context.dayMonthYear(invoice.date),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CurrencyAmount(
              amount: invoice.amount,
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
              text: invoice.status.localized(context),
              background: invoice.status.background,
              foreground: invoice.status.foreground,
            ),
          ],
        ),
      ),
    );
  }
}
