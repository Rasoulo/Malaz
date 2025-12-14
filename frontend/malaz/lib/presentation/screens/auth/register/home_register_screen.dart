import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/presentation/screens/auth/register/register_screen1.dart';
import 'package:malaz/presentation/screens/auth/register/register_screen2.dart';
import 'package:malaz/presentation/screens/auth/register/register_screen3.dart';
import 'package:malaz/presentation/screens/auth/register/register_screen4.dart';
import 'package:malaz/presentation/screens/auth/register/register_screen5.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/config/color/app_color.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cubits/auth/auth_cubit.dart';
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


  /// data inputs from user storage here
  final RegisterData registerData = RegisterData();
  bool _pinValid = false;  /// PIN verification status
  int currentPage = 0;

  /// Update PIN status from RegisterScreen1
  void updatePinValidity(bool value) {
    setState(() => _pinValid = value);
  }

  bool myConditionCheck() {
    final currentFormKey = formKeys[currentPage];
    /// If there is no form on the current page -> we block navigation (unexpected but safe situation)
    if (currentFormKey.currentState == null) {
      return true; /// true => Block movement
    }

    /// We are verifying the current form
    final bool isFormValid = currentFormKey.currentState!.validate();
    if (!isFormValid) {
      return true; /// Navigation is prevented because the form is invalid
    }

    /// Page-specific conditions
    if (currentPage == 0) {
      /// Check the PIN status inside BuildPincodeTextfield
      final pinState = _pinTextfieldKey.currentState;
      if (pinState == null) {
        /// The state cannot be reached -> Block navigation
        return true;
      }

      /// If the length is incorrect, we will show the error and prevent movement
      if (!pinState.isPinValid()) {
        pinState.showError();
        return true;
      }

      /// Now we check the server verification result (stored in _pinValid)
      if (!_pinValid) {
        /// Six numbers were entered, but the server has not yet confirmed or rejected them.
        pinState.showError();
        return true;
      }
    } else if (currentPage == 3) {
      if (registerScreen4Key.currentState == null || !registerScreen4Key.currentState!.isImageSelected()) {
        registerScreen4Key.currentState?.showImageError(true);
        return true;
      }
    } else if (currentPage == 4) {
      if (registerScreen5Key.currentState == null || !registerScreen5Key.currentState!.isImageSelected()) {
        registerScreen5Key.currentState?.showImageError(true);
        return true;
      }
    }

    /// All tests are successful => Movement is permitted
    return false;
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
  }

  void _submitRegister() {
    final phone = registerData.phone.trim();
    final firstName = registerData.firstName.trim();
    final lastName = registerData.lastName.trim();
    final password = registerData.password.trim();
    final dob = registerData.dateOfBirth.trim();
    final profile = registerData.profileImage;
    final identity = registerData.identityImage;

    print('>>>>>> submitRegister called with: phone="$phone", first="$firstName", last="$lastName", password="${password.isNotEmpty}", dob="$dob", profile=${profile != null}, identity=${identity != null}');

    if (phone.isEmpty || firstName.isEmpty || lastName.isEmpty || password.isEmpty || dob.isEmpty || profile == null || identity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and upload images')),
      );
      return;
    }

    context.read<AuthCubit>().register(
      phone: phone,
      firstName: firstName,
      lastName: lastName,
      password: password,
      dateOfBirth: dob,
      profileImage: profile,
      identityImage: identity,
    );
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthPending) {
          context.go('/pending');
        } else if (state is AuthAuthenticated) {
          context.go('/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
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
                  RegisterScreen1(
                    formKey: formKeys[0],
                    pinKey: _pinTextfieldKey,
                    registerData: registerData,
                    onPinVerified: updatePinValidity,
                  ),
                  RegisterScreen2(
                    formKey: formKeys[1],
                    registerData: registerData,
                  ),
                  RegisterScreen3(
                    formKey: formKeys[2],
                    registerData: registerData,
                  ),
                  RegisterScreen4(
                    key: registerScreen4Key,
                    formKey: formKeys[3],
                    registerData: registerData,
                  ),
                  RegisterScreen5(
                    key: registerScreen5Key,
                    formKey: formKeys[4],
                    registerData: registerData,
                    onRegisterPressed: _submitRegister,
                  ),
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
      ),
    );
  }
}

class RegisterData {
  String phone = '';
  String firstName = '';
  String lastName = '';
  String password = '';
  String confirmPassword = '';
  String dateOfBirth = '';
  XFile? profileImage;
  XFile? identityImage;
}
