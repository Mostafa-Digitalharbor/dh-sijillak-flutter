import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/biometric_authenticator.dart';

/// Whether the device can offer biometric sign-in at all.
class CanUseBiometricsUseCase implements UseCase<bool, NoParams> {
  const CanUseBiometricsUseCase(this._authenticator);

  final BiometricAuthenticator _authenticator;

  @override
  Future<Result<bool>> call(NoParams params) =>
      Result.guard(_authenticator.isAvailable);
}
