import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/failure_snack_bar.dart';
import '../../../pipeline/domain/entities/deal_stage.dart';
import '../../../quote/domain/usecases/create_quote_for_deal_use_case.dart';
import '../../domain/usecases/get_customer_deals_use_case.dart';
import '../models/deal_picker_choice.dart';
import '../widgets/deal_picker_sheet.dart';

/// Starts a quote for customer [customerId]: the user picks one of the
/// customer's open deals (or a new one) and lands on the deal's quote.
///
/// With [skipPickerWhenNoOpenDeals], a customer without open deals goes
/// straight to the new-deal form instead of an almost empty picker.
Future<void> startQuoteForCustomer(
  BuildContext context, {
  required String customerId,
  bool skipPickerWhenNoOpenDeals = false,
}) async {
  if (skipPickerWhenNoOpenDeals) {
    final deals = (await getIt<GetCustomerDealsUseCase>()(customerId))
        .dataOrNull;
    if (!context.mounted) return;
    if (deals != null && deals.every((deal) => deal.stage == DealStage.won)) {
      context.push(AppRoutes.newLead, extra: customerId);
      return;
    }
  }
  final choice = await showDealPickerSheet(context, customerId: customerId);
  if (choice == null || !context.mounted) return;
  switch (choice) {
    case NewDealChoice():
      context.push(AppRoutes.newLead, extra: customerId);
    case ExistingDealChoice(:final deal):
      final result = await getIt<CreateQuoteForDealUseCase>()(deal.id);
      if (!context.mounted) return;
      result.when(
        success: (quote) => context.push(AppRoutes.quote, extra: quote.number),
        error: (failure) => showFailureSnackBar(context, failure),
      );
  }
}
