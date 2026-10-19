import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import 'quick_action.dart';

/// Row of shortcuts to the "create" screens.
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

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
          onTap: () => context.push(AppRoutes.quote),
        ),
        QuickAction(
          icon: AppIcons.userPlus,
          label: context.l10n.customer,
          onTap: () => context.push(AppRoutes.customer),
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
