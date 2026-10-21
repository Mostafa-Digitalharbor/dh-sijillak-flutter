import '../../../../core/network/api_client.dart';
import '../../../../core/network/auth_tokens.dart';
import '../../domain/entities/auth_session.dart';
import 'app_user_model.dart';
import 'workspace_model.dart';

/// JSON form of [AuthSession].
class AuthSessionModel {
  const AuthSessionModel({
    required this.user,
    required this.workspace,
    this.tokens,
  });

  factory AuthSessionModel.fromJson(Json json) => AuthSessionModel(
    user: AppUserModel.fromJson(json['user'] as Json),
    workspace: WorkspaceModel.fromJson(json['workspace'] as Json),
    tokens: json['tokens'] == null
        ? null
        : AuthTokens.fromJson(json['tokens'] as Json),
  );

  factory AuthSessionModel.fromEntity(AuthSession session) => AuthSessionModel(
    user: AppUserModel.fromEntity(session.user),
    workspace: WorkspaceModel.fromEntity(session.workspace),
    tokens: session.tokens,
  );

  final AppUserModel user;
  final WorkspaceModel workspace;
  final AuthTokens? tokens;

  Json toJson() => {
    'user': user.toJson(),
    'workspace': workspace.toJson(),
    if (tokens != null) 'tokens': tokens!.toJson(),
  };

  AuthSession toEntity() => AuthSession(
    user: user.toEntity(),
    workspace: workspace.toEntity(),
    tokens: tokens,
  );
}
