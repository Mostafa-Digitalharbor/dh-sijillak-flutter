/// A decoded JSON object.
typedef Json = Map<String, dynamic>;

/// Transport used by every remote data source. The app talks to the backend
/// only through this interface, so the mock and a real HTTP client are
/// interchangeable (see `app/di/injection.dart`).
///
/// Convention: every response body is `{"data": ...}`. Implementations
/// return the `data` payload and throw an `AppException` subtype on failure.
abstract interface class ApiClient {
  Future<Object?> get(String path, {Map<String, String>? query});

  Future<Object?> post(String path, {Json? body});

  Future<Object?> put(String path, {Json? body});

  Future<Object?> patch(String path, {Json? body});

  Future<Object?> delete(String path);
}

/// Typed accessors over an [ApiClient] payload.
extension ApiPayload on Object? {
  /// The payload as one JSON object.
  Json get asJson => this! as Json;

  /// The payload as a list of JSON objects.
  List<Json> get asJsonList => (this! as List).cast<Json>();
}
