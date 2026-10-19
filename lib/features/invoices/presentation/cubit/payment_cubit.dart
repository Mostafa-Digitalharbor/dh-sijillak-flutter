import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/invoice_detail.dart';
import '../../domain/entities/new_payment.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/usecases/record_payment_use_case.dart';
import '../utils/amount_input.dart';

class PaymentState extends Equatable {
  const PaymentState({
    required this.date,
    this.method = PaymentMethod.bankTransfer,
    this.hasReceipt = false,
    this.status = ViewStatus.initial,
    this.failure,
    this.recorded,
  });

  final PaymentMethod method;
  final DateTime date;
  final bool hasReceipt;
  final ViewStatus status;
  final Failure? failure;

  /// The invoice after a successful payment.
  final InvoiceDetail? recorded;

  bool get isSubmitting => status.isLoading;

  PaymentState copyWith({
    PaymentMethod? method,
    DateTime? date,
    bool? hasReceipt,
  }) => PaymentState(
    method: method ?? this.method,
    date: date ?? this.date,
    hasReceipt: hasReceipt ?? this.hasReceipt,
    status: status,
    failure: failure,
    recorded: recorded,
  );

  PaymentState withResult({
    required ViewStatus status,
    Failure? failure,
    InvoiceDetail? recorded,
  }) => PaymentState(
    method: method,
    date: date,
    hasReceipt: hasReceipt,
    status: status,
    failure: failure,
    recorded: recorded,
  );

  @override
  List<Object?> get props => [
    method,
    date,
    hasReceipt,
    status,
    failure,
    recorded,
  ];
}

/// State of the record-payment sheet for one invoice.
class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(
    this._recordPayment, {
    required this.invoice,
    DateTime Function()? clock,
  }) : super(PaymentState(date: _today((clock ?? DateTime.now)())));

  final RecordPaymentUseCase _recordPayment;
  final InvoiceDetail invoice;

  static DateTime _today(DateTime now) =>
      DateTime(now.year, now.month, now.day);

  void select(PaymentMethod method) => emit(state.copyWith(method: method));

  void pickDate(DateTime date) => emit(state.copyWith(date: date));

  void toggleReceipt() => emit(state.copyWith(hasReceipt: !state.hasReceipt));

  /// Records the typed [amountText] and [reference] with the chosen method,
  /// date and receipt flag.
  Future<void> submit({
    required String amountText,
    required String reference,
  }) async {
    if (state.isSubmitting) return;
    emit(state.withResult(status: ViewStatus.loading));
    final trimmed = reference.trim();
    final result = await _recordPayment(
      RecordPaymentParams(
        invoiceNumber: invoice.number,
        payment: NewPayment(
          amount: AmountInput.parse(amountText),
          method: state.method,
          date: state.date,
          reference: trimmed.isEmpty ? null : trimmed,
          hasReceipt: state.hasReceipt,
        ),
      ),
    );
    if (isClosed) return;
    result.when(
      success: (updated) =>
          emit(state.withResult(status: ViewStatus.success, recorded: updated)),
      error: (failure) =>
          emit(state.withResult(status: ViewStatus.failure, failure: failure)),
    );
  }
}
