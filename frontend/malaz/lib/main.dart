import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:malaz/presentation/cubits/auth/auth_cubit.dart';
import 'package:malaz/presentation/cubits/booking/booking_cubit.dart';
import 'package:malaz/presentation/cubits/booking/manage_booking.dart';
import 'package:malaz/presentation/cubits/booking/my_booking.dart';
import 'package:malaz/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:malaz/presentation/cubits/chat/chat_cubit.dart';

import 'package:malaz/presentation/cubits/home/home_cubit.dart';
import 'package:malaz/presentation/cubits/language/language_cubit.dart';
import 'package:malaz/presentation/cubits/location/location_cubit.dart';
import 'package:malaz/presentation/cubits/property/property_cubit.dart';
import 'package:malaz/presentation/cubits/review/review_cubit.dart';
import 'package:malaz/presentation/cubits/theme/theme_cubit.dart';

import 'package:malaz/presentation/screens/auth/login/login_screen.dart';
import 'package:malaz/presentation/screens/auth/register/home_register_screen.dart';
import 'package:malaz/presentation/screens/settings/settings_screen.dart';
import 'package:malaz/presentation/screens/splash_screen/splash_screen.dart';

import 'core/config/routes/app_routes.dart';
import 'core/config/theme/app_theme.dart';

import 'core/service_locator/service_locator.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';


/// [main]
///
/// - `WidgetsFlutterBinding.ensureInitialized():` Ensures that the Flutter framework is initialized.
///   This is required before calling native Flutter functions (like [runApp]).
///
/// - `await setUpServices()`: Calls an asynchronous function to set up and initialize
///   the application's services, such as dependency injection using [get_it].
///
/// - `runApp(const RentalApp())`: Starts the application by displaying the root widget [RentalApp].
///
/// [RentalApp] is a StatelessWidget that serves as the application's root.
///
/// - [MultiBlocProvider]: Provides multiple BLoC states to the widget tree.
///   This allows descendant widgets to access [ThemeCubit], [LanguageCubit], and [HomeCubit].
///   Each Cubit is created using `sl<T>()`, which fetches the registered service instance
///   from the service locator.
///
/// - `child: const RentalAppView()`: Renders [RentalAppView] as its child widget.
///
/// [RentalAppView] is a StatelessWidget that builds the main UI of the app.
///
/// - `context.watch<ThemeCubit>().state` & `context.watch<LanguageCubit>().state`:
///   These lines listen for changes in [ThemeCubit] and [LanguageCubit].
///   When the state of either cubit changes, Flutter rebuilds this widget.
///
/// - [MaterialApp]: The main widget that wraps a number of widgets required for
///   Material Design applications.
///   - [title]: The app title used by the operating system.
///   - [debugShowCheckedModeBanner]: Hides the "Debug" banner in the top-right corner.
///   - [theme] & [darkTheme]: Define the light and dark themes for the app.
///   - [themeMode]: Controls which theme to use (light, dark, or system) based on the [ThemeCubit]'s state.
///   - [locale]: Sets the app's current language based on the [LanguageCubit]'s state.
///   - [supportedLocales]: A list of languages supported by the app.
///   - [localizationsDelegates]: Provides translations and localized content for the app.
///   - [localeResolutionCallback]: Logic to determine the best supported locale based on the device's locale.
///   - [routes]: Defines the named navigation routes in the app, allowing navigation to screens
///     like [LoginScreen], [HomeRegisterScreen], and [SettingsScreen].
///   - [home]: The widget displayed when the app starts, which is [SplashScreen] here.
///
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setUpServices();

  runApp(const RentalApp());
}

class RentalApp extends StatelessWidget {
  const RentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ThemeCubit>()),
        BlocProvider(create: (context) => sl<LanguageCubit>()),
        BlocProvider(create: (context) => sl<HomeCubit>()),
        BlocProvider(create: (context) => sl<FavoritesCubit>()..loadFavorites()),
        BlocProvider.value(value: sl<AuthCubit>()),
        BlocProvider(create: (context) => sl<ChatCubit>()),
        BlocProvider(create: (context) => sl<AddApartmentCubit>()),
        BlocProvider(create: (context) => sl<MyApartmentsCubit>()),
        BlocProvider(create: (context) => sl<BookingCubit>()),
        BlocProvider(create: (context) => sl<LocationCubit>()..loadSavedLocation(),),
        BlocProvider(create: (context) => sl<ManageBookingCubit>()),
        BlocProvider(create: (context) => sl<MyBookingCubit>()),
        BlocProvider(create: (context) => sl<ManageBookingCubit>()),
        BlocProvider(create: (context) => sl<ReviewsCubit>()),
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

    final router = buildAppRouter();

    return MaterialApp.router(
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
      routerConfig: router,
    );
  }
}
