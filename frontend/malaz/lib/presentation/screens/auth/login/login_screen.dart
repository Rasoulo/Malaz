
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/core/config/color/app_color.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../global_widgets/build_branding.dart';
import '../../../global_widgets/custom_button.dart';
import '../shared_widgets/shared_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(blurRadius: 20, color: Colors.black12)
                        ]
                    ),
                    child: Image.asset('assets/icons/key_logo.png'),
                  ),
                  const SizedBox(height: 24),
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
                    child: Text(
                        tr.welcome_back, // Using getter
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                        )
                    ),
                  ),
                  const SizedBox(height: 8),
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
                    child: Text(
                        tr.login_to_continue, // Using getter
                        style: TextStyle(
                            color: Colors.grey.shade600
                        ),
                    ),
                  ),
                  const SizedBox(height: 135),
                  BuildTextfield(label: tr.mobile_number, icon: Icons.phone,obscure: false,haveSuffixEyeIcon: false,),
                  const SizedBox(height: 16),
                  BuildTextfield(label: tr.password, icon: Icons.password,obscure: true,haveSuffixEyeIcon: true,),

                  const SizedBox(height: 70),
                  CustomButton(
                    text: tr.login,
                    onPressed: () {
                      if(formKey.currentState!.validate()){
                        context.go('/home');
                      } else {

                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  const BuildRegisterRow(),
                  const SizedBox(height: 110,),
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
