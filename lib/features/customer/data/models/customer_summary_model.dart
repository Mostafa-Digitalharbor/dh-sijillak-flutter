import '../../domain/entities/customer_summary.dart';

/// Wire format of one row of GET /customers.
class CustomerSummaryModel {
  const CustomerSummaryModel({
    required this.id,
    required this.name,
    required this.location,
    required this.openDeals,
    required this.amountDue,
  });

  factory CustomerSummaryModel.fromJson(Map<String, dynamic> json) =>
      CustomerSummaryModel(
        id: json['id'] as String,
        name: json['name'] as String,
        location: json['location'] as String,
        openDeals: (json['openDeals'] as num).toInt(),
        amountDue: (json['amountDue'] as num).toInt(),
      );

  final String id;
  final String name;
  final String location;
  final int openDeals;
  final int amountDue;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'openDeals': openDeals,
    'amountDue': amountDue,
  };

  CustomerSummary toEntity() => CustomerSummary(
    id: id,
    name: name,
    location: location,
    openDeals: openDeals,
    amountDue: amountDue,
  );
}
