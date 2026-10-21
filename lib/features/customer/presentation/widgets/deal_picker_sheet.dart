import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../../../../shared/widgets/frosted_sheet.dart';
import '../cubit/deal_picker_cubit.dart';
import '../models/deal_picker_choice.dart';
import 'deal_picker_sheet_content.dart';

/// Bottom sheet listing the open deals of customer [customerId], with a
/// "new deal" entry. Resolves with the choice, or null when dismissed.
Future<DealPickerChoice?> showDealPickerSheet(
  BuildContext context, {
  required String customerId,
}) {
  return showFrostedSheet<DealPickerChoice>(
    context,
    builder: (_) => BlocProvider(
      create: (_) => DealPickerCubit(getIt(), customerId)..load(),
      child: const DealPickerSheetContent(),
    ),
  );
}
