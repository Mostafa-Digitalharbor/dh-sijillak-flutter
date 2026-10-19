import 'package:equatable/equatable.dart';

/// Email and password typed on the sign-in screen.
class LoginCredentials extends Equatable {
  const LoginCredentials({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
