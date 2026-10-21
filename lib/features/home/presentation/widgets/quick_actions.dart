import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../customer/presentation/flows/start_quote_flow.dart';
import '../../../customer/presentation/widgets/customer_picker_sheet.dart';
import '../../../customer/presentation/widgets/new_customer_sheet.dart';
import 'quick_action.dart';

/// Row of shortcuts to the "create" flows.
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  /// Quote: choose the customer, then one of their deals (or a new one).
  static Future<void> _startQuote(BuildContext context) async {
    final customer = await showCustomerPickerSheet(context);
    if (customer == null || !context.mounted) return;
    await startQuoteForCustomer(context, customerId: customer.id);
  }

  /// Customer: fill the new-customer form, then open the created profile.
  static Future<void> _newCustomer(BuildContext context) async {
    final customer = await showNewCustomerSheet(context);
    if (customer == null || !context.mounted) return;
    context.push(AppRoutes.customer, extra: customer.id);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        QuickAction(
          icon: AppIcons.doc,
          label: context.l10n.invoice,
          onTap: () => context.push(AppRoutes.newInvoice),
        ),
        QuickAction(
          icon: AppIcons.listPlus,
          label: context.l10n.quote,
          onTap: () => _startQuote(context),
        ),
        QuickAction(
          icon: AppIcons.userPlus,
          label: context.l10n.customer,
          onTap: () => _newCustomer(context),
        ),
        QuickAction(
          icon: AppIcons.funnel,
          label: context.l10n.deal,
          onTap: () => context.push(AppRoutes.newLead),
        ),
      ],
    );
  }
}
