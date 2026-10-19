import '../../../pipeline/domain/entities/deal_stage.dart';
import '../../domain/entities/customer_deal.dart';

/// Wire format of one row of GET /customers/:id/deals.
class CustomerDealModel {
  const CustomerDealModel({
    required this.id,
    required this.title,
    required this.stage,
    required this.value,
    required this.probability,
  });

  factory CustomerDealModel.fromJson(Map<String, dynamic> json) =>
      CustomerDealModel(
        id: json['id'] as String,
        title: json['title'] as String,
        stage: DealStage.values.byName(json['stage'] as String),
        value: (json['value'] as num).toInt(),
        probability: (json['probability'] as num).toInt(),
      );

  final String id;
  final String title;
  final DealStage stage;
  final int value;
  final int probability;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'stage': stage.name,
    'value': value,
    'probability': probability,
  };

  CustomerDeal toEntity() => CustomerDeal(
    id: id,
    title: title,
    stage: stage,
    value: value,
    probability: probability,
  );
}
