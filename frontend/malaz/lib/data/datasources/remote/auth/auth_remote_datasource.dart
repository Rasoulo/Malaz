import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/constants/app_constants.dart';
import 'package:malaz/core/errors/exceptions.dart';
import 'package:path/path.dart';

import '../../../../core/network/network_service.dart';
import '../../../models/user/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
    required String fcmToken,
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
    required String fcmToken,
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
    required String fcmToken,
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
        'fcm_token': fcmToken,
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
    required String fcmToken,
  }) async {
    final endpoint = '/users/login';

    final response = await networkService.post(
      endpoint,
      data: {
        'phone': phone,
        'password': password,
        'fcm_token': fcmToken
      },
    );

    final data = response.data;
    if (data != null && data['user'] != null) {
      print('Phone from server: ${data['user']['phone']}');
    }
    String? message = data is Map<String, dynamic> ? data['message']?.toString() : null;

    if (response.statusCode == 200 && (data['data'] != null || data['access_token'] != null)) {
      return data;
    }

    if (message != null) {
      final msgLower = message.toLowerCase();

      if (msgLower.contains('wait until') || msgLower.contains('pending')) {
        throw PendingApprovalException(message);
      }

      if (msgLower.contains('does not exist') || msgLower.contains('not found')) {
        throw PhoneNotFoundException(message);
      }

      if (msgLower.contains('invalid') || msgLower.contains('wrong password')) {
        throw WrongPasswordException(message);
      }
    }

    throw ServerException(message: message ?? "حدث خطأ غير متوقع");
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
        throw ServerException(message: 'No Data');
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
          'new_password_confirmation': newPassword,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
