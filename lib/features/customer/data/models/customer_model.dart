import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_activity.dart';

/// Wire format of GET /customers/:id.
class CustomerModel {
  const CustomerModel({
    required this.id,
    required this.name,
    required this.location,
    required this.city,
    required this.sector,
    required this.phone,
    required this.email,
    required this.address,
    required this.commercialRegistration,
    required this.vatNumber,
    required this.customerSince,
    required this.accountOwner,
    required this.totalSales,
    required this.amountDue,
    required this.openDeals,
    required this.activity,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    id: json['id'] as String,
    name: json['name'] as String,
    location: json['location'] as String,
    city: json['city'] as String,
    sector: json['sector'] as String,
    phone: json['phone'] as String,
    email: json['email'] as String,
    address: json['address'] as String,
    commercialRegistration: json['commercialRegistration'] as String,
    vatNumber: json['vatNumber'] as String,
    customerSince: DateTime.parse(json['customerSince'] as String),
    accountOwner: json['accountOwner'] as String,
    totalSales: (json['totalSales'] as num).toInt(),
    amountDue: (json['amountDue'] as num).toInt(),
    openDeals: (json['openDeals'] as num).toInt(),
    activity: [
      for (final item in json['activity'] as List)
        CustomerActivityModel.fromJson(item as Map<String, dynamic>),
    ],
  );

  final String id;
  final String name;
  final String location;
  final String city;
  final String sector;
  final String phone;
  final String email;
  final String address;
  final String commercialRegistration;
  final String vatNumber;
  final DateTime customerSince;
  final String accountOwner;
  final int totalSales;
  final int amountDue;
  final int openDeals;
  final List<CustomerActivityModel> activity;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'city': city,
    'sector': sector,
    'phone': phone,
    'email': email,
    'address': address,
    'commercialRegistration': commercialRegistration,
    'vatNumber': vatNumber,
    'customerSince': customerSince.toIso8601String(),
    'accountOwner': accountOwner,
    'totalSales': totalSales,
    'amountDue': amountDue,
    'openDeals': openDeals,
    'activity': [for (final item in activity) item.toJson()],
  };

  Customer toEntity() => Customer(
    id: id,
    name: name,
    location: location,
    city: city,
    sector: sector,
    phone: phone,
    email: email,
    address: address,
    commercialRegistration: commercialRegistration,
    vatNumber: vatNumber,
    customerSince: customerSince,
    accountOwner: accountOwner,
    totalSales: totalSales,
    amountDue: amountDue,
    openDeals: openDeals,
    activity: [for (final item in activity) item.toEntity()],
  );
}

/// Wire format of one timeline entry.
class CustomerActivityModel {
  const CustomerActivityModel({
    required this.id,
    required this.kind,
    required this.title,
    required this.at,
    this.detail,
    this.amount,
  });

  factory CustomerActivityModel.fromJson(Map<String, dynamic> json) =>
      CustomerActivityModel(
        id: json['id'] as String,
        kind: CustomerActivityKind.values.byName(json['kind'] as String),
        title: json['title'] as String,
        at: DateTime.parse(json['at'] as String),
        detail: json['detail'] as String?,
        amount: (json['amount'] as num?)?.toInt(),
      );

  final String id;
  final CustomerActivityKind kind;
  final String title;
  final DateTime at;
  final String? detail;
  final int? amount;

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'at': at.toIso8601String(),
    if (detail != null) 'detail': detail,
    if (amount != null) 'amount': amount,
  };

  CustomerActivity toEntity() => CustomerActivity(
    id: id,
    kind: kind,
    title: title,
    at: at,
    detail: detail,
    amount: amount,
  );
}
