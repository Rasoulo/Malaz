import 'package:dartz/dartz.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/core/usecases/usecase.dart';
import 'package:malaz/domain/repositories/auth_repository.dart';

import '../../entities/auth_state.dart';

class CheckAuthUsecase implements UseCase<AuthStatus, NoParams> {
  final AuthRepository repository;

  CheckAuthUsecase({required this.repository});

  @override
  Future<Either<Failure, AuthStatus>> call(NoParams params) async {
    return await repository.checkAuth();
  }
}
