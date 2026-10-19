import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/quote_document.dart';
import '../../domain/usecases/confirm_quote_use_case.dart';
import '../../domain/usecases/get_quote_use_case.dart';

class QuoteState extends Equatable {
  const QuoteState({
    this.status = ViewStatus.initial,
    this.failure,
    this.quote,
    this.confirmStatus = ViewStatus.initial,
    this.confirmFailure,
  });

  /// Loading of the quote.
  final ViewStatus status;
  final Failure? failure;
  final QuoteDocument? quote;

  /// The "customer approved" action.
  final ViewStatus confirmStatus;
  final Failure? confirmFailure;

  bool get isConfirming => confirmStatus.isLoading;

  @override
  List<Object?> get props => [
    status,
    failure,
    quote,
    confirmStatus,
    confirmFailure,
  ];
}

class QuoteCubit extends Cubit<QuoteState> {
  QuoteCubit(this._getQuote, this._confirmQuote) : super(const QuoteState());

  final GetQuoteUseCase _getQuote;
  final ConfirmQuoteUseCase _confirmQuote;
  int? _number;

  Future<void> load(int number) async {
    _number = number;
    emit(const QuoteState(status: ViewStatus.loading));
    final result = await _getQuote(number);
    if (isClosed) return;
    result.when(
      success: (quote) =>
          emit(QuoteState(status: ViewStatus.success, quote: quote)),
      error: (failure) =>
          emit(QuoteState(status: ViewStatus.failure, failure: failure)),
    );
  }

  Future<void> reload() async {
    final number = _number;
    if (number != null) await load(number);
  }

  /// The customer approved: confirms the quote, which converts its deal.
  Future<void> confirm() async {
    final quote = state.quote;
    if (quote == null || state.isConfirming) return;
    emit(
      QuoteState(
        status: state.status,
        quote: quote,
        confirmStatus: ViewStatus.loading,
      ),
    );
    final result = await _confirmQuote(quote.number);
    if (isClosed) return;
    result.when(
      success: (confirmed) => emit(
        QuoteState(
          status: ViewStatus.success,
          quote: confirmed,
          confirmStatus: ViewStatus.success,
        ),
      ),
      error: (failure) => emit(
        QuoteState(
          status: state.status,
          quote: quote,
          confirmStatus: ViewStatus.failure,
          confirmFailure: failure,
        ),
      ),
    );
  }
}
