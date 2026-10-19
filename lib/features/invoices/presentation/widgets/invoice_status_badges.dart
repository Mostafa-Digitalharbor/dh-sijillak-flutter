import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/formatting/time_l10n.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../domain/entities/invoice_detail.dart';
import '../../domain/entities/invoice_summary.dart';
import '../constants/invoices_dimens.dart';
import '../extensions/invoice_l10n.dart';
import '../extensions/invoice_status_style.dart';

/// Payment-status and e-invoicing (Fatoora) pills under the invoice header.
class InvoiceStatusBadges extends StatelessWidget {
  const InvoiceStatusBadges({super.key, required this.invoice});

  final InvoiceDetail invoice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = invoice.status;
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: [
        StatusPill(
          text: _statusText(context),
          background: status.background,
          foreground: status.foreground,
          fontSize: InvoicesDimens.pillFontSize,
          padding: InvoicesDimens.pillPadding,
        ),
        StatusPill(
          text: l10n.reportedToFatoora,
          background: AppColors.paidBg,
          foreground: AppColors.primary,
          fontSize: InvoicesDimens.pillFontSize,
          icon: AppIcons.check,
          padding: InvoicesDimens.pillPadding,
        ),
      ],
    );
  }

  String _statusText(BuildContext context) {
    final now = DateTime.now();
    switch (invoice.status) {
      case InvoiceStatus.paid:
        return invoice.status.localized(context);
      case InvoiceStatus.late:
        return context.overdueSince(invoice.dueDate, now: now);
      case InvoiceStatus.due:
        final days = invoice.daysUntilDue(now);
        return context.l10n.dueInDaysCount(days, context.digits('$days'));
    }
  }
}
