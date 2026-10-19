import 'package:equatable/equatable.dart';

import 'deal_stage.dart';

/// What the user enters to open a deal.
class NewDeal extends Equatable {
  const NewDeal({
    required this.title,
    required this.customerId,
    required this.ownerId,
    required this.value,
    required this.stage,
    this.expectedClose,
    this.notes,
  });

  final String title;
  final String customerId;
  final String ownerId;
  final int value;
  final DealStage stage;
  final DateTime? expectedClose;
  final String? notes;

  @override
  List<Object?> get props => [
    title,
    customerId,
    ownerId,
    value,
    stage,
    expectedClose,
    notes,
  ];
}
