

import 'package:dio/dio.dart';

/// [NetWorkService]
///
/// Controls the dealing with dio.
/// why this is useful ? if we need to change any thing about network and we use
/// network queries over 50 places in the project we can only change it here and
/// it's automatically updated in all places.
/// *[baseUrl]
/// - on physical phone = http://10.0.2.2:your_lab_ib/api
/// - on android emulator = http://10.0.2.2:8000/api
/// *[crucial_notes] :
/// - do not commit this file after hamwi's commit
/// - put your baseurl according to your situation
/// :)
abstract class NetworkService {
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters});

  Future<Response> post(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters});
}
const baseurl = 'http://192.168.1.102:8000/api/users/'; // ! this baseurl works only for abrar
class NetworkServiceImpl implements NetworkService {
  final Dio _dio;

  NetworkServiceImpl()
      : _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:103/api", // ! this baseurl works only for hamwi

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },

      receiveTimeout: const Duration(minutes: 2),
      connectTimeout: const Duration(minutes: 2),
    ),
  ) {

    /// do not touch it, it's just for debugging
    // _dio.interceptors.add(LogInterceptor(
    //   request: true,
    //   requestHeader: true,
    //   requestBody: true,
    //   responseHeader: true,
    //   responseBody: true,
    //   error: true,
    // ));
  }

  @override
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(endpoint, queryParameters: queryParameters);
  }

  @override
  Future<Response> post(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.post(endpoint, data: data, queryParameters: queryParameters);
  }
}
