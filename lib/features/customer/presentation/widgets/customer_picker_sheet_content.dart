import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/frosted_sheet_body.dart';
import '../../../../shared/widgets/sheet_action_tile.dart';
import '../../../../shared/widgets/status_body.dart';
import '../constants/customer_dimens.dart';
import '../cubit/customers_cubit.dart';
import 'customer_pick_tile.dart';
import 'new_customer_sheet.dart';

/// Content of the customer picker sheet: search field, "new customer" entry
/// and the matching customers. Pops the chosen `CustomerSummary`.
class CustomerPickerSheetContent extends StatelessWidget {
  const CustomerPickerSheetContent({super.key});

  Future<void> _createCustomer(BuildContext context) async {
    final created = await showNewCustomerSheet(context);
    if (created != null && context.mounted) {
      Navigator.of(context).pop(created);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CustomersCubit>();
    final state = context.watch<CustomersCubit>().state;
    return FrostedSheetBody(
      title: l10n.customerPickerTitle,
      children: [
        AppTextField(
          hint: l10n.customersSearchHint,
          onChanged: cubit.search,
          height: CustomerDimens.searchFieldHeight,
          fontSize: CustomerDimens.searchFieldFont,
        ),
        const SizedBox(height: AppSpacing.s10),
        SheetActionTile(
          label: l10n.newCustomerAction,
          onTap: () => _createCustomer(context),
        ),
        const SizedBox(height: AppSpacing.s10),
        StatusBody(
          status: state.status,
          failure: state.failure,
          onRetry: cubit.load,
          builder: (_) => state.customers.isEmpty
              ? Text(
                  state.query.isEmpty
                      ? l10n.customersEmpty
                      : l10n.customersNoResults,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle,
                )
              : Column(
                  children: [
                    for (final customer in state.customers) ...[
                      CustomerPickTile(
                        customer: customer,
                        onTap: () => Navigator.of(context).pop(customer),
                      ),
                      const SizedBox(height: AppSpacing.s8),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}
