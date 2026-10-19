import '../utils/result.dart';

/// One business action. Implementations are small classes with a single
/// [call]; presentation never talks to repositories directly.
abstract interface class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Parameter of use cases that need none.
final class NoParams {
  const NoParams();
}
