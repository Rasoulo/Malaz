import 'package:flutter/material.dart';
import 'package:malaz/presentation/screens/auth/register/register_screen1.dart';
import 'package:malaz/presentation/screens/auth/register/register_screen2.dart';
import 'package:malaz/presentation/screens/auth/register/register_screen3.dart';
import 'package:malaz/presentation/screens/auth/register/register_screen4.dart';
import 'package:malaz/presentation/screens/auth/register/register_screen5.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/config/color/app_color.dart';
import '../../../../l10n/app_localizations.dart';
import '../shared_widgets/shared_widgets.dart';

class HomeRegisterScreen extends StatefulWidget {
  HomeRegisterScreen({super.key});

  @override
  State<HomeRegisterScreen> createState() => _HomeRegisterScreenState();
}

class _HomeRegisterScreenState extends State<HomeRegisterScreen> {
  final PageController _controller = PageController();
  final GlobalKey<RegisterScreen4State> registerScreen4Key = GlobalKey<RegisterScreen4State>();
  final GlobalKey<RegisterScreen5State> registerScreen5Key = GlobalKey<RegisterScreen5State>();
  final GlobalKey<BuildPincodeTextfieldState> _pinTextfieldKey = GlobalKey<BuildPincodeTextfieldState>();

  final List<GlobalKey<FormState>> formKeys = List.generate(5, (_) => GlobalKey<FormState>());

  int currentPage = 0;

  bool myConditionCheck() {
    final currentFormKey = formKeys[currentPage];
    if (currentFormKey.currentState == null)
      return false; // منع التنقل إذا لا يوجد الفورم

    bool isFormValid = currentFormKey.currentState!.validate();
    if (currentPage == 0) {
      if (!_pinTextfieldKey.currentState!.isPinValid()) {
        setState(() {
          _pinTextfieldKey.currentState!.showError();  // هنا داخل الـ PinTextField تغير ال _showError إلى true
        });
        return true; // منع التنقل لأن الـ PIN غير صالح
      }
    }
    else if (currentPage == 3) {
      if (registerScreen4Key.currentState == null || !registerScreen4Key.currentState!.isImageSelected()) {
        registerScreen4Key.currentState!.showImageError(true); // فعل الخطأ ليظهر الإطار الأحمر والنص
        return true; // منع التنقل لأن الصورة غير مختارة
      }
    } else if (currentPage == 4) { // صفحة RegisterScreen5
      if (registerScreen5Key.currentState == null || !registerScreen5Key.currentState!.isImageSelected()) {
        registerScreen5Key.currentState!.showImageError(true); // فعل الخطأ ليظهر الإطار الأحمر والنص
        return true; // منع الانتقال
      }
    }
    return !isFormValid;
  }

  void _onPageChanged(int newPage) {
    if (myConditionCheck()) {
      _controller.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() => currentPage = newPage);
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: ListView(
        children: [
          SizedBox(
            height: 800,
            width: 450,
            child: PageView(
              //physics: NeverScrollableScrollPhysics(),
              controller: _controller,
              onPageChanged: _onPageChanged,
              children: [
                RegisterScreen1(formKey: formKeys[0],pinKey: _pinTextfieldKey,),
                RegisterScreen2(formKey: formKeys[1]),
                RegisterScreen3(formKey: formKeys[2]),
                RegisterScreen4(key: registerScreen4Key, formKey: formKeys[3]),
                RegisterScreen5(key: registerScreen5Key, formKey: formKeys[4]),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Center(
            child: ShaderMask(
              shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
              child: SmoothPageIndicator(
                controller: _controller,
                count: 5,
                effect: ExpandingDotsEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.yellow,
                    dotHeight: 25,
                    dotWidth: 25,
                    spacing: 15
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }
}
