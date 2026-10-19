import '../../../../core/network/api_client.dart';
import '../../domain/entities/workspace.dart';

/// JSON form of [Workspace].
class WorkspaceModel {
  const WorkspaceModel({
    required this.id,
    required this.name,
    required this.handle,
    required this.url,
  });

  factory WorkspaceModel.fromJson(Json json) => WorkspaceModel(
    id: json['id'] as String,
    name: json['name'] as String,
    handle: json['handle'] as String,
    url: json['url'] as String,
  );

  factory WorkspaceModel.fromEntity(Workspace workspace) => WorkspaceModel(
    id: workspace.id,
    name: workspace.name,
    handle: workspace.handle,
    url: workspace.url,
  );

  final String id;
  final String name;
  final String handle;
  final String url;

  Json toJson() => {'id': id, 'name': name, 'handle': handle, 'url': url};

  Workspace toEntity() =>
      Workspace(id: id, name: name, handle: handle, url: url);
}
