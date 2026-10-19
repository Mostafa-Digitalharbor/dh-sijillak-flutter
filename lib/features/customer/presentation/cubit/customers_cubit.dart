import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/customer_summary.dart';
import '../../domain/usecases/get_customers_use_case.dart';
import '../constants/customer_constants.dart';

class CustomersState extends Equatable {
  const CustomersState({
    this.status = ViewStatus.initial,
    this.failure,
    this.query = '',
    this.searching = false,
    this.customers = const [],
  });

  final ViewStatus status;
  final Failure? failure;

  /// Text typed in the search field.
  final String query;

  /// Whether the inline search field is open.
  final bool searching;
  final List<CustomerSummary> customers;

  CustomersState copyWith({
    ViewStatus? status,
    Failure? failure,
    String? query,
    bool? searching,
    List<CustomerSummary>? customers,
  }) => CustomersState(
    status: status ?? this.status,
    failure: failure,
    query: query ?? this.query,
    searching: searching ?? this.searching,
    customers: customers ?? this.customers,
  );

  @override
  List<Object?> get props => [status, failure, query, searching, customers];
}

class CustomersCubit extends Cubit<CustomersState> {
  CustomersCubit(
    this._getCustomers, {
    this.searchDebounce = CustomerConstants.searchDebounce,
  }) : super(const CustomersState());

  final GetCustomersUseCase _getCustomers;

  /// Pause after the last keystroke before the list is searched.
  final Duration searchDebounce;
  int _request = 0;
  Timer? _debounce;

  /// Loads the customers matching the current query. Rows already on screen
  /// stay visible while a new search loads.
  Future<void> load() async {
    final request = ++_request;
    emit(
      state.copyWith(
        status: state.status == ViewStatus.success
            ? ViewStatus.success
            : ViewStatus.loading,
      ),
    );
    final result = await _getCustomers(state.query);
    if (request != _request || isClosed) return;
    emit(
      result.when(
        success: (customers) =>
            state.copyWith(status: ViewStatus.success, customers: customers),
        error: (failure) =>
            state.copyWith(status: ViewStatus.failure, failure: failure),
      ),
    );
  }

  /// Searches [query] once typing pauses for [searchDebounce].
  void search(String query) {
    emit(
      state.copyWith(
        query: query,
        status: state.status,
        failure: state.failure,
      ),
    );
    _debounce?.cancel();
    _debounce = Timer(searchDebounce, load);
  }

  /// Shows or hides the search field; hiding it clears the query.
  void toggleSearch() {
    _debounce?.cancel();
    final opening = !state.searching;
    final hadQuery = state.query.isNotEmpty;
    emit(
      state.copyWith(
        searching: opening,
        query: opening ? state.query : '',
        status: state.status,
        failure: state.failure,
      ),
    );
    if (!opening && hadQuery) load();
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
