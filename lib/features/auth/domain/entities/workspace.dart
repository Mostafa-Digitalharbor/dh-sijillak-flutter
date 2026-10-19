import 'package:equatable/equatable.dart';

/// A company workspace, reachable at its own address.
class Workspace extends Equatable {
  const Workspace({
    required this.id,
    required this.name,
    required this.handle,
    required this.url,
  });

  final String id;
  final String name;

  /// Unique sub-domain label chosen by the company.
  final String handle;

  /// Host the team signs in through, without scheme.
  final String url;

  @override
  List<Object?> get props => [id, name, handle, url];
}
