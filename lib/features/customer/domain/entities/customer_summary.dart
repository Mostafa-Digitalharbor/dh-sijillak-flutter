import 'package:equatable/equatable.dart';

/// One row of the customers list.
class CustomerSummary extends Equatable {
  const CustomerSummary({
    required this.id,
    required this.name,
    required this.location,
    required this.openDeals,
    required this.amountDue,
    this.vatNumber = '',
  });

  final String id;
  final String name;

  /// City and sector as one display line.
  final String location;
  final int openDeals;

  /// Amount the customer still owes, in riyals.
  final int amountDue;

  /// Tax number printed on documents issued to the customer (may be blank).
  final String vatNumber;

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    openDeals,
    amountDue,
    vatNumber,
  ];
}
