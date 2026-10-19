import '../../../../core/network/api_client.dart';
import '../../domain/entities/auth_session.dart';
import 'app_user_model.dart';
import 'workspace_model.dart';

/// JSON form of [AuthSession].
class AuthSessionModel {
  const AuthSessionModel({required this.user, required this.workspace});

  factory AuthSessionModel.fromJson(Json json) => AuthSessionModel(
    user: AppUserModel.fromJson(json['user'] as Json),
    workspace: WorkspaceModel.fromJson(json['workspace'] as Json),
  );

  factory AuthSessionModel.fromEntity(AuthSession session) => AuthSessionModel(
    user: AppUserModel.fromEntity(session.user),
    workspace: WorkspaceModel.fromEntity(session.workspace),
  );

  final AppUserModel user;
  final WorkspaceModel workspace;

  Json toJson() => {'user': user.toJson(), 'workspace': workspace.toJson()};

  AuthSession toEntity() =>
      AuthSession(user: user.toEntity(), workspace: workspace.toEntity());
}
