import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/view_status.dart';
import '../../../pipeline/domain/entities/deal_stage.dart';
import '../../domain/entities/customer_deal.dart';
import '../../domain/usecases/get_customer_deals_use_case.dart';

class DealPickerState extends Equatable {
  const DealPickerState({
    this.status = ViewStatus.initial,
    this.failure,
    this.deals = const [],
  });

  final ViewStatus status;
  final Failure? failure;

  /// The customer's deals that are still open.
  final List<CustomerDeal> deals;

  @override
  List<Object?> get props => [status, failure, deals];
}

/// Loads the open deals of one customer for the deal picker.
class DealPickerCubit extends Cubit<DealPickerState> {
  DealPickerCubit(this._getDeals, this.customerId)
    : super(const DealPickerState());

  final GetCustomerDealsUseCase _getDeals;
  final String customerId;

  Future<void> load() async {
    emit(const DealPickerState(status: ViewStatus.loading));
    final result = await _getDeals(customerId);
    if (isClosed) return;
    emit(
      result.when(
        success: (deals) => DealPickerState(
          status: ViewStatus.success,
          deals: [
            for (final deal in deals)
              if (deal.stage != DealStage.won) deal,
          ],
        ),
        error: (failure) =>
            DealPickerState(status: ViewStatus.failure, failure: failure),
      ),
    );
  }
}
