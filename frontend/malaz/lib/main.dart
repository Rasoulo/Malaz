
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/data/datasources/apartment_remote_data_source.dart';
import 'package:malaz/data/repositories/apartment_repository_impl.dart';
import 'package:malaz/domain/usecases/get_apartments_usecase.dart';
import 'package:malaz/l10n/app_localizations.dart';
import 'package:malaz/presentation/cubits/home/home_cubit.dart';
import 'package:malaz/presentation/cubits/language/language_cubit.dart';
import 'package:malaz/presentation/cubits/theme/theme_cubit.dart';
import 'package:malaz/presentation/screens/auth/login/login_screen.dart';
import 'package:malaz/presentation/screens/settings/settings_screen.dart';
import 'package:malaz/presentation/screens/splash%20screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/config/theme/app_theme.dart';

/// [main]
/// here i will elaborate everything about main function :)
///
/// [WidgetsFlutterBinding.ensureInitialized() => make sure every thing need to
/// initialized is actually initialized, why ? search for it
///
/// [SharedPreferences] => with this class we can storage in memory, we use this
/// for storaging selected theme mode and language
///
/// [A] => a relative for service allocator, i have no idea if we will use this
/// approach or service allocator approach each has it's weakness points
///
/// [note] => something ambiguous ? ask on the group :D
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  /// [A]
  final ApartmentRemoteDataSource apartmentRemoteDataSource = ApartmentRemoteDataSourceImpl();
  final ApartmentRepositoryImpl apartmentRepository = ApartmentRepositoryImpl(remoteDataSource: apartmentRemoteDataSource);
  final GetApartmentsUseCase getApartmentsUseCase = GetApartmentsUseCase(apartmentRepository);

  runApp(RentalApp(
    prefs: prefs,
    getApartmentsUseCase: getApartmentsUseCase,
  ));
}

class RentalApp extends StatelessWidget {
  final SharedPreferences prefs;
  final GetApartmentsUseCase getApartmentsUseCase;

  const RentalApp({
    super.key,
    required this.prefs,
    required this.getApartmentsUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit(prefs)),
        BlocProvider(create: (context) => LanguageCubit(prefs)),
        BlocProvider(create: (context) => HomeCubit(getApartmentsUseCase: getApartmentsUseCase)),
      ],
      child: const RentalAppView(),
    );
  }
}

class RentalAppView extends StatelessWidget {
  const RentalAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final languageState = context.watch<LanguageCubit>().state;

    return MaterialApp(
      title: 'Malaz Rental',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.themeMode,
      locale: languageState.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      routes: {
        '/login': (context) => const LoginScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
      home: const SplashScreen(),
    );
  }
}
