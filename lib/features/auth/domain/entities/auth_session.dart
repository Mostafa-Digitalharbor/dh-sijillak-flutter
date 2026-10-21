import 'package:equatable/equatable.dart';

import '../../../../core/network/auth_tokens.dart';
import 'app_user.dart';
import 'workspace.dart';

/// Who is signed in, to which workspace, and with which credentials.
class AuthSession extends Equatable {
  const AuthSession({required this.user, required this.workspace, this.tokens});

  final AppUser user;
  final Workspace workspace;

  /// Credentials issued by the backend; null for sessions created before
  /// tokens existed.
  final AuthTokens? tokens;

  /// The same session with [tokens] replaced.
  AuthSession withTokens(AuthTokens tokens) =>
      AuthSession(user: user, workspace: workspace, tokens: tokens);

  @override
  List<Object?> get props => [user, workspace, tokens];
}
