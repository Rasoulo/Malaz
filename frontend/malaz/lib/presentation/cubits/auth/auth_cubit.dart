import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/constants/app_constants.dart';
import 'package:malaz/domain/entities/user/user_entity.dart';
import 'package:malaz/domain/usecases/auth/check_auth_usecase.dart';
import 'package:malaz/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:malaz/domain/usecases/auth/login_usecase.dart';
import 'package:malaz/domain/usecases/auth/logout_usecase.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/errors/failures.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/datasources/local/auth/auth_local_data_source.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../domain/usecases/auth/send_otp_usecase.dart';
import '../../../domain/usecases/auth/verify_otp_usecase.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthPending extends AuthState {
  final UserEntity user;
  AuthPending(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final Failure failure;
  AuthError({required this.failure});
  @override
  List<Object?> get props => [failure];
}

class OtpSending extends AuthState {}

class OtpSent extends AuthState {}

class OtpSendError extends AuthState {
  final String message;
  OtpSendError(this.message);
}

class OtpVerifying extends AuthState {}

class OtpVerified extends AuthState {}

class OtpVerifyError extends AuthState {
  final String message;
  OtpVerifyError(this.message);
}

class OtpSentSuccess extends AuthState {}

class PasswordUpdatedSuccess extends AuthState {}

