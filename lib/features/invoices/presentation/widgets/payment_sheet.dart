import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../../domain/entities/invoice_detail.dart';
import '../cubit/payment_cubit.dart';
import 'frosted_sheet.dart';
import 'payment_sheet_content.dart';

/// Bottom sheet for recording a payment against [invoice].
Future<void> showPaymentSheet(BuildContext context, InvoiceDetail invoice) {
  return showFrostedSheet<void>(
    context,
    builder: (_) => BlocProvider(
      create: (_) => getIt<PaymentCubit>(param1: invoice),
      child: PaymentSheetContent(invoice: invoice),
    ),
  );
}
