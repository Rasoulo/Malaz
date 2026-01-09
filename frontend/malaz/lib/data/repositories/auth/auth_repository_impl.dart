import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/errors/exceptions.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/data/datasources/local/auth/auth_local_data_source.dart';
import 'package:malaz/data/datasources/remote/auth/auth_remote_datasource.dart';
import 'package:malaz/domain/entities/user/user_entity.dart';
import 'package:malaz/domain/repositories/auth/auth_repository.dart';

import '../../../domain/entities/auth/auth_state.dart';
import '../../models/user/user_model.dart';
import '../../utils/response_parser.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  final AuthLocalDatasource authLocalDatasource;

  AuthRepositoryImpl({
    required this.authRemoteDatasource,
    required this.authLocalDatasource,
  });

  @override
  Future<Either<Failure, AuthStatus>> checkAuth() async {
    try {
      final token = await authLocalDatasource.getCachedToken();
      final isPending = await authLocalDatasource.isPending();
      final user = await authLocalDatasource.getCachedUser();

      // PENDING USER (no token)
      if (isPending && user != null) {
        return Right(AuthStatus(
          isAuthenticated: false,
          isPending: true,
          user: user,
        ));
      }

      // AUTHENTICATED USER
      if (token != null && token.isNotEmpty && user != null) {
        return Right(AuthStatus(
          isAuthenticated: true,
          isPending: false,
          user: user,
        ));
      }

      // NOT AUTHENTICATED
      return Right(AuthStatus(
        isAuthenticated: false,
        isPending: false,
        user: null,
      ));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await authLocalDatasource.getCachedUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthentication() async {
    try {
      final token = await authLocalDatasource.getCachedToken();
      if (token != null && token.isNotEmpty) {
        return Right(true);
      }
      final user = await authLocalDatasource.getCachedUser();
      return Right(user != null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final result = await authRemoteDatasource.login(
        phone: phoneNumber,
        password: password,
      );

      if (result['message'] == 'Wait until is approved by the officials') {
        final us = await authLocalDatasource.getCachedUser();
        final pendingUser = UserModel.pending(phone: phoneNumber);
        await authLocalDatasource.cacheUser(pendingUser);
        await authLocalDatasource.setPending(true);
        return Right(pendingUser);
      }

      final user = UserModel.fromJson(result['user']);
      final token = result['access_token'];

      await authLocalDatasource.cacheUser(user);
      await authLocalDatasource.cacheToken(token);
      await authLocalDatasource.setPending(false);

      return Right(user);

      /// TODO: need to clean up
    } on PendingApprovalException{
      return Left(const PendingApprovalFailure());
    } on PhoneNotFoundException catch (e) {
      return Left(PhoneNotFoundFailure(e.message ?? 'This phone number does not exist.'));
    } on WrongPasswordException catch (e) {
      return Left(WrongPasswordFailure(e.message ?? 'Invalid credentials'));
    } on InvalidCredentialsException catch(e) {
      if(e.message!.toLowerCase().contains('wait until')) {
        return Left(InvalidCredentialsFailure(e.message));
      }
      return Left(InvalidCredentialsFailure('Invalid credentials'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authRemoteDatasource.logout();
      await authLocalDatasource.clearAll();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final result = await authRemoteDatasource.registerUser(
        phone: phone,
        role: role,
        firstName: firstName,
        lastName: lastName,
        password: password,
        passwordConfirmation: passwordConfirmation,
        dateOfBirth: dateOfBirth,
        profileImage: profileImage,
        identityImage: identityImage,
      );
      final userMap = result['data'] as Map<String, dynamic>?;

      if (userMap == null) {
        return Left(ServerFailure('No user data returned from server'));
      }

      final user = UserModel.fromJson(userMap);
      await authLocalDatasource.cacheUser(user);

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException {
      return Left(NetworkFailure());
    } on CacheException catch(e) {
      return Left(CacheFailure(e.toString()));
    } catch (e) {
      return Left(const GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp({required String phone}) async {
    try {
      await authRemoteDatasource.sendOtp(phone: phone);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(const GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(
      {required String phone, required String otp}) async {
    try {
      final res = await authRemoteDatasource.verifyOtp(phone: phone, otp: otp);
      final success = extractSuccess(res);
      if (success) return Right(true);

      final message = extractMessage(res) ?? 'Invalid code';
      return Left(ServerFailure(message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(const GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, String>> sendPasswordResetOtp(String phone) async {
    try {
      final data = await authRemoteDatasource.sendPasswordResetOtp(phone);

      return Right(data['message'] ?? "Success");
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Unexpected error occurred"));
    }
  }

  @override
  Future<Either<Failure, String>> updatePassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final data = await authRemoteDatasource.updatePassword(
        phone: phone,
        otp: otp,
        newPassword: newPassword,
      );
      return Right(data['message'] ?? "Password updated successfully");
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(FormData formData) async {
    try {
      final response = await authRemoteDatasource.updateProfile(formData);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<void> updateCachedUser(UserEntity user) async {
    await authLocalDatasource.cacheUser(user);
  }
}