// --- Cubit --- //
class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final CheckAuthUsecase checkAuthUsecase;
  final RegisterUsecase registerUsecase;
  final SendOtpUsecase sendOtpUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;
  final AuthRepository repository;

  AuthCubit({
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.getCurrentUserUsecase,
    required this.checkAuthUsecase,
    required this.registerUsecase,
    required this.sendOtpUsecase,
    required this.verifyOtpUsecase,
    required this.repository,
  }) : super(AuthInitial());

  Future<String> _getFcmToken() async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken().timeout(
        const Duration(seconds: 10),
      );
      print('fcm_token is : $fcmToken');
      return fcmToken ?? "";
    } catch (_) {
      return "dummy_token_device_offline";
    }
  }

  Future<void> _saveCredentials(String phone, String password) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: AppConstants.passwordUserKey, value: password);
    await storage.write(key: AppConstants.phoneUserKey, value: phone);
  }

  Future<void> checkAuth() async {
    final res = await checkAuthUsecase(NoParams());
    res.fold(
          (_) => state is AuthPending ? null : emit(AuthUnauthenticated()),
          (status) {
        if (status.user != null) {
          status.isPending ? emit(AuthPending(status.user!)) : emit(AuthAuthenticated(status.user!));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> register({
    required String phone,
    required String firstName,
    required String lastName,
    required String password,
    required String dateOfBirth,
    required XFile profileImage,
    required XFile identityImage,
  }) async {
    emit(AuthLoading());
    try {
      final fcmToken = await _getFcmToken();
      final res = await registerUsecase(RegisterParams(
        phone: phone,
        role: 'PENDING',
        firstName: firstName,
        lastName: lastName,
        password: password,
        passwordConfirmation: password,
        dateOfBirth: dateOfBirth,
        profileImage: profileImage,
        identityCardImage: identityImage,
        fcmToken: fcmToken,
      ));
      res.fold(
            (failure) => emit(AuthError(failure: failure)),
            (user) async {
          await _saveCredentials(phone, password);
          user.role.toLowerCase() == 'pending' ? emit(AuthPending(user)) : emit(AuthAuthenticated(user));
        },
      );
    } catch (e) {
      emit(AuthError(failure: ServerFailure(e.toString())));
    }
  }

  Future<void> login({required String phone, required String password}) async {
    emit(AuthLoading());
    final fcmToken = await _getFcmToken();
    final res = await loginUsecase(LoginParams(
      phoneNumber: phone,
      password: password,
      fcmToken: fcmToken,
    ));
    res.fold(
          (failure) {
        failure is PendingApprovalFailure
            ? emit(AuthPending(UserEntity.emptyPending()))
            : emit(AuthError(failure: failure));
      },
          (user) async {
        if (user.role.toUpperCase() == 'PENDING') {
          await _saveCredentials(phone, password);
          emit(AuthPending(user));
        } else {
          emit(AuthAuthenticated(user));
        }
      },
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await logoutUsecase(NoParams());
    result.fold(
          (failure) => emit(AuthError(failure: failure)),
          (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> sendOtp(String phone) async {
    emit(OtpSending());
    final res = await sendOtpUsecase(SendOtpParams(phone));
    res.fold(
          (failure) => emit(AuthError(failure: failure)),
          (_) => emit(OtpSent()),
    );
  }

  Future<void> verifyOtp(String phone, String otp) async {
    emit(OtpVerifying());
    final res = await verifyOtpUsecase(VerifyOtpParams(phone: phone, otp: otp));
    res.fold(
          (failure) => emit(AuthError(failure: failure)),
          (success) => success ? emit(OtpVerified()) : emit(AuthError(failure: ServerFailure('Invalid code'))),
    );
  }

  Future<void> sendPasswordResetOtp(String phone) async {
    emit(AuthLoading());
    final result = await repository.sendPasswordResetOtp(phone);
    result.fold(
          (failure) => emit(AuthError(failure: failure)),
          (_) => emit(OtpSentSuccess()),
    );
  }

  Future<void> checkRoleUsingLogin({required String phone, required String password}) async {
    emit(AuthLoading());
    final fcmToken = await _getFcmToken();
    final res = await loginUsecase(LoginParams(
      phoneNumber: phone,
      password: password,
      fcmToken: fcmToken,
    ));
    res.fold(
          (failure) => emit(AuthError(failure: failure)),
          (user) {
        if (user.role == 'PENDING') emit(AuthPending(user));
        else if (user.role == 'USER') emit(AuthAuthenticated(user));
        else emit(AuthUnauthenticated());
      },
    );
  }

  Future<void> silentRoleCheck() async {
    const storage = FlutterSecureStorage();
    final password = await storage.read(key: AppConstants.passwordUserKey);
    final phone = await storage.read(key: AppConstants.phoneUserKey);
    if (password == null || phone == null) return;
    final fcmToken = await _getFcmToken();
    final res = await loginUsecase(LoginParams(
      phoneNumber: phone,
      password: password,
      fcmToken: fcmToken,
    ));
    res.fold(
          (_) => null,
          (user) {
        user.role == 'USER' ? emit(AuthAuthenticated(user)) : emit(AuthPending(user));
      },
    );
  }

  Future<bool> verifyPasswordSilently(String password) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      final fcmToken = await _getFcmToken();
      final result = await loginUsecase(LoginParams(
        phoneNumber: currentState.user.phone,
        password: password,
        fcmToken: fcmToken,
      ));
      return result.isRight();
    }
    return false;
  }

  Future<void> updatePassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    emit(AuthLoading());
    final result = await repository.updatePassword(
      phone: phone,
      otp: otp,
      newPassword: newPassword,
    );
    result.fold(
          (failure) => emit(AuthError(failure: failure)),
          (_) => emit(PasswordUpdatedSuccess()),
    );
  }

  Future<void> updateUserData({
    required String firstName,
    required String lastName,
    String? imagePath,
    String? existingImageUrl,
  }) async {
    emit(AuthLoading());
    try {
      FormData formData = FormData.fromMap({
        "first_name": firstName,
        "last_name": lastName,
      });
      if (imagePath != null && imagePath.isNotEmpty) {
        formData.files.add(MapEntry("profile_image", await MultipartFile.fromFile(imagePath, filename: "profile.jpg")));
      } else if (existingImageUrl != null) {
        final tempFile = await _downloadFile(existingImageUrl);
        if (tempFile != null) {
          formData.files.add(MapEntry("profile_image", await MultipartFile.fromFile(tempFile.path, filename: "profile.jpg")));
        }
      }
      if (formData.files.isEmpty) {
        emit(AuthError(failure: ServerFailure("Profile image is required")));
        return;
      }
      final result = await repository.updateProfile(formData);
      result.fold(
            (failure) => emit(AuthError(failure: failure)),
            (user) {
          sl<AuthLocalDatasource>().cacheUser(user);
          emit(AuthAuthenticated(user));
        },
      );
    } catch (e) {
      emit(AuthError(failure: ServerFailure(e.toString())));
    }
  }

  Future<File?> _downloadFile(String url) async {
    try {
      final token = await sl<AuthLocalDatasource>().getCachedToken();
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
        ),
      );
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await file.writeAsBytes(response.data);
      return file;
    } catch (_) {
      return null;
    }
  }
}