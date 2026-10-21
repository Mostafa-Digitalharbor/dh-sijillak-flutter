import 'dart:io';

import 'package:dio/dio.dart';

import '../../error/exceptions.dart';

/// Turns a failed Dio call into the app's [AppException] types.
abstract final class ApiErrorMapper {
  static const _errorKey = 'error';
  static const _codeKey = 'code';
  static const _messageKey = 'message';
  static const _fieldsKey = 'fields';

  static const _statusBadRequest = 400;
  static const _statusUnauthorized = 401;
  static const _statusNotFound = 404;
  static const _statusUnprocessable = 422;

  static AppException map(DioException error) {
    final inner = error.error;
    if (inner is AppException) return inner;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
        return NetworkException(error.message);
      case DioExceptionType.unknown:
        if (inner is SocketException || inner is HttpException) {
          return NetworkException(error.message);
        }
        return ServerException(message: error.message);
      case DioExceptionType.badResponse:
        return _fromResponse(error.response);
    }
  }

  static AppException _fromResponse(Response<dynamic>? response) {
    final status = response?.statusCode;
    final body = _errorBody(response?.data);
    final code = body[_codeKey] as String?;
    final message = body[_messageKey] as String?;
    final fields = _fields(body[_fieldsKey]);
    return switch (status) {
      _statusUnauthorized => UnauthorizedException(message),
      _statusNotFound => NotFoundException(message),
      _statusUnprocessable => ValidationException(
        fields: fields,
        message: message,
      ),
      _statusBadRequest when fields.isNotEmpty => ValidationException(
        fields: fields,
        message: message,
      ),
      _ => ServerException(statusCode: status, code: code, message: message),
    };
  }

  /// The `{"error": {...}}` object of an error body; empty when absent.
  static Map<String, dynamic> _errorBody(Object? data) {
    if (data is Map && data[_errorKey] is Map) {
      return Map<String, dynamic>.from(data[_errorKey] as Map);
    }
    return const {};
  }

  /// `{"field": "code"}` or `{"field": ["code", ...]}` as field -> first code.
  static Map<String, String> _fields(Object? raw) {
    if (raw is! Map) return const {};
    return {
      for (final entry in raw.entries)
        entry.key.toString(): switch (entry.value) {
          final List<dynamic> list when list.isNotEmpty =>
            list.first.toString(),
          final List<dynamic> _ => '',
          final value => value.toString(),
        },
    };
  }
}
