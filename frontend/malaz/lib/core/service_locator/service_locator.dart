import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:malaz/data/datasources/local/auth_local_datasource.dart';
import 'package:malaz/data/repositories/auth_repository_impl.dart';
import 'package:malaz/domain/repositories/auth_repository.dart';
import 'package:malaz/domain/usecases/auth/check_auth_usecase.dart';
import 'package:malaz/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:malaz/domain/usecases/auth/login_usecase.dart';
import 'package:malaz/domain/usecases/auth/logout_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../data/datasources/remote/apartment_remote_data_source.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/chat_remote_datasource.dart';
import '../../data/repositories/apartment_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/apartment_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/auth/send_otp_usecase.dart';
import '../../domain/usecases/auth/verify_otp_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/home/apartments_use_case.dart';
import '../../presentation/cubits/auth/auth_cubit.dart';
import '../../presentation/cubits/chat/chat_cubit.dart';
import '../../presentation/cubits/home/home_cubit.dart';
import '../../presentation/cubits/language/language_cubit.dart';
import '../../presentation/cubits/theme/theme_cubit.dart';
import '../network/auth_interceptor.dart';
import '../network/network_info.dart';
import '../network/network_service.dart';

/// [GetIt] / [service_locator]
///
/// It's a dependency injection framework for Dart.
/// Think of it as a "Magic Box" where we put our tools (Services/Classes)
/// to retrieve them later anywhere in the app without creating them again.
///
/// *[Definitions]:
/// - [Lazy]: Create the object ONLY when you ask for it (saves memory).
/// - [Singleton]: Create ONE instance and reuse it everywhere (like one fridge for the whole house).
/// - [Factory]: Create a NEW instance every time you ask (like a new plate for every customer).
///
/// *[how_to_use]:
///
/// Instead of creating objects manually like:
/// `final dio = Dio();`  <-- Don't do this!
///
/// You just ask the Service Locator:
/// `final dio = sl<Dio>();`  <-- Do this!
///
/// *[Services_Registered]:
/// - [sharedPreferences]: For caching simple data (Theme, Token, Language).
/// - [Dio]: For network requests (The advanced HTTP client).
/// - [InternetConnectionChecker]: To check if there is REAL internet access.
/// - [NetworkInfo]: To handle connection checks cleanly.
/// - [ThemeCubit]: To handle theme changes.
/// - [LanguageCubit]: To handle language changes.
/// :)

final sl = GetIt.instance;

Future<void> setUpServices() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<Dio>(() => Dio());

  sl.registerLazySingleton<NetworkService>(() => NetworkServiceImpl(sl()));


  sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerFactory(() => ThemeCubit(sl()));

  sl.registerFactory(() => LanguageCubit(sl()));

  sl.registerFactory(() => HomeCubit(getApartmentsUseCase: sl()));

  sl.registerLazySingleton(() => GetApartmentsUseCase(sl()));

  sl.registerLazySingleton<ApartmentRepository>(() => ApartmentRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<ApartmentRemoteDataSource>(() => ApartmentRemoteDataSourceImpl(networkService: sl()));

  sl.registerLazySingleton<AuthLocalDatasource>(() => AuthLocalDatasourceImpl(sl<SharedPreferences>()),);
  sl.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl(networkService: sl()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    authRemoteDatasource: sl(),
    authLocalDatasource: sl(),
  ));

  sl.registerLazySingleton(() => RegisterUsecase(repository: sl()));
  sl.registerLazySingleton(() => LoginUsecase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUsecase(repository: sl()));
  sl.registerLazySingleton(() => CheckAuthUsecase(repository: sl()));
  sl.registerLazySingleton(() => SendOtpUsecase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUsecase(sl()));

  sl.registerLazySingleton(() => AuthInterceptor(localDatasource: sl()));

  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(
    repository: sl<AuthRepository>(),
    loginUsecase: sl(),
    logoutUsecase: sl(),
    getCurrentUserUsecase: sl(),
    checkAuthUsecase: sl(),
    registerUsecase: sl(),
    sendOtpUsecase: sl(),
    verifyOtpUsecase: sl(),
  ));


  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl(networkService: sl()),);
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(remoteDataSource: sl()),);
  sl.registerFactory(() => ChatCubit(repository: sl()));


}
