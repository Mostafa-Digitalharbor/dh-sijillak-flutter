import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/deal.dart';
import '../../domain/entities/deal_stage.dart';
import '../../domain/entities/pipeline.dart';
import '../../domain/usecases/get_pipeline_use_case.dart';

class PipelineState extends Equatable {
  const PipelineState({
    this.status = ViewStatus.initial,
    this.pipeline,
    this.failure,
    this.stage = DealStage.quote,
  });

  final ViewStatus status;
  final Pipeline? pipeline;
  final Failure? failure;

  /// Stage whose deals are listed.
  final DealStage stage;

  List<Deal> get deals => pipeline?.dealsIn(stage) ?? const [];

  /// Combined value of every deal in the selected stage.
  int get total => pipeline?.summaryOf(stage).totalValue ?? 0;

  PipelineState copyWith({
    ViewStatus? status,
    Pipeline? pipeline,
    Failure? failure,
    DealStage? stage,
  }) => PipelineState(
    status: status ?? this.status,
    pipeline: pipeline ?? this.pipeline,
    failure: failure,
    stage: stage ?? this.stage,
  );

  @override
  List<Object?> get props => [status, pipeline, failure, stage];
}

class PipelineCubit extends Cubit<PipelineState> {
  PipelineCubit(this._getPipeline) : super(const PipelineState());

  final GetPipelineUseCase _getPipeline;

  /// Loads the pipeline. A [silent] reload keeps showing the current content
  /// instead of a spinner (used when the screen is shown again after a deal
  /// was created or a quote was approved elsewhere).
  Future<void> load({bool silent = false}) async {
    if (!silent) emit(state.copyWith(status: ViewStatus.loading));
    final result = await _getPipeline(const NoParams());
    if (isClosed) return;
    emit(
      result.when(
        success: (pipeline) =>
            state.copyWith(status: ViewStatus.success, pipeline: pipeline),
        error: (failure) =>
            state.copyWith(status: ViewStatus.failure, failure: failure),
      ),
    );
  }

  void selectStage(DealStage stage) => emit(state.copyWith(stage: stage));
}
