import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logs requests and responses without ever writing a credential: sensitive
/// headers and body fields are replaced by [redacted]. Meant for debug builds
/// only (see `HttpApiClient.create`).
class RedactingLogInterceptor extends Interceptor {
  RedactingLogInterceptor({void Function(String line)? log})
    : _log = log ?? debugPrint;

  static const redacted = '***';

  static const _sensitiveHeaders = {'authorization', 'cookie', 'set-cookie'};
  static const _sensitiveFields = {
    'password',
    'accesstoken',
    'refreshtoken',
    'token',
    'authorization',
    'secret',
    'otp',
  };
  static const _codeField = 'code';
  static const _startKey = 'logStartedAt';
  static const _noStatus = '-';

  final void Function(String line) _log;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startKey] = DateTime.now().millisecondsSinceEpoch;
    _log(
      '--> ${options.method} ${options.uri} '
      'headers=${_headers(options.headers)} body=${redact(options.data)}',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final options = response.requestOptions;
    _log(
      '<-- ${response.statusCode} ${options.method} ${options.uri} '
      '(${_elapsed(options)}ms) '
      'body=${redact(response.data, hideCode: false)}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    _log(
      '<-- ERR ${err.type.name} ${err.response?.statusCode ?? _noStatus} '
      '${options.method} ${options.uri} (${_elapsed(options)}ms) '
      'body=${redact(err.response?.data, hideCode: false)}',
    );
    handler.next(err);
  }

  int _elapsed(RequestOptions options) {
    final started = options.extra[_startKey] as int?;
    return started == null
        ? 0
        : DateTime.now().millisecondsSinceEpoch - started;
  }

  Map<String, Object?> _headers(Map<String, dynamic> headers) => {
    for (final entry in headers.entries)
      entry.key: _sensitiveHeaders.contains(entry.key.toLowerCase())
          ? redacted
          : entry.value,
  };

  /// [value] with every sensitive field replaced by [redacted]. [hideCode]
  /// also hides `code` (a one-time password in request bodies, but a harmless
  /// error code in responses).
  static Object? redact(Object? value, {bool hideCode = true}) {
    if (value is Map) {
      return {
        for (final entry in value.entries)
          entry.key: _isSensitive(entry.key.toString(), hideCode)
              ? redacted
              : redact(entry.value, hideCode: hideCode),
      };
    }
    if (value is List) {
      return [for (final item in value) redact(item, hideCode: hideCode)];
    }
    return value;
  }

  static bool _isSensitive(String key, bool hideCode) {
    final lower = key.toLowerCase();
    if (lower == _codeField) return hideCode;
    return _sensitiveFields.contains(lower);
  }
}
