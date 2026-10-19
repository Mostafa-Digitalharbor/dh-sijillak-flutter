import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/invoice_listing.dart';
import '../../domain/entities/invoice_period.dart';
import '../../domain/entities/invoice_summary.dart';
import '../../domain/usecases/get_invoices_use_case.dart';
import '../constants/invoices_defaults.dart';

class InvoicesState extends Equatable {
  /// null [filter] = all invoices.
  const InvoicesState({
    this.status = ViewStatus.initial,
    this.failure,
    this.filter,
    this.query = '',
    this.period = InvoicesDefaults.period,
    this.searching = false,
    this.listing,
  });

  final ViewStatus status;
  final Failure? failure;
  final InvoiceStatus? filter;
  final String query;
  final InvoicePeriod period;

  /// Whether the inline search field is open.
  final bool searching;
  final InvoiceListing? listing;

  List<InvoiceSummary> get rows => listing?.invoices ?? const [];

  /// Copy with [status], [failure] and [listing] replaced (a missing
  /// [failure] clears it); everything else is kept.
  InvoicesState copyWith({
    required ViewStatus status,
    Failure? failure,
    InvoiceListing? listing,
  }) => InvoicesState(
    status: status,
    failure: failure,
    filter: filter,
    query: query,
    period: period,
    searching: searching,
    listing: listing ?? this.listing,
  );

  InvoicesState withFilter(InvoiceStatus? filter) => InvoicesState(
    status: status,
    filter: filter,
    query: query,
    period: period,
    searching: searching,
    listing: listing,
  );

  InvoicesState withQuery(String query) => InvoicesState(
    status: status,
    filter: filter,
    query: query,
    period: period,
    searching: searching,
    listing: listing,
  );

  InvoicesState withPeriod(InvoicePeriod period) => InvoicesState(
    status: status,
    filter: filter,
    query: query,
    period: period,
    searching: searching,
    listing: listing,
  );

  InvoicesState withSearching({required bool searching}) => InvoicesState(
    status: status,
    filter: filter,
    query: searching ? query : '',
    period: period,
    searching: searching,
    listing: listing,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    filter,
    query,
    period,
    searching,
    listing,
  ];
}

class InvoicesCubit extends Cubit<InvoicesState> {
  InvoicesCubit(
    this._getInvoices, {
    this.searchDebounce = InvoicesDefaults.searchDebounce,
  }) : super(const InvoicesState());

  /// Filter behind each tab; `null` shows every invoice.
  static const filters = <InvoiceStatus?>[
    null,
    InvoiceStatus.paid,
    InvoiceStatus.due,
    InvoiceStatus.late,
  ];

  final GetInvoicesUseCase _getInvoices;

  /// Pause after the last keystroke before the list is searched.
  final Duration searchDebounce;
  int _request = 0;
  Timer? _debounce;

  /// Loads the list for the current filter, period and query. Rows already
  /// on screen stay visible while a new filter loads.
  Future<void> load() async {
    final request = ++_request;
    emit(
      state.copyWith(
        status: state.listing == null ? ViewStatus.loading : state.status,
      ),
    );
    final result = await _getInvoices(
      GetInvoicesParams(
        status: state.filter,
        query: state.query,
        period: state.period,
      ),
    );
    if (request != _request || isClosed) return;
    result.when(
      success: (listing) =>
          emit(state.copyWith(status: ViewStatus.success, listing: listing)),
      error: (failure) =>
          emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
    );
  }

  void selectTab(int index) {
    emit(state.withFilter(filters[index]));
    load();
  }

  void selectPeriod(InvoicePeriod period) {
    if (period == state.period) return;
    emit(state.withPeriod(period));
    load();
  }

  /// Searches [query] once typing pauses for [searchDebounce].
  void search(String query) {
    emit(state.withQuery(query));
    _debounce?.cancel();
    _debounce = Timer(searchDebounce, load);
  }

  /// Shows or hides the search field; hiding it clears the filter.
  void toggleSearch() {
    _debounce?.cancel();
    final opening = !state.searching;
    final hadQuery = state.query.isNotEmpty;
    emit(state.withSearching(searching: opening));
    if (!opening && hadQuery) load();
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
