import 'package:dartz/dartz.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/core/usecases/usecase.dart';
import 'package:malaz/domain/repositories/auth/auth_repository.dart';

class LogoutUsecase implements UseCase<void,NoParams>{
  final AuthRepository repository;

  LogoutUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}