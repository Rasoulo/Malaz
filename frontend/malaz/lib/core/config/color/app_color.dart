import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryDark = Color(0xFFEDB95E);
  static const Color primaryLight = Color(0xFFC59232);

  static const Color secondaryDark = Color(0xFF3D3D3D);
  static const Color secondaryLight = Color(0xFF909090);

  static const Color accent = Color(0x2DFFE1ED);
  static const tertiary = Colors.blue;

  static const Color backgroundLight = Color(0xFFFFFCF3);
  static const Color backgroundDark = Color(0xFF1B1A1A);

  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF2D2C2C);

  static const Color textPrimaryLight = Color(0xFF2C2420);
  static const Color textSecondaryLight = Color(0xFF8D7F7D);
  static const Color textPrimaryDark = Color(0xFFF5E6D3);
  static const Color textSecondaryDark = Color(0xFFA1887F);

  static const Color error = Color(0xFFD32F2F);

  static const LinearGradient premiumGoldGradient = LinearGradient(
    colors: [Color(0xFFFFCD71), Color(0xFFDCC18A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGoldGradient2 = LinearGradient(
    colors: [Color(0xFFC69B4B), Color(0xFFFFCD71)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient realGoldGradient = LinearGradient(
    colors: [
      Color(0xFFFFF8D0), // bright highlight
      Color(0xFFFFE680),
      Color(0xFFFFD240),
      Color(0xFFFFC000),
      Color(0xFFB8860B),//
      // Color(0xFFFFB300), // deep gold shadow
      Color(0xFFFFC000),
      Color(0xFFFFD240),
      Color(0xFFFFE680),
      Color(0xFFFFF8D0), // bright reflective
    ],
    stops: [
      0.0, 0.10, 0.22, 0.35, 0.50, 0.65, 0.78, 0.90, 1.0,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient goldGradientbut = LinearGradient(// Nice
    colors: [
      Color(0xFFFFD700), // Vivid Gold
      Color(0xFFFFC700), // Warm Gold
      Color(0xFFFFB300), // Rich Gold
      Color(0xFFFFD700), // Highlight again for metallic shine
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}