import '../error/failure.dart';

/// Outcome of an operation that can fail: [Success] with data or [Failed]
/// with a [Failure]. Use cases and repositories return this instead of
/// throwing.
sealed class Result<T> {
  const Result();

  /// Runs [action], turning any thrown error into an [Failed].
  static Future<Result<T>> guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on Object catch (error) {
      return Failed(Failure.from(error));
    }
  }

  bool get isSuccess => this is Success<T>;

  T? get dataOrNull => switch (this) {
    Success<T>(:final data) => data,
    Failed<T>() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    Failed<T>(:final failure) => failure,
  };

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) error,
  }) => switch (this) {
    Success<T>(:final data) => success(data),
    Failed<T>(:final failure) => error(failure),
  };

  Result<R> map<R>(R Function(T data) transform) => switch (this) {
    Success<T>(:final data) => Success(transform(data)),
    Failed<T>(:final failure) => Failed(failure),
  };
}

class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

class Failed<T> extends Result<T> {
  const Failed(this.failure);

  final Failure failure;
}
