import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../global_widgets/brand/build_branding.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    height: 25,
                  ),

                  // Logo
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: colorScheme.primary.withOpacity(0.1)),
                          ),
                          child: Image.asset('assets/icons/key_logo.png',
                              width: 65, color: colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  // Create Account - Header Text 1
                  Text(
                    tr.create_account,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  // Join To Find - Header Text 2
                  Text(
                    tr.join_to_find,
                    style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12),
                  ),
                  const SizedBox(
                    height: 100,
                  ),

                  // Password Field
                  BuildTextfield(
                    label: tr.password,
                    hintText: "${tr.enter_hint} ${tr.password}",
                    icon: Icons.password,
                    haveSuffixEyeIcon: true,
                    obscure: true,
                    formKey: formKey,
                    onChanged: (value) => registerData.password = value,
                  ),

                  //  Confirm Password Field
                  BuildTextfield(
                    label: tr.confirm_password,
                    hintText: "${tr.enter_hint} ${tr.confirm_password}",
                    icon: Icons.password,
                    haveSuffixEyeIcon: true,
                    obscure: true,
                    formKey: formKey,
                    onChanged: (value) => registerData.confirmPassword = value,
                  ),
                  const SizedBox(height: 40),
                  const BuildLoginRow(),
                  const SizedBox(height: 80),
                  BuildBranding.metaStyle()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}