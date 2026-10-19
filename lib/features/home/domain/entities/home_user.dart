import 'package:equatable/equatable.dart';

/// The signed-in user as the dashboard greets them.
class HomeUser extends Equatable {
  const HomeUser({
    required this.id,
    required this.name,
    required this.firstName,
  });

  final String id;
  final String name;

  /// Name the avatar initial is taken from.
  final String firstName;

  @override
  List<Object?> get props => [id, name, firstName];
}
