import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/constants/app_constants.dart';
import 'package:malaz/core/errors/exceptions.dart';
import 'package:path/path.dart';

import '../../../core/network/network_service.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../../domain/entities/user_entity.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  });

  Future<Map<String, dynamic>> registerUser({
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

  Future<void> logout();

  Future<void> sendOtp({required String phone});

  Future<Map<String, dynamic>> verifyOtp({required String phone, required String otp});

  Future<UserModel> updateProfile(FormData formData);

  Future<Map<String, dynamic>> sendPasswordResetOtp(String phone);

  Future<Map<String, dynamic>> updatePassword({
    required String phone,
    required String otp,
    required String newPassword,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final NetworkService networkService;

  AuthRemoteDatasourceImpl({required this.networkService});

  @override
  Future<Map<String, dynamic>> registerUser({
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
    final endpoint = '/users/register';

    try {
      final formData = FormData.fromMap({
        'phone': phone,
        'role': role,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'date_of_birth': dateOfBirth,
        'profile_image': await MultipartFile.fromFile(
          profileImage.path,
          filename: basename(profileImage.path),
        ),
        'identity_card_image': await MultipartFile.fromFile(
          identityImage.path,
          filename: basename(identityImage.path),
        ),
      });

      final response = await networkService.post(
        endpoint,
        data: formData,
      );
      return response.data as Map<String, dynamic>;
    } catch (e, stack) {
      print('REGISTER ERROR: $e');
      print(stack);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final endpoint = '/users/login';

    final response = await networkService.post(
      endpoint,
      data: {'phone': phone, 'password': password},
    );

    final data = response.data;
    String? message = data is Map<String, dynamic> ? data['message']?.toString() : null;

    if (response.statusCode == 200 && data['data'] != null) {
      return data;
    }

    /// TODO: merge to error handler
    if (message != null && message.toLowerCase().contains('wait until')) {
      throw PendingApprovalException(message);
    }

    if (data['access_token'] != null) {
      return data;
    }

    if (message != null && message.toLowerCase().contains('does not exist')) {
      throw PhoneNotFoundException(message);
    }

    if (message != null && message.toLowerCase().contains('invalid credentials')) {
      throw WrongPasswordException(message);
    }

    return data;
  }

  @override
  Future<void> logout() async {
    await networkService.post('/users/logout');
  }

  @override
  Future<void> sendOtp({required String phone}) async {
    try {
      final url = '${AppConstants.baseurl}/users/send-otp';
      final response = await networkService.post(url, queryParameters: {'phone': phone});
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw ServerException(message: 'sendOtp failed: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({required String phone, required String otp}) async {
    try {
      final url = '${AppConstants.baseurl}/users/verify-otp';
      final response = await networkService.post(url, queryParameters: {'phone': phone, 'otp': otp});
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> updateProfile(FormData formData) async {
    try {
      final response = await networkService.post(
        '/users/request-update',
        data: formData,
      );

      if (response.data != null) {
        return UserModel.fromJson(response.data['data'] ?? response.data);
      } else {
        throw ServerException(message: 'لم يتم استلام بيانات من السيرفر');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'];
      throw ServerException(message: errorMessage);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> sendPasswordResetOtp(String phone) async {
    try {
      final response = await networkService.post(
        '/users/send-otppassword',
        data: {'phone': phone},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updatePassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await networkService.post(
        '/users/change-password',
        data: {
          'phone': phone,
          'otp': otp,
          'new_password': newPassword,
          'new_password_confirmation': newPassword, // تأكد من مسمى الحقل في الباك إند
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
