import 'dart:async';

import '../../error/exceptions.dart';
import '../api_client.dart';
import 'mock_route.dart';

/// In-process stand-in for the backend: answers requests from routes that
/// each feature registers (fixtures in `assets/mock/`, plus in-memory state
/// for writes). Replace it with a real HTTP [ApiClient] in
/// `app/di/injection.dart` once the API exists; nothing else changes.
class MockApiClient implements ApiClient {
  MockApiClient({
    required Iterable<MockApiModule> modules,
    this.latency = Duration.zero,
  }) : _routes = [for (final module in modules) ...module.routes];

  /// Simulated network round-trip applied to every request.
  final Duration latency;

  final List<MockRoute> _routes;

  @override
  Future<Object?> get(String path, {Map<String, String>? query}) =>
      _send(HttpMethod.get, path, query: query);

  @override
  Future<Object?> post(String path, {Json? body}) =>
      _send(HttpMethod.post, path, body: body);

  @override
  Future<Object?> put(String path, {Json? body}) =>
      _send(HttpMethod.put, path, body: body);

  @override
  Future<Object?> patch(String path, {Json? body}) =>
      _send(HttpMethod.patch, path, body: body);

  @override
  Future<Object?> delete(String path) => _send(HttpMethod.delete, path);

  Future<Object?> _send(
    HttpMethod method,
    String path, {
    Map<String, String>? query,
    Json? body,
  }) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    for (final route in _routes) {
      final params = route.match(method, path);
      if (params == null) continue;
      return route.handler(
        MockRequest(
          method: method,
          path: path,
          pathParams: params,
          query: query ?? const {},
          body: body ?? const {},
        ),
      );
    }
    throw NotFoundException('${method.name.toUpperCase()} $path');
  }
}
