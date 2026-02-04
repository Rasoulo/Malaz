import 'package:dartz/dartz.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/core/usecases/usecase.dart';
import 'package:malaz/domain/repositories/auth/auth_repository.dart';

import '../../entities/user/user_entity.dart';

class LoginUsecase implements UseCase<UserEntity,LoginParams>{
  final AuthRepository repository;
  
  LoginUsecase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    final res = await repository.login(
        phoneNumber: params.phoneNumber,
        password: params.password,
        fcmToken: params.fcmToken,
    );
    print('is right : ${res.isRight()}');
    return res;
  }
}

class LoginParams{
  final String phoneNumber;
  final String password;
  final String fcmToken;

  LoginParams({
    required this.phoneNumber,
    required this.password,
    required this.fcmToken
  });
}