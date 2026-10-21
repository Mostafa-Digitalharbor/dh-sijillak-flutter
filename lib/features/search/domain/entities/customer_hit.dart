import 'package:equatable/equatable.dart';

/// A customer matched by the global search.
class CustomerHit extends Equatable {
  const CustomerHit({
    required this.id,
    required this.name,
    required this.location,
    required this.openDeals,
  });

  final String id;
  final String name;

  /// "City · sector" as stored with the customer.
  final String location;
  final int openDeals;

  @override
  List<Object?> get props => [id, name, location, openDeals];
}
