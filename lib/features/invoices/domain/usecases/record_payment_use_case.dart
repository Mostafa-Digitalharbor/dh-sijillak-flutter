import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/invoice_detail.dart';
import '../entities/new_payment.dart';
import '../repositories/invoices_repository.dart';

/// A payment to record against the invoice numbered [invoiceNumber].
class RecordPaymentParams extends Equatable {
  const RecordPaymentParams({
    required this.invoiceNumber,
    required this.payment,
  });

  final int invoiceNumber;
  final NewPayment payment;

  @override
  List<Object?> get props => [invoiceNumber, payment];
}

/// Records a payment; the invoice becomes paid once it is settled.
class RecordPaymentUseCase
    implements UseCase<InvoiceDetail, RecordPaymentParams> {
  const RecordPaymentUseCase(this._repository);

  static const String amountField = 'amount';
  static const String invalidCode = 'invalid';

  final InvoicesRepository _repository;

  @override
  Future<Result<InvoiceDetail>> call(RecordPaymentParams params) async {
    if (params.payment.amount <= 0) {
      return const Failed(
        ValidationFailure(fields: {amountField: invalidCode}),
      );
    }
    return _repository.recordPayment(params.invoiceNumber, params.payment);
  }
}
