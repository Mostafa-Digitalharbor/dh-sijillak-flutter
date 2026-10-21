import 'package:equatable/equatable.dart';

import '../../../pipeline/domain/entities/deal_stage.dart';

/// A deal matched by the global search.
class DealHit extends Equatable {
  const DealHit({
    required this.id,
    required this.title,
    required this.stage,
    required this.value,
    required this.customerId,
    required this.customerName,
  });

  final String id;
  final String title;
  final DealStage stage;
  final int value;
  final String customerId;
  final String customerName;

  @override
  List<Object?> get props => [
    id,
    title,
    stage,
    value,
    customerId,
    customerName,
  ];
}
