import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/invoice_detail.dart';
import '../../domain/usecases/get_invoice_use_case.dart';

class InvoiceState extends Equatable {
  const InvoiceState({
    this.status = ViewStatus.initial,
    this.failure,
    this.invoice,
  });

  final ViewStatus status;
  final Failure? failure;
  final InvoiceDetail? invoice;

  @override
  List<Object?> get props => [status, failure, invoice];
}

/// Holds the invoice shown on the detail screen.
class InvoiceCubit extends Cubit<InvoiceState> {
  InvoiceCubit(this._getInvoice) : super(const InvoiceState());

  final GetInvoiceUseCase _getInvoice;
  int? _number;

  /// Loads invoice [number]; an invoice already shown stays on screen while
  /// it refreshes.
  Future<void> load(int number) async {
    _number = number;
    if (state.invoice == null) {
      emit(const InvoiceState(status: ViewStatus.loading));
    }
    final result = await _getInvoice(number);
    if (isClosed) return;
    result.when(
      success: (invoice) =>
          emit(InvoiceState(status: ViewStatus.success, invoice: invoice)),
      error: (failure) => emit(
        InvoiceState(
          status: ViewStatus.failure,
          failure: failure,
          invoice: state.invoice,
        ),
      ),
    );
  }

  /// Loads the invoice again (retry or after a payment).
  Future<void> reload() async {
    final number = _number;
    if (number != null) await load(number);
  }
}
