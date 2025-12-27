import 'package:flutter/material.dart';
import 'package:malaz/core/config/color/app_color.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../global_widgets/build_branding.dart';
import '../shared_widgets/shared_widgets.dart';
import 'home_register_screen.dart';

class RegisterScreen3 extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final RegisterData registerData;
  const RegisterScreen3({super.key, required this.formKey, required this.registerData});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),

                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(blurRadius: 20, color: Colors.black12)
                        ]),
                    child: Image.asset('assets/icons/key_logo.png'),
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  // Create Account - Header Text 1
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.premiumGoldGradient.createShader(bounds),
                    child: Text(tr.create_account, // Using getter
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        )),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  // Join To Find - Header Text 2
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.premiumGoldGradient.createShader(bounds),
                    child: Text(
                      tr.join_to_find, // Using getter
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  const SizedBox(
                    height: 135,
                  ),

                  // Password Field
                  BuildTextfield(
                    label: tr.password,
                    icon: Icons.password,
                    haveSuffixEyeIcon: true,
                    obscure: true,
                    formKey: formKey,
                    onChanged: (value) => registerData.password = value,
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  //  Confirm Password Field
                  BuildTextfield(
                    label: tr.confirm_password,
                    icon: Icons.password,
                    haveSuffixEyeIcon: true,
                    obscure: true,
                    formKey: formKey,
                    onChanged: (value) => registerData.confirmPassword = value,
                  ),
                  const SizedBox(
                    height: 100,
                  ),

                  // Navigator.push to Login Page
                  const BuildLoginRow(),
                  const SizedBox(
                    height: 135,
                  ),

                  // Branding
                  BuildBranding()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}