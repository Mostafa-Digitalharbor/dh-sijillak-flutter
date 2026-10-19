import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_deal.dart';
import '../../domain/entities/customer_invoice.dart';
import '../../domain/usecases/get_customer_deals_use_case.dart';
import '../../domain/usecases/get_customer_invoices_use_case.dart';
import '../../domain/usecases/get_customer_use_case.dart';
import '../constants/customer_constants.dart';
import 'section_state.dart';

class CustomerState extends Equatable {
  const CustomerState({
    this.status = ViewStatus.initial,
    this.customer,
    this.failure,
    this.tab = CustomerConstants.tabActivity,
    this.deals = const SectionState(),
    this.invoices = const SectionState(),
  });

  final ViewStatus status;
  final Customer? customer;
  final Failure? failure;

  /// Index of the selected section tab: activity, invoices, deals, details.
  final int tab;

  /// The deals tab, loaded the first time it is opened.
  final SectionState<CustomerDeal> deals;

  /// The invoices tab, loaded the first time it is opened.
  final SectionState<CustomerInvoice> invoices;

  CustomerState copyWith({
    ViewStatus? status,
    Customer? customer,
    Failure? failure,
    int? tab,
    SectionState<CustomerDeal>? deals,
    SectionState<CustomerInvoice>? invoices,
  }) => CustomerState(
    status: status ?? this.status,
    customer: customer ?? this.customer,
    failure: failure,
    tab: tab ?? this.tab,
    deals: deals ?? this.deals,
    invoices: invoices ?? this.invoices,
  );

  @override
  List<Object?> get props => [status, customer, failure, tab, deals, invoices];
}

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit(this._getCustomer, this._getDeals, this._getInvoices)
    : super(const CustomerState());

  final GetCustomerUseCase _getCustomer;
  final GetCustomerDealsUseCase _getDeals;
  final GetCustomerInvoicesUseCase _getInvoices;

  String? _customerId;

  /// Loads the profile of [customerId]; without an argument it reloads the
  /// customer loaded last (used by the retry button). Opening another
  /// customer forgets the tabs loaded for the previous one.
  Future<void> load([String? customerId]) async {
    final id = customerId ?? _customerId;
    if (id == null) return;
    final changed = id != _customerId;
    _customerId = id;
    emit(
      CustomerState(
        status: ViewStatus.loading,
        customer: state.customer,
        tab: state.tab,
        deals: changed ? const SectionState() : state.deals,
        invoices: changed ? const SectionState() : state.invoices,
      ),
    );
    final result = await _getCustomer(id);
    if (isClosed) return;
    emit(
      result.when(
        success: (customer) =>
            state.copyWith(status: ViewStatus.success, customer: customer),
        error: (failure) =>
            state.copyWith(status: ViewStatus.failure, failure: failure),
      ),
    );
  }

  /// Switches the section; the deals and invoices load on first view.
  void selectTab(int index) {
    emit(state.copyWith(tab: index, failure: state.failure));
    switch (index) {
      case CustomerConstants.tabDeals:
        if (state.deals.status == ViewStatus.initial) loadDeals();
      case CustomerConstants.tabInvoices:
        if (state.invoices.status == ViewStatus.initial) loadInvoices();
    }
  }

  Future<void> loadDeals() async {
    final id = _customerId;
    if (id == null) return;
    emit(
      state.copyWith(
        deals: const SectionState(status: ViewStatus.loading),
        failure: state.failure,
      ),
    );
    final result = await _getDeals(id);
    if (isClosed || id != _customerId) return;
    emit(state.copyWith(deals: _section(result), failure: state.failure));
  }

  Future<void> loadInvoices() async {
    final id = _customerId;
    if (id == null) return;
    emit(
      state.copyWith(
        invoices: const SectionState(status: ViewStatus.loading),
        failure: state.failure,
      ),
    );
    final result = await _getInvoices(id);
    if (isClosed || id != _customerId) return;
    emit(state.copyWith(invoices: _section(result), failure: state.failure));
  }

  static SectionState<T> _section<T>(Result<List<T>> result) => result.when(
    success: (items) => SectionState(status: ViewStatus.success, items: items),
    error: (failure) =>
        SectionState(status: ViewStatus.failure, failure: failure),
  );
}
