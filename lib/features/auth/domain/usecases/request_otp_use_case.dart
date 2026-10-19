import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

/// Sends a one-time code to a mobile number.
class RequestOtpUseCase implements UseCase<void, String> {
  const RequestOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(String phone) => _repository.requestOtp(phone);
}
