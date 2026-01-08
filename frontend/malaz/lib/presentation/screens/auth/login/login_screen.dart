import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/presentation/global_widgets/brand/build_branding.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../global_widgets/brand/build_branding.dart';
import '../../../global_widgets/buttons/custom_button.dart';
import '../shared_widgets/shared_widgets.dart';

class LoginScreen extends StatefulWidget {
  GlobalKey<FormState> formKey;
  LoginScreen({super.key, required this.formKey});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthPending) {
            context.go('/pending');
          }
          if (state is AuthAuthenticated) {
            context.go('/home');
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return ModalProgressHUD(
            color: Colors.white,
            inAsyncCall: isLoading,
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: widget.formKey,
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
                                  border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
                                ),
                                child: Image.asset('assets/icons/key_logo.png', width: 65, color: colorScheme.primary),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),

                        // Text headers
                        Column(
                          children: [
                            Text(
                              tr.welcome_back,
                              style: TextStyle(
                                fontFamily: 'PlayfairDisplay',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tr.login_to_continue,
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 14,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 70,
                        ),

                        // Mobile number Text field
                        BuildTextfield(
                          label: tr.mobile_number,
                          icon: Icons.phone,
                          obscure: false,
                          haveSuffixEyeIcon: false,
                          formKey: widget.formKey,
                          keyboardType: TextInputType.phone,
                          controller:_phoneController,
                        ),

                        // Password Text field
                        BuildTextfield(
                          label: tr.password,
                          icon: Icons.password,
                          obscure: true,
                          haveSuffixEyeIcon: true,
                          formKey: widget.formKey,
                          controller: _passwordController,
                        ),
                        const SizedBox(
                          height: 70,
                        ),

                        // Login Button
                        CustomButton(
                          text: tr.login,
                          onPressed: isLoading ? null : () {
                             if (widget.formKey.currentState?.validate() ?? false) {
                               context.read<AuthCubit>().login(
                                     phone: _phoneController.text.trim(),
                                     password: _passwordController.text.trim(),
                               );
                             }
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),

                        // To Go to Register pages (home_register_screen.dart)
                        const BuildRegisterRow(),
                        const SizedBox(
                          height: 70,
                        ),

                        // Branding
                        BuildBranding.metaStyle()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
