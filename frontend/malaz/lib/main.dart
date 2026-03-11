import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:malaz/presentation/cubits/search/search_cubit.dart';
import 'package:malaz/presentation/cubits/settings/settings_cubit.dart';
import 'package:malaz/presentation/cubits/theme/theme_cubit.dart';

import 'package:malaz/presentation/screens/auth/login/login_screen.dart';
import 'package:malaz/presentation/screens/auth/register/home_register_screen.dart';
import 'package:malaz/presentation/screens/home/home_screen.dart';
import 'package:malaz/presentation/screens/settings/settings_screen.dart';
import 'package:malaz/presentation/screens/splash_screen/splash_screen.dart';
import 'package:malaz/services/notification_service/notification_service.dart';

import 'core/config/routes/app_routes.dart';
import 'core/config/theme/app_theme.dart';

import 'core/service_locator/service_locator.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';


/// --- [GLOBAL] ---
///
/// [messengerKey]
/// A global key used to access the [ScaffoldMessengerState] from anywhere in the app.
/// This is helpful for showing SnackBars or alerts without needing to pass a [BuildContext].
/// ----------------------------------------------------------------------------
///
/// ---[FUNCTION] ---
///
/// [main]
/// The main entry point of the Flutter application.
///
/// - `WidgetsFlutterBinding.ensureInitialized()`: Ensures that the Flutter framework is fully initialized before calling native features.
/// - `await Firebase.initializeApp()`: Initializes Firebase services for the application.
/// - `FirebaseMessaging.onBackgroundMessage(...)`: Registers [_firebaseMessagingBackgroundHandler] to listen for background notifications.
/// - `await setUpServices()`: Asynchronously initializes dependency injection and core services using [get_it].
/// - `await NotificationService.requestPermission()`: Asks the user for permission to display notifications.
/// - `_fetchFCMToken()`: Retrieves the Firebase Cloud Messaging device token.
/// - `runApp(const RentalApp())`: Starts the application and displays the root widget [RentalApp].
///
/// [_fetchFCMToken]
/// An asynchronous function that waits for 2 seconds and then retrieves the Firebase Cloud Messaging (FCM) device token.
/// If successful, it prints the token to the console. This token is required to send targeted notifications to this specific device.
///
/// [_firebaseMessagingBackgroundHandler]
/// A background message handler for FCM.
/// It must be a top-level function annotated with `@pragma('vm:entry-point')` to ensure it executes correctly even when the app is terminated or running in the background.
///
/// [setupFirebaseListeners]
/// Configures event listeners for Firebase Cloud Messaging when the application is actively running:
/// - `FirebaseMessaging.onMessage.listen`: Handles notifications received while the app is in the foreground.
/// - `FirebaseMessaging.onMessageOpenedApp.listen`: Handles the event when a user taps on a notification to open the app.
/// ----------------------------------------------------------------------------
/// --- [CLASSES] ---
///
/// [RentalApp]
/// A [StatelessWidget] that acts as the root dependency provider of the application.
///
/// - [MultiBlocProvider]: Provides all the necessary BLoC (Business Logic Component) states to the widget tree.
///   This includes cubits like [ThemeCubit], [LanguageCubit], [HomeCubit], [AuthCubit], and many others related to features like bookings and properties.
///   Each Cubit is created using `sl<T>()`, which retrieves the registered instance from the service locator.
/// - `child: const RentalAppView()`: Renders the [RentalAppView] which contains the actual UI configuration.
///
/// [router]
/// A global instance of the application's routing configuration. It uses `buildAppRouter()` to define the navigation paths and screens.
///
/// [RentalAppView]
/// A [StatelessWidget] that builds the main [MaterialApp] and configures global UI settings.
///
/// - `WidgetsBinding.instance.addPostFrameCallback`: Ensures that the [NotificationService] is initialized immediately after the first frame renders.
/// - `context.watch<ThemeCubit>().state` & `context.watch<LanguageCubit>().state`: Listens to changes in theme and language. The widget rebuilds whenever these states change.
/// - [MaterialApp.router]: The main application shell using router-based navigation.
///   - [scaffoldMessengerKey]: Attaches the global [messengerKey] for displaying SnackBars.
///   - [theme], [darkTheme], [themeMode]: Applies the current theme based on the user's choice.
///   - [locale], [supportedLocales], [localizationsDelegates]: Configures the app's language and translations.
///   - [localeResolutionCallback]: Determines the best matching language for the user's device.
///   - [routerConfig]: Applies the [router] for navigating between screens.
///   --------------------------------------------------------------------------

final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await setUpServices();

  await NotificationService.requestPermission();

  _fetchFCMToken();

  runApp(const RentalApp());
}

Future<void> _fetchFCMToken() async {
  try {
    await Future.delayed(const Duration(seconds: 2));
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      print("[FCM DEVICE TOKEN]: $token");
    }
  } catch (e) {
    print(">>>> Exception occurred at fetch FCM Token: $e");
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("🔔 [FCM Background] استلام إشعار في الخلفية");
  print("🔔 [FCM Background] العنوان: ${message.notification?.title}");
  print("🔔 [FCM Background] البيانات (Data): ${message.data}");
}

void setupFirebaseListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("🔔 [FCM Foreground] استلام إشعار والتطبيق مفتوح!");
    print("🔔 [FCM Foreground] العنوان: ${message.notification?.title}");
    if (message.notification != null) {
      print("🔔 [FCM Foreground] محتوى الإشعار موجود وسيتم عرضه");
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("🔔 [FCM Opened] تم الضغط على الإشعار وفتح التطبيق");
    print("🔔 [FCM Opened] البيانات المرسلة: ${message.data}");
  });
}
class RentalApp extends StatelessWidget {
  const RentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ThemeCubit>()),
        BlocProvider(create: (context) => sl<LanguageCubit>()),
        BlocProvider(create: (context) => sl<SettingsCubit>()),
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
        BlocProvider(
          create: (context) => sl<SearchCubit>(),
          child: const HomeScreen(),
        )
      ],
      child: const RentalAppView(),
    );
  }
}

final router = buildAppRouter();

class RentalAppView extends StatelessWidget {
  const RentalAppView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.initialize(context);
    });
    final themeState = context.watch<ThemeCubit>().state;
    final languageState = context.watch<LanguageCubit>().state;

    return MaterialApp.router(
      scaffoldMessengerKey: messengerKey,
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