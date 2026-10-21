import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../../../../shared/widgets/frosted_sheet.dart';
import '../../domain/entities/customer_summary.dart';
import '../cubit/new_customer_cubit.dart';
import 'new_customer_sheet_content.dart';

/// Bottom sheet with the new-customer form. Resolves with the created
/// customer, or null when dismissed.
Future<CustomerSummary?> showNewCustomerSheet(BuildContext context) {
  return showFrostedSheet<CustomerSummary>(
    context,
    builder: (_) => BlocProvider(
      create: (_) => getIt<NewCustomerCubit>(),
      child: const NewCustomerSheetContent(),
    ),
  );
}
