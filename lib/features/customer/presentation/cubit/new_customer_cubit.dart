import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/new_customer.dart';
import '../../domain/usecases/create_customer_use_case.dart';

/// The new-customer form: what was typed so far and the progress of saving.
class NewCustomerState extends Equatable {
  const NewCustomerState({
    this.name = '',
    this.phone = '',
    this.email = '',
    this.city = '',
    this.sector = '',
    this.status = ViewStatus.initial,
    this.failure,
    this.created,
  });

  final String name;
  final String phone;
  final String email;
  final String city;
  final String sector;

  /// Progress of saving ([ViewStatus.initial] until the first submit).
  final ViewStatus status;
  final Failure? failure;

  /// The customer created by a successful submit.
  final Customer? created;

  /// Only a name is required, and nothing is sent twice.
  bool get canSubmit => name.trim().isNotEmpty && !status.isLoading;

  NewCustomerState copyWith({
    String? name,
    String? phone,
    String? email,
    String? city,
    String? sector,
    ViewStatus? status,
    Failure? failure,
    Customer? created,
  }) => NewCustomerState(
    name: name ?? this.name,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    city: city ?? this.city,
    sector: sector ?? this.sector,
    status: status ?? this.status,
    failure: failure,
    created: created ?? this.created,
  );

  @override
  List<Object?> get props => [
    name,
    phone,
    email,
    city,
    sector,
    status,
    failure,
    created,
  ];
}

/// Drives the new-customer sheet.
class NewCustomerCubit extends Cubit<NewCustomerState> {
  NewCustomerCubit(this._createCustomer) : super(const NewCustomerState());

  final CreateCustomerUseCase _createCustomer;

  void nameChanged(String value) => emit(state.copyWith(name: value));

  void phoneChanged(String value) => emit(state.copyWith(phone: value));

  void emailChanged(String value) => emit(state.copyWith(email: value));

  void cityChanged(String value) => emit(state.copyWith(city: value));

  void sectorChanged(String value) => emit(state.copyWith(sector: value));

  /// Saves the customer; on success [NewCustomerState.created] holds it.
  Future<void> submit() async {
    if (!state.canSubmit) return;
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _createCustomer(
      NewCustomer(
        name: state.name.trim(),
        phone: state.phone.trim(),
        email: state.email.trim(),
        city: state.city.trim(),
        sector: state.sector.trim(),
      ),
    );
    if (isClosed) return;
    emit(
      result.when(
        success: (customer) =>
            state.copyWith(status: ViewStatus.success, created: customer),
        error: (failure) =>
            state.copyWith(status: ViewStatus.failure, failure: failure),
      ),
    );
  }
}
