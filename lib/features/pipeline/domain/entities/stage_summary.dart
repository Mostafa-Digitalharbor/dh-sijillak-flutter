import 'package:equatable/equatable.dart';

import 'deal_stage.dart';

/// Number of deals in a stage and their combined expected value.
class StageSummary extends Equatable {
  const StageSummary({
    required this.stage,
    required this.count,
    required this.totalValue,
  });

  final DealStage stage;
  final int count;
  final int totalValue;

  @override
  List<Object?> get props => [stage, count, totalValue];
}
