import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/segmented_tabs.dart';
import '../../domain/entities/invoice_listing.dart';
import '../cubit/invoices_cubit.dart';
import 'invoice_row.dart';
import 'invoices_summary_card.dart';

/// Billing summary, status tabs and the invoice rows of the current filter.
class InvoicesListBody extends StatelessWidget {
  const InvoicesListBody({super.key, required this.listing});

  final InvoiceListing listing;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<InvoicesCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InvoicesSummaryCard(overview: listing.overview),
        const SizedBox(height: AppSpacing.s16),
        SegmentedTabs(
          labels: [l10n.all, l10n.statusPaid, l10n.statusDue, l10n.statusLate],
          selected: InvoicesCubit.filters.indexOf(state.filter),
          onChanged: context.read<InvoicesCubit>().selectTab,
        ),
        const SizedBox(height: AppSpacing.s16),
        for (final invoice in listing.invoices) ...[
          InvoiceRow(invoice: invoice),
          const SizedBox(height: AppSpacing.s10),
        ],
      ],
    );
  }
}
