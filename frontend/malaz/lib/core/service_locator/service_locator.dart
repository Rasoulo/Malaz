import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../data/datasources/remote/apartment_remote_data_source.dart';
import '../../data/repositories/apartment_repository_impl.dart';
import '../../domain/repositories/apartment_repository.dart';
import '../../domain/usecases/apartments_use_case.dart';
import '../../presentation/cubits/home/home_cubit.dart';
import '../../presentation/cubits/language/language_cubit.dart';
import '../../presentation/cubits/theme/theme_cubit.dart';
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

  sl.registerLazySingleton<ApartmentRemoteDataSource>(
    () => ApartmentRemoteDataSourceImpl(networkService: sl()),
  );

  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerFactory(() => ThemeCubit(sl()));

  sl.registerFactory(() => LanguageCubit(sl()));

  sl.registerFactory(() => HomeCubit(getApartmentsUseCase: sl()));

  sl.registerLazySingleton(() => GetApartmentsUseCase(sl()));

  sl.registerLazySingleton<ApartmentRepository>(
      () => ApartmentRepositoryImpl(remoteDataSource: sl()));
}
