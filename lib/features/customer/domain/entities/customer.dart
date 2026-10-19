import 'package:equatable/equatable.dart';

import 'customer_activity.dart';

/// A customer profile with its headline figures and recent activity.
class Customer extends Equatable {
  const Customer({
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

  final String id;
  final String name;

  /// City and sector as one display line.
  final String location;
  final String city;
  final String sector;
  final String phone;
  final String email;
  final String address;
  final String commercialRegistration;
  final String vatNumber;

  /// When the customer was first onboarded.
  final DateTime customerSince;

  /// Name of the team member who owns the account.
  final String accountOwner;

  /// Lifetime sales in riyals.
  final int totalSales;
  final int amountDue;
  final int openDeals;

  /// Most recent first.
  final List<CustomerActivity> activity;

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    city,
    sector,
    phone,
    email,
    address,
    commercialRegistration,
    vatNumber,
    customerSince,
    accountOwner,
    totalSales,
    amountDue,
    openDeals,
    activity,
  ];
}
