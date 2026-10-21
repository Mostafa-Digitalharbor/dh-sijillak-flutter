import '../../domain/entities/new_customer.dart';

/// Wire format of the POST /customers request.
class NewCustomerModel {
  const NewCustomerModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.sector,
  });

  factory NewCustomerModel.fromEntity(NewCustomer customer) => NewCustomerModel(
    name: customer.name,
    phone: customer.phone,
    email: customer.email,
    city: customer.city,
    sector: customer.sector,
  );

  final String name;
  final String phone;
  final String email;
  final String city;
  final String sector;

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email,
    'city': city,
    'sector': sector,
  };
}
