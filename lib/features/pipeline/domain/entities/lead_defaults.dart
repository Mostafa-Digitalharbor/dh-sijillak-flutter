import 'package:equatable/equatable.dart';

import 'lead_party.dart';

/// Pre-filled customer and owner of the new-deal form.
class LeadDefaults extends Equatable {
  const LeadDefaults({required this.customer, required this.owner});

  final LeadParty customer;
  final LeadParty owner;

  @override
  List<Object?> get props => [customer, owner];
}
