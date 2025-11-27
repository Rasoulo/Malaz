// file: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malaz_v1/presentation/screens/login/login_screen.dart';
import 'core/config/theme/theme_config.dart';


void main() {
  // التأكد من أن شريط الحالة (Status Bar) شفاف ليتناسب مع التصميم العصري
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const RentalApp());
}

class RentalApp extends StatelessWidget {
  const RentalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apartment Rental',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins', // يفضل استخدام خط Poppins ليطابق التصميم
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      // نبدأ بشاشة تسجيل الدخول
      home: const LoginScreen(),
    );
  }
}