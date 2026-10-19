import 'package:equatable/equatable.dart';

/// The person signed in.
class AppUser extends Equatable {
  const AppUser({required this.id, required this.name, required this.email});

  final String id;
  final String name;
  final String email;

  @override
  List<Object?> get props => [id, name, email];
}
