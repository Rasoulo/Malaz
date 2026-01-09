// core/network/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:malaz/data/datasources/local/auth/auth_local_data_source.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDatasource localDatasource;

  AuthInterceptor({required this.localDatasource});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await localDatasource.getCachedToken();
      print('token is $token');
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      /// ignore caching errors here
    }
    handler.next(options);
  }
}
