import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> setUpServices() async {
  // 1. Core
  sl.registerLazySingleton(() => SharedPreferences.getInstance());
  sl.registerLazySingleton(() => Dio()); // RESTFUL API, Do not edit.

  // 2. Features - Auth
  // sl.registerFactory(() => AuthCubit(...));

  // 3. Features - Apartments
  // sl.registerFactory(() => HomeCubit(...));
}