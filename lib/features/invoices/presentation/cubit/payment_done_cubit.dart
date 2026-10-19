import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/invoice_detail.dart';
import '../../domain/entities/payment.dart';
import '../../domain/usecases/get_invoice_use_case.dart';

class PaymentDoneState extends Equatable {
  const PaymentDoneState({
    this.status = ViewStatus.initial,
    this.failure,
    this.invoice,
    this.payment,
  });

  final ViewStatus status;
  final Failure? failure;
  final InvoiceDetail? invoice;

  /// The payment that was just recorded (the invoice's latest one).
  final Payment? payment;

  @override
  List<Object?> get props => [status, failure, invoice, payment];
}

/// Loads the invoice and the payment recorded against it for the
/// confirmation screen.
class PaymentDoneCubit extends Cubit<PaymentDoneState> {
  PaymentDoneCubit(this._getInvoice) : super(const PaymentDoneState());

  final GetInvoiceUseCase _getInvoice;
  int? _number;

  Future<void> load(int number) async {
    _number = number;
    emit(const PaymentDoneState(status: ViewStatus.loading));
    final result = await _getInvoice(number);
    if (isClosed) return;
    result.when(
      success: (invoice) {
        final payment = invoice.latestPayment;
        emit(
          payment == null
              ? const PaymentDoneState(
                  status: ViewStatus.failure,
                  failure: NotFoundFailure(),
                )
              : PaymentDoneState(
                  status: ViewStatus.success,
                  invoice: invoice,
                  payment: payment,
                ),
        );
      },
      error: (failure) =>
          emit(PaymentDoneState(status: ViewStatus.failure, failure: failure)),
    );
  }

  Future<void> reload() async {
    final number = _number;
    if (number != null) await load(number);
  }
}
