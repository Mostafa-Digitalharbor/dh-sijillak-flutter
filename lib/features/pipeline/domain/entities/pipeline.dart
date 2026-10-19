import 'package:equatable/equatable.dart';

import 'deal.dart';
import 'deal_stage.dart';
import 'stage_summary.dart';

/// The sales funnel: per-stage totals and the deals to list.
class Pipeline extends Equatable {
  const Pipeline({required this.stages, required this.deals});

  final List<StageSummary> stages;
  final List<Deal> deals;

  /// Deals listed under [stage].
  List<Deal> dealsIn(DealStage stage) => [
    for (final deal in deals)
      if (deal.stage == stage) deal,
  ];

  StageSummary summaryOf(DealStage stage) => stages.firstWhere(
    (summary) => summary.stage == stage,
    orElse: () => StageSummary(stage: stage, count: 0, totalValue: 0),
  );

  /// Deals that are not won yet.
  int get openDeals => _open.fold(0, (sum, s) => sum + s.count);

  /// Combined expected value of the open deals.
  int get expectedValue => _open.fold(0, (sum, s) => sum + s.totalValue);

  Iterable<StageSummary> get _open => stages.where((s) => s.stage.isOpen);

  @override
  List<Object?> get props => [stages, deals];
}
