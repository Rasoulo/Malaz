

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
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../errors/error_handler.dart';
abstract class NetworkService {
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters});
  Future<Response> post(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<Response> put(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<Response> delete(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters});
}

class NetworkServiceImpl implements NetworkService {
  final Dio _dio;
  final SharedPreferences _prefs;

  NetworkServiceImpl(this._prefs)
      : _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      receiveTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 30),
    ),
  ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _prefs.getString(AppConstants.tokenKey);

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
          onResponse: (response, handler) {
            return handler.next(response);
          }
      ),
    );

    // _dio.interceptors.add(LogInterceptor(
    //   requestBody: true,
    //   responseBody: true,
    // ));
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
