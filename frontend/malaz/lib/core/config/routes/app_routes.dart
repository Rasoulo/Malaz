import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/presentation/screens/auth/register/home_register_screen.dart';
import 'package:malaz/presentation/screens/details/details_screen.dart';
import 'package:malaz/presentation/screens/splash_screen/splash_screen.dart';
import 'package:malaz/presentation/screens/auth/login/login_screen.dart';
import 'package:malaz/presentation/screens/main_wrapper/main_wrapper.dart'; // الشاشة الرئيسية
import 'package:malaz/presentation/screens/settings/settings_screen.dart';

import '../../../domain/entities/apartment.dart';


final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// *[GoRouter]
/// GoRouter is a package for Flutter that makes navigation easier.
/// It uses URLs (like a website) to manage your app's screens.
///
/// *[Features_of_GoRouter]:
/// 1.  URL-based Navigation: You define a path (like '/home' or '/details/1') for each screen.
/// 2.  Handles Platform Back Button: It correctly handles the back button on Android and web.
/// 3.  Passing Parameters: You can easily pass data to your routes, either in the path ('/user/:id') or as an [extra] object.
/// 4.  Deep Linking: Allows users to open a specific screen in your app from a URL link.
///
/// *[How_to_use_it]:
/// 1.  [initialLocation]: This is the first route the app will show, usually '/'.
/// 2.  [routes]: This is a list of [GoRoute] objects. Each [GoRoute] defines a screen.
/// 3.  [GoRoute]:
///     - [path]: The URL-like string for the screen.
///     - [name]: An optional, unique name for the route. You can navigate using this name.
///     - [builder]: A function that returns the widget (screen) for this route.
///
/// *[Adding_a_route_WITHOUT_parameters]:
/// This is a simple route. When you navigate to '/settings', it shows the [SettingsScreen].
/// GoRoute(path: '/settings', name: 'settings', builder: (context, state) => const SettingsScreen()),
/// To navigate to it: `context.go('/settings')` or `context.goNamed('settings')`
///
/// *[Adding_a_route_WITH_parameters]:
/// In this example, we pass an [Apartment] object to the [details] screen using the [extra] property.
/// GoRoute(path: '/details', name: 'details', builder: (context, state) => DetailsScreen(apartment: state.extra as Apartment)),
/// To navigate to it: `context.go('/details', extra: myApartmentObject)`
/// :)
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const MainWrapper(),
    ),

    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    
    GoRoute(
      path: '/details',
      name: 'details',
      builder: (context, state) {
        final apartment = state.extra as Apartment;
        return DetailsScreen(apartment: apartment);
      }
    ),

    GoRoute(
      path: '/home_register',
      name: 'home_register',
      builder: (context, state) => HomeRegisterScreen()
    )
  ],
);