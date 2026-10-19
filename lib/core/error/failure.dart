import 'package:equatable/equatable.dart';

import 'exceptions.dart';

/// A recoverable error as seen by the domain and presentation layers.
sealed class Failure extends Equatable {
  const Failure([this.message]);

  /// Server-provided detail, when any. Never shown verbatim: the UI maps the
  /// failure type to a localised message.
  final String? message;

  @override
  List<Object?> get props => [runtimeType, message];

  /// Maps a data-layer exception to its failure.
  factory Failure.from(Object error) => switch (error) {
    NetworkException(:final message) => NetworkFailure(message),
    NotFoundException(:final message) => NotFoundFailure(message),
    UnauthorizedException(:final message) => UnauthorizedFailure(message),
    ValidationException(:final message, :final fields) => ValidationFailure(
      message: message,
      fields: fields,
    ),
    ServerException(:final message, :final statusCode, :final code) =>
      ServerFailure(message: message, statusCode: statusCode, code: code),
    _ => UnknownFailure(error.toString()),
  };
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

class ServerFailure extends Failure {
  const ServerFailure({String? message, this.statusCode, this.code})
    : super(message);

  final int? statusCode;
  final String? code;

  @override
  List<Object?> get props => [...super.props, statusCode, code];
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message]);
}

class ValidationFailure extends Failure {
  const ValidationFailure({String? message, this.fields = const {}})
    : super(message);

  final Map<String, String> fields;

  @override
  List<Object?> get props => [...super.props, fields];
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message]);
}
