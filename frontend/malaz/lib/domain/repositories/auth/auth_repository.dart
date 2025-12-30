import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/domain/entities/user_entity.dart';

import '../../../data/models/auth_result.dart';
import '../../entities/auth_state.dart';

abstract class AuthRepository {

  Future<Either<Failure,UserEntity>> login({
    required String phoneNumber,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String phone,
    required String role,
    required String firstName,
    required String lastName,
    required String password,
    required String passwordConfirmation,
    required String dateOfBirth,
    required XFile profileImage,
    required XFile identityImage,
  });

  Future<Either<Failure,void>> logout();

  Future<Either<Failure,UserEntity?>> getCurrentUser();

  Future<Either<Failure,bool>> isAuthentication();

  Future<Either<Failure, void>> sendOtp({ required String phone });

  Future<Either<Failure, AuthStatus>> checkAuth();

  Future<Either<Failure, bool>> verifyOtp({ required String phone, required String otp });

  Future<Either<Failure, UserEntity>> updateProfile(FormData formData);

  Future<void> updateCachedUser(UserEntity user);

  Future<Either<Failure, String>> sendPasswordResetOtp(String phone);

  Future<Either<Failure, String>> updatePassword({
    required String phone,
    required String otp,
    required String newPassword,
  });
}