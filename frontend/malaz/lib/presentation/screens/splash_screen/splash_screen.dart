import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../global_widgets/build_branding.dart';

/// [SplashScreen]
///
/// An animated splash_screen that displays a logo and branding
/// before transitioning to the main application.
/// the main purpose of this screen is to load vital data from the server
/// moreover, it impacts an awesome user experience
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// [SingleTickerProviderStateMixin]
///
/// To make the UI draw it self ~60 times per second
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _fadeAnimation;

  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _fadeAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          context.go('/login');
        }
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          _BuildAnimatedLogoAndLoader(
            fadeAnimation: _fadeAnimation,
            scaleAnimation: _scaleAnimation,
          ),
          BuildBranding(),
        ],
      ),
    );
  }
}

/// [_BuildAnimatedLogoAndLoader]
///
/// A private widget class responsible for building the centered, animated logo
/// and the loading indicator.
class _BuildAnimatedLogoAndLoader extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  const _BuildAnimatedLogoAndLoader({
    required this.fadeAnimation,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: scaleAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Image.asset(
                'assets/icons/key_logo.png',
                width: 150,
                height: 150,
              ),
            ),
          ),
          const SizedBox(height: 32),
          FadeTransition(
            opacity: CurvedAnimation(
              parent: fadeAnimation,
              curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
            ),
            child: SizedBox(
              width: 120,
              child: LinearProgressIndicator(
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
                minHeight: 2.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
