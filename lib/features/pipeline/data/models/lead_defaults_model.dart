import '../../domain/entities/lead_defaults.dart';
import '../../domain/entities/lead_party.dart';

/// Wire format of GET /deals/lead-defaults.
class LeadDefaultsModel {
  const LeadDefaultsModel({required this.customer, required this.owner});

  factory LeadDefaultsModel.fromJson(Map<String, dynamic> json) =>
      LeadDefaultsModel(
        customer: LeadPartyModel.fromJson(
          json['customer'] as Map<String, dynamic>,
        ),
        owner: LeadPartyModel.fromJson(json['owner'] as Map<String, dynamic>),
      );

  final LeadPartyModel customer;
  final LeadPartyModel owner;

  Map<String, dynamic> toJson() => {
    'customer': customer.toJson(),
    'owner': owner.toJson(),
  };

  LeadDefaults toEntity() =>
      LeadDefaults(customer: customer.toEntity(), owner: owner.toEntity());
}

/// Wire format of a customer or owner reference.
class LeadPartyModel {
  const LeadPartyModel({required this.id, required this.name});

  factory LeadPartyModel.fromJson(Map<String, dynamic> json) =>
      LeadPartyModel(id: json['id'] as String, name: json['name'] as String);

  final String id;
  final String name;

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  LeadParty toEntity() => LeadParty(id: id, name: name);
}
