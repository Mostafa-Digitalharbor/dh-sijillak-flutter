import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/home_overview.dart';
import '../../domain/usecases/get_home_overview_use_case.dart';

/// Everything the dashboard displays, plus its load status.
class HomeState extends Equatable {
  const HomeState({
    this.status = ViewStatus.initial,
    this.overview,
    this.failure,
  });

  final ViewStatus status;
  final HomeOverview? overview;
  final Failure? failure;

  @override
  List<Object?> get props => [status, overview, failure];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getOverview) : super(const HomeState());

  final GetHomeOverviewUseCase _getOverview;

  Future<void> load() async {
    emit(HomeState(status: ViewStatus.loading, overview: state.overview));
    final result = await _getOverview(const NoParams());
    if (isClosed) return;
    emit(
      result.when(
        success: (overview) =>
            HomeState(status: ViewStatus.success, overview: overview),
        error: (failure) =>
            HomeState(status: ViewStatus.failure, failure: failure),
      ),
    );
  }
}
