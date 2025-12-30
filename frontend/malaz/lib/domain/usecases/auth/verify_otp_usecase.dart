// domain/usecases/verify_otp_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/auth/auth_repository.dart';

class VerifyOtpParams {
  final String phone;
  final String otp;
  VerifyOtpParams({required this.phone, required this.otp});
}

class VerifyOtpUsecase implements UseCase<bool, VerifyOtpParams> {
  final AuthRepository repository;
  VerifyOtpUsecase(this.repository);
  @override
  Future<Either<Failure, bool>> call(VerifyOtpParams params) {
    return repository.verifyOtp(phone: params.phone, otp: params.otp);
  }
}
