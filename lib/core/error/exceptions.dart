/// Thrown by data sources when a request fails. Repositories turn these into
/// a `Failure`; nothing above the data layer should ever see them.
sealed class AppException implements Exception {
  const AppException([this.message]);

  final String? message;
}

/// No connection, timeout or DNS failure.
class NetworkException extends AppException {
  const NetworkException([super.message]);
}

/// The server answered with an error status.
class ServerException extends AppException {
  const ServerException({this.statusCode, this.code, String? message})
    : super(message);

  final int? statusCode;

  /// Machine-readable error code from the API body, when present.
  final String? code;
}

/// The requested resource does not exist.
class NotFoundException extends AppException {
  const NotFoundException([super.message]);
}

/// Missing or expired credentials.
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message]);
}

/// The server rejected the submitted data; [fields] maps field -> error code.
class ValidationException extends AppException {
  const ValidationException({this.fields = const {}, String? message})
    : super(message);

  final Map<String, String> fields;
}
