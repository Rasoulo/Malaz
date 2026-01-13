import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:location/location.dart';
import 'package:malaz/data/datasources/local/auth/auth_local_data_source.dart';
import 'package:malaz/data/datasources/remote/booking/booking_remote_data_source.dart';
import 'package:malaz/data/datasources/remote/favorites/favorites_remote_datasource.dart';
import 'package:malaz/data/datasources/remote/review/review_remote_data_source.dart';
import 'package:malaz/data/repositories/auth/auth_repository_impl.dart';
import 'package:malaz/data/repositories/booking/booking_repository_impl.dart';
import 'package:malaz/data/repositories/review/review_repository_impl.dart';
import 'package:malaz/domain/repositories/auth/auth_repository.dart';
import 'package:malaz/domain/repositories/booking/booking_repository.dart';
import 'package:malaz/domain/repositories/review/review_repository.dart';
import 'package:malaz/domain/usecases/auth/check_auth_usecase.dart';
import 'package:malaz/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:malaz/domain/usecases/auth/login_usecase.dart';
import 'package:malaz/domain/usecases/auth/logout_usecase.dart';
import 'package:malaz/domain/usecases/booking/Get_Booked_Dates_Use_Case.dart';
import 'package:malaz/domain/usecases/booking/make_book_use_case.dart';
import 'package:malaz/domain/usecases/booking/update_status_use_case.dart';
import 'package:malaz/domain/usecases/review/get_review_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../data/datasources/local/location/location_local_data_source.dart';
import '../../data/datasources/remote/apartment/apartment_remote_data_source.dart';
import '../../data/datasources/remote/auth/auth_remote_datasource.dart';
import '../../data/datasources/remote/chat/chat_remote_datasource.dart';
import '../../data/datasources/remote/location/location_remote_data_source.dart';
import '../../data/repositories/apartment/apartment_repository_impl.dart';
import '../../data/repositories/chat/chat_repository_impl.dart';
import '../../data/repositories/favorites/favorites_repository_impl.dart';
import '../../data/repositories/location/location_repository_impl.dart';
import '../../domain/repositories/apartment/apartment_repository.dart';
import '../../domain/repositories/chat/chat_repository.dart';
import '../../domain/repositories/favorites/favorites_repository.dart';
import '../../domain/repositories/location/location_repository.dart';
import '../../domain/usecases/apartment/add_apartment_use_case.dart';
import '../../domain/usecases/apartment/my_apartment_use_case.dart';
import '../../domain/usecases/auth/send_otp_usecase.dart';
import '../../domain/usecases/auth/verify_otp_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/booking/all_booking_use_case.dart';
import '../../domain/usecases/favorites/add_favorites_use_case.dart';
import '../../domain/usecases/favorites/delete_favorites_use_case.dart';
import '../../domain/usecases/favorites/get_favorites_use_case.dart';
import '../../domain/usecases/home/apartments_use_case.dart';
import '../../domain/usecases/location/get_current_location_usecase.dart';
import '../../domain/usecases/location/load_saved_location_usecase.dart';
import '../../domain/usecases/location/update_manual_location_usecase.dart';
import '../../presentation/cubits/auth/auth_cubit.dart';
import '../../presentation/cubits/booking/booking_cubit.dart';
import '../../presentation/cubits/booking/manage_booking.dart';
import '../../presentation/cubits/chat/chat_cubit.dart';
import '../../presentation/cubits/favorites/favorites_cubit.dart';
import '../../presentation/cubits/home/home_cubit.dart';
import '../../presentation/cubits/language/language_cubit.dart';
import '../../presentation/cubits/location/location_cubit.dart';
import '../../presentation/cubits/property/property_cubit.dart';
import '../../presentation/cubits/review/review_cubit.dart';
import '../../presentation/cubits/theme/theme_cubit.dart';
import '../network/auth_interceptor.dart';
import '../network/network_info.dart';
import '../network/network_service.dart';
import 'package:http/http.dart' as http;

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
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<Location>(() => Location());

  sl.registerLazySingleton<NetworkService>(() => NetworkServiceImpl(sl()));


  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerFactory(() => ThemeCubit(sl()));

  sl.registerFactory(() => LanguageCubit(sl()));

  sl.registerFactory(() => BookingCubit(sl<GetBookedDatesUseCase>(), sl<MakeBookUseCase>(),));
  sl.registerFactory(() => ReviewsCubit(sl()));

  sl.registerFactory(() => ManageBookingCubit(
    sl<GetUserBooking>(),
    sl<UpdateStatus>(),
  ));

  sl.registerFactory(() => HomeCubit(getApartmentsUseCase: sl()));
  sl.registerLazySingleton(() => FavoritesCubit(getFavoritesUseCase: sl(),addFavoriteUseCase: sl(), deleteFavoriteUseCase: sl()));

  sl.registerLazySingleton(() => AddApartmentUseCase(sl()));

  sl.registerLazySingleton(() => GetMyApartmentsUseCase(sl()));

  sl.registerLazySingleton(() => GetApartmentsUseCase(sl()));

  sl.registerLazySingleton<GetReviewsUseCase>(() => GetReviewsUseCase(sl()));

  sl.registerLazySingleton<ReviewsRepository>(() => ReviewsRepositoryImpl(networkInfo: sl(), remoteDataSource:  sl()));

  sl.registerLazySingleton<ReviewsRemoteDataSource>(() => ReviewsRemoteDataSourceImpl(networkService: sl()));

  sl.registerLazySingleton<ApartmentRepository>(() => ApartmentRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<FavoritesRepository>(() => FavoritesRepositoryImpl(sl()));
  sl.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl(sl()));

  sl.registerFactory(() => AddApartmentCubit(addApartmentUseCase: sl()));

  sl.registerFactory(() => MyApartmentsCubit(getMyApartmentsUseCase: sl()));

  sl.registerLazySingleton<ApartmentRemoteDataSource>(() => ApartmentRemoteDataSourceImpl(networkService: sl()));

  sl.registerLazySingleton<AuthLocalDatasource>(() => AuthLocalDatasourceImpl(sl<SharedPreferences>()),);
  sl.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl(networkService: sl()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    authRemoteDatasource: sl(),
    authLocalDatasource: sl(),
  ));

  sl.registerLazySingleton<FavoritesRemoteDataSource>(() => FavoritesRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<BookingRemoteDataSource>(() => BookingRemoteDataSourceImpl(networkService: sl()));

  sl.registerLazySingleton(() => RegisterUsecase(repository: sl()));
  sl.registerLazySingleton(() => LoginUsecase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUsecase(repository: sl()));
  sl.registerLazySingleton(() => CheckAuthUsecase(repository: sl()));
  sl.registerLazySingleton(() => SendOtpUsecase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUsecase(sl()));
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => AddFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => DeleteFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => GetBookedDatesUseCase(sl()));
  sl.registerLazySingleton(() => MakeBookUseCase(sl()));
  sl.registerLazySingleton(() => GetUserBooking(sl()));
  sl.registerLazySingleton(() => UpdateStatus(sl()));
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

  sl.registerLazySingleton<LocationLocalDataSource>(() => LocationLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<LocationRemoteDataSource>(
        () => LocationRemoteDataSourceImpl(
      location: sl<Location>(),
      client: sl<http.Client>(),
    ),
  );
  sl.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
  ));

  sl.registerLazySingleton(() => GetCurrentLocationUseCase(sl()));
  sl.registerLazySingleton(() => LoadSavedLocationUseCase(sl()));
  sl.registerLazySingleton(() => UpdateManualLocationUseCase(sl()));
  sl.registerFactory(() => LocationCubit(
    getCurrentLocationUseCase: sl(),
    loadSavedLocationUseCase: sl(),
    updateManualLocationUseCase: sl(),
  ));
}