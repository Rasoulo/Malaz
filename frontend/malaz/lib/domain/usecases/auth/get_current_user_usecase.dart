import 'package:dartz/dartz.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/core/usecases/usecase.dart';
import 'package:malaz/domain/entities/user/user_entity.dart';
import 'package:malaz/domain/repositories/auth/auth_repository.dart';

class  GetCurrentUserUsecase implements UseCase<UserEntity?,NoParams>{
  final AuthRepository repository;

  GetCurrentUserUsecase({required this.repository});

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }


}