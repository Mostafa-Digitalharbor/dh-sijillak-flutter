import '../../domain/entities/customer_summary.dart';

/// Wire format of one row of GET /customers.
class CustomerSummaryModel {
  const CustomerSummaryModel({
    required this.id,
    required this.name,
    required this.location,
    required this.openDeals,
    required this.amountDue,
    this.vatNumber = '',
  });

  factory CustomerSummaryModel.fromJson(Map<String, dynamic> json) =>
      CustomerSummaryModel(
        id: json['id'] as String,
        name: json['name'] as String,
        location: json['location'] as String,
        openDeals: (json['openDeals'] as num).toInt(),
        amountDue: (json['amountDue'] as num).toInt(),
        vatNumber: json['vatNumber'] as String? ?? '',
      );

  final String id;
  final String name;
  final String location;
  final int openDeals;
  final int amountDue;
  final String vatNumber;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'openDeals': openDeals,
    'amountDue': amountDue,
    'vatNumber': vatNumber,
  };

  CustomerSummary toEntity() => CustomerSummary(
    id: id,
    name: name,
    location: location,
    openDeals: openDeals,
    amountDue: amountDue,
    vatNumber: vatNumber,
  );
}
