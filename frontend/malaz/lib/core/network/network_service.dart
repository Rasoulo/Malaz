

import 'package:dio/dio.dart';

/// [NetWorkService]
///
/// Controls the dealing with dio.
/// why this is useful ? if we need to change any thing about network and we use
/// network queries over 50 places in the project we can only change it here and
/// it's automatically updated in all places.
/// *[baseUrl]
/// - on physical phone = http://10.0.2.2:your_lab_ib/api
/// - on android emulator a= http://10.0.2.2:8000/pi
/// *[crucial_notes] :
/// - do not commit this file after hamwi's commit
/// - put your baseurl according to your situation
/// :)

import '../constants/app_constants.dart';
import '../errors/error_handler.dart';
import 'auth_interceptor.dart';
abstract class NetworkService {
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters});
  Future<Response> post(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<Response> put(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<Response> delete(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters});
}
const baseurl = 'http://192.168.1.103:8000/api/users/'; // ! this baseurl works only for hamwi
class NetworkServiceImpl implements NetworkService {
  final Dio _dio;
  final AuthInterceptor interceptor;

  NetworkServiceImpl(this.interceptor)
      : _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) => status != null && status < 500,
      followRedirects: false,
      receiveTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 30),
    ),
  ) {
    _dio.interceptors.add(interceptor);
  }

  @override
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<Response> post(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(endpoint, data: data, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<Response> put(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.put(endpoint, data: data, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<Response> delete(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.delete(endpoint, data: data, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
