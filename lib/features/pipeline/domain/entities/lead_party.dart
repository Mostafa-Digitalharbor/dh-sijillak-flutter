import 'package:equatable/equatable.dart';

/// A customer or a team member referenced by a deal.
class LeadParty extends Equatable {
  const LeadParty({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
