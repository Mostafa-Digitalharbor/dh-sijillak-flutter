import 'package:equatable/equatable.dart';

import 'deal_stage.dart';
import 'next_action.dart';

/// A sales opportunity.
class Deal extends Equatable {
  const Deal({
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

  final String id;
  final String title;
  final DealStage stage;
  final String customerId;
  final String customerName;
  final int value;

  /// Win probability, 0 to 100.
  final int probability;
  final String ownerId;
  final String ownerName;
  final NextAction? nextAction;

  /// When the quote sent for this deal stops being valid.
  final DateTime? quoteExpiresAt;
  final DateTime? expectedClose;
  final String? notes;

  @override
  List<Object?> get props => [
    id,
    title,
    stage,
    customerId,
    customerName,
    value,
    probability,
    ownerId,
    ownerName,
    nextAction,
    quoteExpiresAt,
    expectedClose,
    notes,
  ];
}
