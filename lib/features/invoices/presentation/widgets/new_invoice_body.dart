import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/dashed_action_button.dart';
import '../../domain/entities/invoice_draft.dart';
import '../constants/invoices_dimens.dart';
import '../extensions/invoice_dates.dart';
import 'invoice_info_tile.dart';
import 'new_invoice_customer_tile.dart';
import 'new_invoice_line_card.dart';
import 'new_invoice_totals_card.dart';
import 'removable_line.dart';

/// Customer, issue terms, editable lines and totals of a draft invoice.
class NewInvoiceBody extends StatelessWidget {
  const NewInvoiceBody({
    super.key,
    required this.draft,
    required this.onQuantityChanged,
    required this.onAddProduct,
    required this.onRemoveLine,
  });

  final InvoiceDraft draft;

  /// Called with the line index and the quantity change (+1 / -1).
  final void Function(int index, int delta) onQuantityChanged;

  /// Called when the "add product" button is tapped.
  final VoidCallback onAddProduct;

  /// Called with the index of a line the user swiped away. Lines can only be
  /// removed while more than one is left.
  final ValueChanged<int> onRemoveLine;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NewInvoiceCustomerTile(customer: draft.customer),
        const SizedBox(height: AppSpacing.s14),
        Row(
          children: [
            Expanded(
              child: InvoiceInfoTile(
                label: l10n.issueDate,
                value: context.dateOrToday(draft.issueDate),
              ),
            ),
            const SizedBox(width: AppSpacing.s10),
            Expanded(
              child: InvoiceInfoTile(
                label: l10n.paymentTerms,
                value: l10n.paymentTermsWithinDays(
                  context.digits('${draft.paymentTermsDays}'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s18),
        Text(
          l10n.productsAndServices,
          style: AppTextStyles.title.restyle(
            fontSize: InvoicesDimens.sectionTitleSize,
          ),
        ),
        const SizedBox(height: AppSpacing.s14),
        for (var i = 0; i < draft.lines.length; i++) ...[
          RemovableLine(
            line: draft.lines[i],
            removable: draft.lines.length > 1,
            onRemove: () => onRemoveLine(i),
            child: NewInvoiceLineCard(
              line: draft.lines[i],
              onQuantityChanged: (delta) => onQuantityChanged(i, delta),
            ),
          ),
          const SizedBox(height: AppSpacing.s10),
        ],
        DashedActionButton(
          icon: AppIcons.plus,
          label: l10n.addProduct,
          onPressed: onAddProduct,
          fill: AppColors.white40,
          height: InvoicesDimens.addButtonHeight,
          radius: InvoicesDimens.addButtonRadius,
          iconSize: InvoicesDimens.addIconSize,
          iconStroke: InvoicesDimens.addIconStroke,
          fontSize: InvoicesDimens.addLabelSize,
        ),
        const SizedBox(height: AppSpacing.s14),
        NewInvoiceTotalsCard(totals: draft.totals),
      ],
    );
  }
}
