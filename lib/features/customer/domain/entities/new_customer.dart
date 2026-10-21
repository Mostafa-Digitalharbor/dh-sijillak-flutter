import 'package:equatable/equatable.dart';

/// What the user enters to add a customer. Only the name is required.
class NewCustomer extends Equatable {
  const NewCustomer({
    required this.name,
    this.phone = '',
    this.email = '',
    this.city = '',
    this.sector = '',
  });

  final String name;
  final String phone;
  final String email;
  final String city;
  final String sector;

  @override
  List<Object?> get props => [name, phone, email, city, sector];
}
