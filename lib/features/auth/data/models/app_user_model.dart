import '../../../../core/network/api_client.dart';
import '../../domain/entities/app_user.dart';

/// JSON form of [AppUser].
class AppUserModel {
  const AppUserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AppUserModel.fromJson(Json json) => AppUserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
  );

  factory AppUserModel.fromEntity(AppUser user) =>
      AppUserModel(id: user.id, name: user.name, email: user.email);

  final String id;
  final String name;
  final String email;

  Json toJson() => {'id': id, 'name': name, 'email': email};

  AppUser toEntity() => AppUser(id: id, name: name, email: email);
}
