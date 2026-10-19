import '../../../../core/network/api_client.dart';

/// Answer of the handle availability check.
class HandleAvailabilityModel {
  const HandleAvailabilityModel({required this.available});

  factory HandleAvailabilityModel.fromJson(Json json) =>
      HandleAvailabilityModel(available: json['available'] as bool);

  final bool available;

  Json toJson() => {'available': available};

  bool toEntity() => available;
}
