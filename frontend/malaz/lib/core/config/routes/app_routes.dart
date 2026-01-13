// core/config/routes
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/presentation/cubits/auth/auth_cubit.dart';
import 'package:malaz/presentation/screens/auth/my_profile/screen/my_profile_screen.dart';
import 'package:malaz/presentation/screens/auth/register/home_register_screen.dart';
import 'package:malaz/presentation/screens/chats/ChatWithAPerson.dart';
import 'package:malaz/presentation/screens/details/details_screen.dart';
import 'package:malaz/presentation/screens/favorites/favorites_screen.dart';
import 'package:malaz/presentation/screens/property/add_property.dart';
import 'package:malaz/presentation/screens/splash_screen/splash_screen.dart';
import 'package:malaz/presentation/screens/auth/login/login_screen.dart';
import 'package:malaz/presentation/screens/main_wrapper/main_wrapper.dart'; // الشاشة الرئيسية
import 'package:malaz/presentation/screens/settings/settings_screen.dart';
import 'package:path/path.dart';

import '../../../domain/entities/apartment/apartment.dart';
import '../../../presentation/screens/auth/reset_password_screen/ResetPasswordScreen.dart';
import '../../../presentation/screens/auth/under_review/under_review.dart';
import '../../service_locator/service_locator.dart';

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

final AuthCubit authCubit = sl<AuthCubit>();
GoRouter buildAppRouter() {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final authState = authCubit.state;

      final goingToLogin = state.matchedLocation == '/login';
      final goingToRegister = state.matchedLocation == '/home_register';
      final goingToPending = state.matchedLocation == '/pending';
      final goingToSplash = state.matchedLocation == '/';

      /// 1️⃣ أثناء التحميل أو البداية → Splash
      if (authState is AuthInitial) {
        return goingToSplash ? null : '/';
      }

      /// 2️⃣ PENDING له أولوية مطلقة
      else if (authState is AuthPending) {
        return goingToPending ? null : '/pending';
      }

      /// 3️⃣ Authenticated
      else if (authState is AuthAuthenticated) {
        if (goingToLogin || goingToRegister || goingToSplash || goingToPending) {
          return '/home';
        }
        return null;
      }

      /// 4️⃣ Unauthenticated / Error
      else if (authState is AuthUnauthenticated || authState is AuthError) {
        return (goingToLogin || goingToRegister) ? null : '/login';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => LoginScreen(formKey: GlobalKey<FormState>()),
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: LoginScreen(formKey: GlobalKey<FormState>()),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
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
      ),

      GoRoute(
        path: '/pending',
        name: 'pending',
        builder: (context, state) => UnderReview(),
      ),

      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MyProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: animation.drive(
                  Tween(begin: const Offset(0.1, 0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeOutCubic)),
                ),
                child: child,
              ),
            );
          },
        ),
      ),

      GoRoute(
        path: '/one_chat',
        name: 'one_chat',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;

          return ChatWithAPerson(
            conversationId: extras['id'] as int,
            firstName: extras['firstName'] as String,
            lastName: extras['lastName'] as String,
            otherUserId: extras['otherUserId'] as int,
          );
        },
      ),

      GoRoute(
        path: '/reset-password',
        builder: (context, state) => ResetPasswordScreen(phoneNumber: state.extra as String),
      ),

      GoRoute(
        path: '/favorites',
        builder: (context, state) => FavoritesScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error.toString()}'),
      ),
    ),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription _subscription;
}
