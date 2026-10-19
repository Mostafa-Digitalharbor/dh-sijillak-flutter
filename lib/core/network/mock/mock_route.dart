import 'dart:async';

import '../api_client.dart';

enum HttpMethod { get, post, put, patch, delete }

/// A request as seen by a mock handler.
class MockRequest {
  const MockRequest({
    required this.method,
    required this.path,
    required this.pathParams,
    required this.query,
    required this.body,
  });

  final HttpMethod method;
  final String path;

  /// Values of `:name` segments in the route pattern.
  final Map<String, String> pathParams;
  final Map<String, String> query;
  final Json body;
}

typedef MockHandler = FutureOr<Object?> Function(MockRequest request);

/// One fake endpoint: `METHOD /path/:param` answered by [handler].
class MockRoute {
  MockRoute(this.method, this.pattern, this.handler)
    : _segments = pattern.split('/');

  final HttpMethod method;
  final String pattern;
  final MockHandler handler;
  final List<String> _segments;

  /// Path parameters when [method] and [path] match this route, else null.
  Map<String, String>? match(HttpMethod method, String path) {
    if (method != this.method) return null;
    final actual = path.split('?').first.split('/');
    if (actual.length != _segments.length) return null;
    final params = <String, String>{};
    for (var i = 0; i < _segments.length; i++) {
      final expected = _segments[i];
      if (expected.startsWith(':')) {
        params[expected.substring(1)] = Uri.decodeComponent(actual[i]);
      } else if (expected != actual[i]) {
        return null;
      }
    }
    return params;
  }
}

/// A group of fake endpoints, usually one per feature.
abstract interface class MockApiModule {
  List<MockRoute> get routes;
}
