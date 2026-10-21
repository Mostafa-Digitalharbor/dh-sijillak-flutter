import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/glass_bottom_bar.dart';
import '../../../../shared/widgets/grow_row.dart';
import '../../../../shared/widgets/outline_action_button.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../cubit/customer_cubit.dart';
import '../flows/start_quote_flow.dart';

/// Pinned "create invoice" and "quote" actions of the customer profile.
class CustomerBottomBar extends StatelessWidget {
  const CustomerBottomBar({super.key});

  static const double _fontSize = 16;
  static const double _outlineExtraWidth = AppSizes.borderMedium * 2;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final customerId = context.select(
      (CustomerCubit c) => c.state.customer?.id,
    );
    return GlassBottomBar(
      child: GrowRow(
        items: [
          GrowItem(
            label: l10n.createInvoice,
            fontSize: _fontSize,
            child: PrimaryButton(
              label: l10n.createInvoice,
              height: AppSizes.compactButtonHeight,
              radius: AppRadius.r16,
              fontSize: _fontSize,
              onPressed: () => context.push(AppRoutes.newInvoice),
            ),
          ),
          GrowItem(
            label: l10n.quote,
            fontSize: _fontSize,
            extraWidth: _outlineExtraWidth,
            child: OutlineActionButton(
              label: l10n.quote,
              onPressed: customerId == null
                  ? null
                  : () => startQuoteForCustomer(
                      context,
                      customerId: customerId,
                      skipPickerWhenNoOpenDeals: true,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
