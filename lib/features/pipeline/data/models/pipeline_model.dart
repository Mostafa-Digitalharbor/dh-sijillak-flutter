import '../../domain/entities/deal_stage.dart';
import '../../domain/entities/pipeline.dart';
import '../../domain/entities/stage_summary.dart';
import 'deal_model.dart';

/// Wire format of GET /deals.
class PipelineModel {
  const PipelineModel({required this.stages, required this.deals});

  factory PipelineModel.fromJson(Map<String, dynamic> json) => PipelineModel(
    stages: [
      for (final stage in json['stages'] as List)
        StageSummaryModel.fromJson(stage as Map<String, dynamic>),
    ],
    deals: [
      for (final deal in json['deals'] as List)
        DealModel.fromJson(deal as Map<String, dynamic>),
    ],
  );

  final List<StageSummaryModel> stages;
  final List<DealModel> deals;

  Map<String, dynamic> toJson() => {
    'stages': [for (final stage in stages) stage.toJson()],
    'deals': [for (final deal in deals) deal.toJson()],
  };

  Pipeline toEntity() => Pipeline(
    stages: [for (final stage in stages) stage.toEntity()],
    deals: [for (final deal in deals) deal.toEntity()],
  );
}

/// Wire format of one stage total.
class StageSummaryModel {
  const StageSummaryModel({
    required this.stage,
    required this.count,
    required this.totalValue,
  });

  factory StageSummaryModel.fromJson(Map<String, dynamic> json) =>
      StageSummaryModel(
        stage: DealStage.values.byName(json['stage'] as String),
        count: (json['count'] as num).toInt(),
        totalValue: (json['totalValue'] as num).toInt(),
      );

  final DealStage stage;
  final int count;
  final int totalValue;

  Map<String, dynamic> toJson() => {
    'stage': stage.name,
    'count': count,
    'totalValue': totalValue,
  };

  StageSummary toEntity() =>
      StageSummary(stage: stage, count: count, totalValue: totalValue);
}
