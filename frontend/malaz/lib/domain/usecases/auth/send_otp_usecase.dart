// domain/usecases/send_otp_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/auth_repository.dart';

class SendOtpParams {
  final String phone;
  SendOtpParams(this.phone);
}

class SendOtpUsecase implements UseCase<void, SendOtpParams> {
  final AuthRepository repository;
  SendOtpUsecase(this.repository);
  @override
  Future<Either<Failure, void>> call(SendOtpParams params) {
    return repository.sendOtp(phone: params.phone);
  }
}
