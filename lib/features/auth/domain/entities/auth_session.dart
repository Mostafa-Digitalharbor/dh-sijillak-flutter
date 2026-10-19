import 'package:equatable/equatable.dart';

import 'app_user.dart';
import 'workspace.dart';

/// Who is signed in and to which workspace.
class AuthSession extends Equatable {
  const AuthSession({required this.user, required this.workspace});

  final AppUser user;
  final Workspace workspace;

  @override
  List<Object?> get props => [user, workspace];
}
