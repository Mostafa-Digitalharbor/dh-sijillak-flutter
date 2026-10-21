import 'package:equatable/equatable.dart';

/// A customer or a team member referenced by a deal.
class LeadParty extends Equatable {
  const LeadParty({required this.id, required this.name, this.subtitle});

  final String id;
  final String name;

  /// Extra line shown under the name (a customer's city and sector), if any.
  final String? subtitle;

  @override
  List<Object?> get props => [id, name, subtitle];
}
