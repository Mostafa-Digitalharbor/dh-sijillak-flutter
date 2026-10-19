import 'package:equatable/equatable.dart';

import '../../../pipeline/domain/entities/deal_stage.dart';

/// A deal as listed on a customer's profile.
class CustomerDeal extends Equatable {
  const CustomerDeal({
    required this.id,
    required this.title,
    required this.stage,
    required this.value,
    required this.probability,
  });

  final String id;
  final String title;
  final DealStage stage;

  /// Expected value in riyals.
  final int value;

  /// Win probability in percent.
  final int probability;

  @override
  List<Object?> get props => [id, title, stage, value, probability];
}
