import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/otp_verification.dart';
import '../repositories/auth_repository.dart';

/// Checks the code the user typed.
class VerifyOtpUseCase implements UseCase<void, OtpVerification> {
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(OtpVerification params) =>
      _repository.verifyOtp(params);
}
