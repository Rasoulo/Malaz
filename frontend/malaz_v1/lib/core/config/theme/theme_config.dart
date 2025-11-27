// file: lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// فئة مسؤولة عن إدارة ألوان التطبيق المركزية
/// تساعد في تعديل الثيم بسهولة مستقبلاً من مكان واحد
class AppColors {
  // Primary Colors based on the Emerald tailwind class
  static const Color primary = Color(0xFF10B981); // emerald-500
  static const Color primaryDark = Color(0xFF059669); // emerald-600
  static const Color primaryLight = Color(0xFFD1FAE5); // emerald-100

  // Secondary & Accent Colors
  static const Color secondary = Color(0xFF0D9488); // teal-600
  static const Color accent = Color(0xFF3B82F6); // blue-500

  // Neutral Colors
  static const Color background = Color(0xFFF9FAFB); // gray-50
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1F2937); // gray-800
  static const Color textSecondary = Color(0xFF6B7280); // gray-500
  static const Color error = Color(0xFFEF4444); // red-500

  // Gradient for Buttons and Heroes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}