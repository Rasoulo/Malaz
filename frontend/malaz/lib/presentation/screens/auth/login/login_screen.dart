
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../global widgets/build_branding.dart';
import '../../../global widgets/custom_button.dart';
import '../../main wrapper/main_wrapper.dart';
import '../shared widgets/shared_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const Positioned(top: 0, left: 0, right: 0, child: BuildRibbon()),
            const Positioned(top: 350, left: 0, right: 0, child: BuildCard()),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 95),
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
                    const SizedBox(height: 24),
                    Text(tr.welcome_back, // Using getter
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary)),
                    const SizedBox(height: 8),
                    Text(tr.login_to_continue, // Using getter
                        style: TextStyle(
                            color: Colors.grey.shade600)),
                    const SizedBox(height: 135),
                    BuildTextfield(label: tr.mobile_number, icon: Icons.phone),
                    const BuildVerficationCodeButton(),
                    const SizedBox(height: 8),
                    const BuildPincodeTextfield(),
                    const SizedBox(height: 70),
                    CustomButton(
                      text: tr.login,
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MainWrapper()));
                      },
                    ),
                    const SizedBox(height: 12),
                    const BuildRegisterRow(),
                    const SizedBox(
                      height: 40,
                    ),
                    BuildBranding()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
