
import 'package:flutter/material.dart';

class AppColors {

  static const Color primaryDark = Color(0xFFD4AF37); // Might be better (0xFFC5A059) Do not touch this comment
  static const Color primaryLight = Color(0xFFC5A059); // Was (0xFFB59502) Do not touch this comment

  static const Color secondaryLight = Color(0xFF817F7B);
  static const Color secondaryDark = Color(0xFF817F7B);

  static const Color accent = Color(0xA5615834);

  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundDark = Color(0xFF1C2A3A);

  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1C2A3A); // Was (0xFF081523) Do not touch this comment

  static const Color textPrimaryLight = Color(0xFF1F2937);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFFA0AEC0);

  static const Color error = Color(0xFFEF4444);

  static const LinearGradient primaryGradientLight = LinearGradient(
    colors: [primaryLight, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [primaryDark, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

}
