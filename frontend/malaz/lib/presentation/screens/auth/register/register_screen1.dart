import 'package:flutter/material.dart';
import 'package:malaz/core/config/color/app_color.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../global_widgets/build_branding.dart';
import '../shared_widgets/shared_widgets.dart';

class RegisterScreen1 extends StatelessWidget {
  const RegisterScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                        tr.create_account, // Using getter
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
                      tr.join_to_find, // Using getter
                      style: TextStyle(
                          color: Colors.grey.shade600
                      ),
                    ),
                  ),
                  const SizedBox(height: 140),
                  BuildTextfield(label: tr.mobile_number, icon: Icons.phone,obscure: false,haveSuffixEyeIcon: false,),
                  const SizedBox(height: 16),
                  const BuildVerficationCodeButton(),
                  const SizedBox(height: 4),
                  const BuildPincodeTextfield(),
                  const SizedBox(height: 82),
                  const BuildLoginRow(),
                  const SizedBox(height: 40,),
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
