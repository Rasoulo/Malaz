import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/core/config/color/app_color.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../global_widgets/build_branding.dart';
import '../../../global_widgets/custom_button.dart';
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
      backgroundColor: colorScheme.surface,
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
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
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
                                ]
                            ),
                            child: Image.asset('assets/icons/key_logo.png'),
                          ),
                          const SizedBox(
                            height: 24,
                          ),

                          // Header Texts welcome_back
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                AppColors.realGoldGradient.createShader(bounds),
                            child: Text(
                                tr.welcome_back, // Using getter
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
                                )
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),

                          // Header Texts login_to_continue
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                AppColors.realGoldGradient.createShader(bounds),
                            child: Text(
                              tr.login_to_continue, // Using getter
                              style: TextStyle(
                                  color: Colors.grey.shade600
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 135,
                          ),

                          // Mobile number Text field
                          BuildTextfield(
                            label: tr.mobile_number,
                            icon: Icons.phone,
                            obscure: false,
                            haveSuffixEyeIcon: false,
                            formKey: widget.formKey,
                            keyboardType: TextInputType.phone,
                            controller: _phoneController, // adapt BuildTextfield to accept controller
                          ),
                          const SizedBox(
                            height: 16,
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
                            height: 110,
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
          },
      ),
    );
  }
}