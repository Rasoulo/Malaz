import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/core/usecases/usecase.dart';
import 'package:malaz/domain/entities/user/user_entity.dart';
import 'package:malaz/domain/repositories/auth/auth_repository.dart';

class RegisterUsecase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUsecase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await repository.register(
      phone: params.phone,
      role: params.role,
      firstName: params.firstName,
      lastName: params.lastName,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
      dateOfBirth: params.dateOfBirth,
      profileImage: params.profileImage,
      identityImage: params.identityCardImage,
    );
  }
}

class RegisterParams {
  final String phone;
  final String role;
  final String firstName;
  final String lastName;
  final String password;
  final String passwordConfirmation;
  final String dateOfBirth;
  final XFile profileImage;
  final XFile identityCardImage;

  RegisterParams({
    required this.phone,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.passwordConfirmation,
    required this.dateOfBirth,
    required this.profileImage,
    required this.identityCardImage,
  });
}
