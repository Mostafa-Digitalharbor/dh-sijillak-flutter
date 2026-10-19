import '../../domain/entities/deal_stage.dart';
import '../../domain/entities/new_deal.dart';

/// Wire format of the body of POST /deals.
class NewDealModel {
  const NewDealModel({
    required this.title,
    required this.customerId,
    required this.ownerId,
    required this.value,
    required this.stage,
    this.expectedClose,
    this.notes,
  });

  factory NewDealModel.fromEntity(NewDeal deal) => NewDealModel(
    title: deal.title,
    customerId: deal.customerId,
    ownerId: deal.ownerId,
    value: deal.value,
    stage: deal.stage,
    expectedClose: deal.expectedClose,
    notes: deal.notes,
  );

  factory NewDealModel.fromJson(Map<String, dynamic> json) => NewDealModel(
    title: json['title'] as String,
    customerId: json['customerId'] as String,
    ownerId: json['ownerId'] as String,
    value: (json['value'] as num).toInt(),
    stage: DealStage.values.byName(json['stage'] as String),
    expectedClose: json['expectedClose'] == null
        ? null
        : DateTime.parse(json['expectedClose'] as String),
    notes: json['notes'] as String?,
  );

  final String title;
  final String customerId;
  final String ownerId;
  final int value;
  final DealStage stage;
  final DateTime? expectedClose;
  final String? notes;

  Map<String, dynamic> toJson() => {
    'title': title,
    'customerId': customerId,
    'ownerId': ownerId,
    'value': value,
    'stage': stage.name,
    if (expectedClose != null)
      'expectedClose': expectedClose!.toIso8601String(),
    if (notes != null) 'notes': notes,
  };

  NewDeal toEntity() => NewDeal(
    title: title,
    customerId: customerId,
    ownerId: ownerId,
    value: value,
    stage: stage,
    expectedClose: expectedClose,
    notes: notes,
  );
}
