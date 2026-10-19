import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

/// Sends a fresh one-time code to the number that already asked for one.
class ResendOtpUseCase implements UseCase<void, String> {
  const ResendOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(String phone) => _repository.requestOtp(phone);
}
