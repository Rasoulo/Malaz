import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/color/app_color.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../global_widgets/brand/build_branding.dart';

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

  bool _authStarted = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _fadeAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_authStarted) {
        _authStarted = true;
        _startAuthCheckAndNavigate();
      }
    });

  }
  Future<void> _startAuthCheckAndNavigate() async {
    final authCubit = context.read<AuthCubit>();

    await authCubit.checkAuth();

    if (!mounted) return;

    final state = authCubit.state;
    if (state is AuthAuthenticated) {
      context.go('/home');
    } else {
      context.go('/login');
    }
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
          _buildBackgroundDecorations(),
          _BuildAnimatedLogoAndLoader(
            fadeAnimation: _fadeAnimation,
            scaleAnimation: _scaleAnimation,
          ),
          BuildBranding.metaStyle(),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        PositionedDirectional(
          top: -30,
          end: -40,
          child: _buildTransparentKey(220, 0.16, 0.4),
        ),
        PositionedDirectional(
          bottom: 100,
          start: -50,
          child: _buildTransparentKey(180, 0.14, -0.2),
        ),
        PositionedDirectional(
          top: MediaQuery.of(context).size.height * 0.4,
          end: -20,
          child: _buildTransparentKey(100, 0.13, 0.8),
        ),
      ],
    );
  }

  Widget _buildTransparentKey(double size, double opacity, double rotation) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: rotation,
        child: Image.asset(
          'assets/icons/key_logo.png',
          width: size,
          height: size,
          color: AppColors.primaryDark,
        ),
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
              child: ShaderMask(
                shaderCallback: (bounds) => AppColors.premiumGoldGradient2.createShader(bounds),
                child: Image.asset(
                  'assets/icons/key_logo.png',
                  width: 150,
                  height: 150,
                  color: Colors.white,
                ),
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
              child: ShaderMask(
                shaderCallback: (bounds) => AppColors.premiumGoldGradient2.createShader(bounds),
                child: LinearProgressIndicator(
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.yellow
                    //Theme.of(context).primaryColor,
                  ),
                  minHeight: 2.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
