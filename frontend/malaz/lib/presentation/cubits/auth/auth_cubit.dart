import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/domain/entities/user_entity.dart';
import 'package:malaz/domain/usecases/auth/check_auth_usecase.dart';
import 'package:malaz/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:malaz/domain/usecases/auth/login_usecase.dart';
import 'package:malaz/domain/usecases/auth/logout_usecase.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/errors/failures.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/datasources/local/auth_local_datasource.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../domain/usecases/auth/send_otp_usecase.dart';
import '../../../domain/usecases/auth/verify_otp_usecase.dart';

// --- States --- //

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
  final String message;
  AuthError({required this.message});
  @override
  List<Object?> get props => [message];
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

  AuthCubit(
      {required this.loginUsecase,
      required this.logoutUsecase,
      required this.getCurrentUserUsecase,
      required this.checkAuthUsecase,
      required this.registerUsecase,
      required this.sendOtpUsecase,
      required this.verifyOtpUsecase,
      required this.repository}) : super(AuthInitial());

  Future<void> checkAuth() async {
    final res = await checkAuthUsecase(NoParams());

    res.fold(
          (_) {
        if (state is AuthPending) return;
        emit(AuthUnauthenticated());
      },
          (status) {
        if (status.isPending && status.user != null) {
          emit(AuthPending(status.user!));
        } else if (status.isAuthenticated && status.user != null) {
          emit(AuthAuthenticated(status.user!));
        } else {
          if (state is AuthPending) return;
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
      ));
      print('>>>> ${res}');
      res.fold(
        (failure) {
          emit(AuthError(message: _mapFailureToMessage(failure)));
          emit(AuthUnauthenticated());
        },
        (user) async {
          final storage = FlutterSecureStorage();
          await storage.write(key: '_USER_PASSWORD', value: password);
          await storage.write(key: '_USER_PHONE', value: phone);

          final role = user.role.toLowerCase();
          if (role == 'pending') {
            emit(AuthPending(user));
          } else {
            emit(AuthAuthenticated(user));
          }
        },
      );
    } catch (e) {
      emit(AuthError(message: 'Error preparing images: $e'));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login({required String phone, required String password,}) async {
    emit(AuthLoading());

    final res = await loginUsecase(
      LoginParams(phoneNumber: phone, password: password),
    );

    res.fold(
          (failure) {
        if (failure is PendingApprovalFailure) {
          emit(AuthPending(
            UserEntity.emptyPending(),
          ));
        } else if (failure is PhoneNotFoundFailure) {
          emit(AuthError(
            message: 'This phone number does not exist in our records.',
          ));
        } else if (failure is WrongPasswordFailure) {
          emit(AuthError(message: 'Invalid credentials'));
        } else {
          emit(AuthError(message: _mapFailureToMessage(failure)));
        }
      },
          (user) async {
        if (user.role.toUpperCase() == 'PENDING') {
          final storage = FlutterSecureStorage();
          await storage.write(key: '_USER_PASSWORD', value: password);
          await storage.write(key: '_USER_PHONE', value: phone);
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
          (failure) => emit(AuthError(message:failure.message ?? "Logout Failed")),
          (_) {
        emit(AuthUnauthenticated());
      },
    );
  }

  Future<void> sendOtp(String phone) async {
    emit(OtpSending());
    final res = await sendOtpUsecase(SendOtpParams(phone));
    res.fold(
      (failure) => emit(OtpSendError(_mapFailureToMessage(failure))),
      (_) => emit(OtpSent()),
    );
  }

  Future<void> verifyOtp(String phone, String otp) async {
    emit(OtpVerifying());
    final res = await verifyOtpUsecase(VerifyOtpParams(phone: phone, otp: otp));
    res.fold(
      (failure) => emit(OtpVerifyError(_mapFailureToMessage(failure))),
      (success) {
        if (success)
          emit(OtpVerified());
        else
          emit(OtpVerifyError('Invalid code'));
      },
    );
  }

  Future<void> sendPasswordResetOtp(String phone) async {
    emit(AuthLoading());

    final result = await repository.sendPasswordResetOtp(phone);

    result.fold(
          (failure) => emit(AuthError(message: failure.message.toString())),
          (message) => emit(OtpSentSuccess()),
    );
  }

  Future<void> checkRoleUsingLogin({required String phone, required String password}) async {
    emit(AuthLoading());

    final res = await loginUsecase(
      LoginParams(phoneNumber: phone, password: password),
    );

    res.fold(
      (failure) {
        emit(AuthError(message: _mapFailureToMessage(failure)));
      },
      (user) {
        if (user.role == 'PENDING') {
          emit(AuthPending(user));
        } else if (user.role == 'USER') {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> silentRoleCheck() async {
    final storage = FlutterSecureStorage();
    final password = await storage.read(key: '_USER_PASSWORD');
    final phone = await storage.read(key: '_USER_PHONE');

    final res = await loginUsecase(
      LoginParams(phoneNumber: phone.toString(), password: password.toString()),
    );

    res.fold(
          (failure) {
        debugPrint("Silent check failed: ${_mapFailureToMessage(failure)}");
      },
          (user) {
        if (user.role == 'USER') {
          emit(AuthAuthenticated(user));
        } else if (user.role == 'PENDING') {
          emit(AuthPending(user));
        }
      },
    );
  }

  Future<bool> verifyPasswordSilently(String password) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      final result = await loginUsecase(LoginParams(
        phoneNumber: currentState.user.phone,
        password: password,
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
          (failure) => emit(AuthError(message: failure.message.toString())),
          (message) => emit(PasswordUpdatedSuccess()), // حالة نجاح جديدة
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
        formData.files.add(MapEntry(
          "profile_image",
          await MultipartFile.fromFile(imagePath, filename: "new_profile.jpg"),
        ));
      } else if (existingImageUrl != null) {
        final File? tempFile = await _downloadFile(existingImageUrl);
        if (tempFile != null) {
          formData.files.add(MapEntry(
            "profile_image",
            await MultipartFile.fromFile(tempFile.path, filename: "existing_profile.jpg"),
          ));
        }
      }

      print("Final Check - Files count: ${formData.files.length}");

      if (formData.files.isEmpty) {
        emit(AuthError(message: "Profile image is required by the server."));
        return;
      }

      final result = await repository.updateProfile(formData);

      result.fold(
            (failure) => emit(AuthError(message: failure.message.toString())),
            (user) {
          sl<AuthLocalDatasource>().cacheUser(user);
          emit(AuthAuthenticated(user));
        },
      );
    } catch (e) {
      emit(AuthError(message: "Update Error: ${e.toString()}"));
    }
  }

  Future<File?> _downloadFile(String url) async {
    try {
      final token = await sl<AuthLocalDatasource>().getCachedToken();

      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/temp_profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await file.writeAsBytes(response.data);

      print("Download Success. File size: ${await file.length()} bytes");
      return file;
    } catch (e) {
      print("Download error in _downloadFile: $e");
      return null;
    }
  }

  Future<void> saveAddressLocally(String address) async {
    await sl<AuthLocalDatasource>().cacheUserAddress(address);
  }

  String _mapFailureToMessage(Failure f) {
    if (f is PhoneNotFoundFailure)
      return 'This phone number does not exist in our records.';
    if (f is WrongPasswordFailure) return 'Incorrect Password';
    if (f is InvalidCredentialsFailure) return 'Invalid credentials';
    if (f is ServerFailure) return (f.message ?? 'Server error');
    if (f is NetworkFailure) return 'Check your internet connection';
    return 'An unexpected error occurred';
  }
}
