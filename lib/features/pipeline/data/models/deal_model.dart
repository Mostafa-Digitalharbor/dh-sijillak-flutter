import '../../domain/entities/deal.dart';
import '../../domain/entities/deal_stage.dart';
import '../../domain/entities/next_action.dart';

/// Wire format of a deal.
class DealModel {
  const DealModel({
    required this.id,
    required this.title,
    required this.stage,
    required this.customerId,
    required this.customerName,
    required this.value,
    required this.probability,
    required this.ownerId,
    required this.ownerName,
    this.nextAction,
    this.quoteExpiresAt,
    this.expectedClose,
    this.notes,
  });

  factory DealModel.fromJson(Map<String, dynamic> json) => DealModel(
    id: json['id'] as String,
    title: json['title'] as String,
    stage: DealStage.values.byName(json['stage'] as String),
    customerId: json['customerId'] as String,
    customerName: json['customerName'] as String,
    value: (json['value'] as num).toInt(),
    probability: (json['probability'] as num).toInt(),
    ownerId: json['ownerId'] as String,
    ownerName: json['ownerName'] as String,
    nextAction: json['nextAction'] == null
        ? null
        : NextActionModel.fromJson(json['nextAction'] as Map<String, dynamic>),
    quoteExpiresAt: _date(json['quoteExpiresAt']),
    expectedClose: _date(json['expectedClose']),
    notes: json['notes'] as String?,
  );

  final String id;
  final String title;
  final DealStage stage;
  final String customerId;
  final String customerName;
  final int value;
  final int probability;
  final String ownerId;
  final String ownerName;
  final NextActionModel? nextAction;
  final DateTime? quoteExpiresAt;
  final DateTime? expectedClose;
  final String? notes;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'stage': stage.name,
    'customerId': customerId,
    'customerName': customerName,
    'value': value,
    'probability': probability,
    'ownerId': ownerId,
    'ownerName': ownerName,
    if (nextAction != null) 'nextAction': nextAction!.toJson(),
    if (quoteExpiresAt != null)
      'quoteExpiresAt': quoteExpiresAt!.toIso8601String(),
    if (expectedClose != null)
      'expectedClose': expectedClose!.toIso8601String(),
    if (notes != null) 'notes': notes,
  };

  Deal toEntity() => Deal(
    id: id,
    title: title,
    stage: stage,
    customerId: customerId,
    customerName: customerName,
    value: value,
    probability: probability,
    ownerId: ownerId,
    ownerName: ownerName,
    nextAction: nextAction?.toEntity(),
    quoteExpiresAt: quoteExpiresAt,
    expectedClose: expectedClose,
    notes: notes,
  );

  static DateTime? _date(Object? raw) =>
      raw == null ? null : DateTime.parse(raw as String);
}

/// Wire format of the planned next step of a deal.
class NextActionModel {
  const NextActionModel({required this.title, this.at, this.hasTime = false});

  factory NextActionModel.fromJson(Map<String, dynamic> json) =>
      NextActionModel(
        title: json['title'] as String,
        at: json['at'] == null ? null : DateTime.parse(json['at'] as String),
        hasTime: json['hasTime'] as bool? ?? false,
      );

  final String title;
  final DateTime? at;
  final bool hasTime;

  Map<String, dynamic> toJson() => {
    'title': title,
    if (at != null) 'at': at!.toIso8601String(),
    'hasTime': hasTime,
  };

  NextAction toEntity() => NextAction(title: title, at: at, hasTime: hasTime);
}
