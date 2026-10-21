import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../../../../shared/widgets/frosted_sheet.dart';
import '../../domain/entities/customer_summary.dart';
import '../cubit/customers_cubit.dart';
import 'customer_picker_sheet_content.dart';

/// Bottom sheet to choose a customer (searchable, with a "new customer"
/// entry). Resolves with the chosen customer, or null when dismissed.
Future<CustomerSummary?> showCustomerPickerSheet(BuildContext context) {
  return showFrostedSheet<CustomerSummary>(
    context,
    builder: (_) => BlocProvider(
      create: (_) => getIt<CustomersCubit>()..load(),
      child: const CustomerPickerSheetContent(),
    ),
  );
}
