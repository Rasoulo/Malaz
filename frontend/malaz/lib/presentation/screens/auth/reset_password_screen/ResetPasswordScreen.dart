import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/color/app_color.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cubits/auth/auth_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String phoneNumber;
  const ResetPasswordScreen({super.key, required this.phoneNumber});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  int _currentStep = 1;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFFFFDF9);
    final textColor = isDark ? Colors.white : const Color(0xFF3E2723);
    final subTextColor = isDark ? Colors.white70 : const Color(0xFF5D4037);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is OtpSentSuccess) {
          setState(() => _currentStep = 2);
          _showSnackBar(context, tr.otp_sent_success, Colors.green);
        }
        if (state is OtpVerifyError) {
          _otpController.clear();
          _showSnackBar(context, tr.wronge_otp, Colors.red);
        }
        if (state is OtpVerified) {
          setState(() => _currentStep = 3);
          _showSnackBar(context, tr.otp_verified_success, Colors.green);
        }
        if (state is PasswordUpdatedSuccess) {
          _showSuccessSheet(tr, isDark, textColor);
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: bgColor,
            gradient: isDark ? null : RadialGradient(
              center: const Alignment(-0.5, -0.7),
              radius: 1.5,
              colors: [const Color(0xFFFFFFFF), const Color(0xFFFDF5E6), const Color(0xFFF5EEDC)],
            ),
          ),
          child: Stack(
            children: [
              if (!isDark) _buildLightDecorations(size),
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 60),
                                _buildHeader(tr, textColor),
                                const SizedBox(height: 40),
                                BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, state) {
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Opacity(
                                          opacity: state is AuthLoading ? 0.4 : 1.0,
                                          child: AbsorbPointer(
                                            absorbing: state is AuthLoading,
                                            child: _glassCard(
                                              isDark: isDark,
                                              cardColor: isDark
                                                  ? Colors.white.withOpacity(0.08)
                                                  : const Color(0xFFFDF5E6).withOpacity(0.8),
                                              child: _buildStepContent(tr, isDark, textColor, subTextColor),
                                            ),
                                          ),
                                        ),

                                        if (state is AuthLoading)
                                          _buildElegantLoading(isDark),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: textColor),
                  onPressed: () => context.pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildElegantLoading(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.black45 : Colors.white70,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          )
        ],
      ),
      child: const CircularProgressIndicator(
        color: AppColors.primaryLight,
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildStepContent(AppLocalizations tr, bool isDark, Color textColor, Color subTextColor) {
    switch (_currentStep) {
      case 1: return _stepSendOtp(tr, subTextColor);
      case 2: return _stepVerifyOtp(tr, textColor, isDark);
      case 3:
        return Column(
          children: [
            _buildCustomField(
              isDark, textColor,
              controller: _newPasswordController,
              hint: tr.new_password,
              icon: Icons.lock_outline,
              isPassword: true,
              obscureText: _obscureNewPassword,
              onToggle: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
            ),
            const SizedBox(height: 16),
            _buildCustomField(
              isDark, textColor,
              controller: _confirmPasswordController,
              hint: tr.confirm_password,
              icon: Icons.check_circle_outline,
              isPassword: true,
              obscureText: _obscureConfirmPassword,
              onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            const SizedBox(height: 32),
            _premiumButton(
              onPressed: () {
                if (_newPasswordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
                  _showSnackBar(context, tr.please_enter_password, Colors.orange);
                  return;
                }

                if (_newPasswordController.text != _confirmPasswordController.text) {
                  _showSnackBar(context, tr.passwords_do_not_match, Colors.red);
                  return;
                }

                context.read<AuthCubit>().updatePassword(
                  phone: widget.phoneNumber,
                  otp: _otpController.text,
                  newPassword: _newPasswordController.text,
                );
              },
              label: tr.save,
            ),
          ],
        );
      default: return const SizedBox();
    }
  }

  Widget _buildCustomField(bool isDark, Color textColor, {
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.primaryLight),
        suffixIcon: isPassword ? IconButton(
          icon: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppColors.primaryLight.withOpacity(0.6)),
          onPressed: onToggle,
        ) : null,
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.brown.withOpacity(0.4)),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _stepSendOtp(AppLocalizations tr, Color subTextColor) {
    return Column(
      children: [
        Text(tr.identity_verification_input, textAlign: TextAlign.center, style: TextStyle(color: subTextColor, fontSize: 16)),
        const SizedBox(height: 32),
        _premiumButton(
          onPressed: () => context.read<AuthCubit>().sendPasswordResetOtp(widget.phoneNumber),
          label: tr.send_code,
        ),
      ],
    );
  }

  Widget _stepVerifyOtp(AppLocalizations tr, Color textColor, bool isDark) {
    return Column(
      children: [
        PinCodeTextField(
          appContext: context,
          length: 6,
          controller: _otpController,
          keyboardType: TextInputType.number,
          textStyle: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(12),
            fieldHeight: 50,
            fieldWidth: 40,
            inactiveColor: isDark ? Colors.white24 : Colors.brown.shade100,
            selectedColor: AppColors.primaryLight,
            activeColor: AppColors.primaryLight,
            activeFillColor: isDark ? Colors.white10 : Colors.white,
          ),
          onCompleted: (v) {
            context.read<AuthCubit>().verifyOtp(
              widget.phoneNumber,
              v,
            );
          },
        ),
        const SizedBox(height: 24),
        TextButton(
            onPressed: () => context.read<AuthCubit>().sendPasswordResetOtp(widget.phoneNumber),
            child: Text(tr.resend_code, style: TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.w600))
        ),
      ],
    );
  }

  Widget _buildHeader(AppLocalizations tr, Color textColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryLight.withOpacity(0.5), width: 1.5),
            gradient: LinearGradient(colors: [AppColors.primaryLight.withOpacity(0.1), Colors.transparent]),
          ),
          child: Icon(_getIconForStep(), size: 42, color: AppColors.primaryLight),
        ),
        const SizedBox(height: 24),
        Text(_getTitleForStep(tr), textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor)),
      ],
    );
  }

  Widget _glassCard({required bool isDark, required Color cardColor, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: isDark ? [] : [BoxShadow(color: AppColors.primaryLight.withOpacity(0.08), blurRadius: 40, spreadRadius: 2, offset: const Offset(0, 20))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(28), border: Border.all(color: isDark ? Colors.white10 : AppColors.primaryLight.withOpacity(0.15), width: 1)),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _premiumButton({required VoidCallback onPressed, required String label}) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        gradient: AppColors.premiumGoldGradient2,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.primaryLight.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        child: Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
      ),
    );
  }

  void _showSuccessSheet(AppLocalizations tr, bool isDark, Color textColor) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFFFDF9),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: AppColors.primaryLight, size: 90),
            const SizedBox(height: 24),
            Text(tr.password_changed_success, style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            _premiumButton(onPressed: () => context.go('/login'), label: tr.login),
          ],
        ),
      ),
    );
  }

  Widget _buildLightDecorations(Size size) {
    return Stack(children: [
      Positioned(top: size.height * 0.1, left: -50, child: CircleAvatar(radius: 120, backgroundColor: AppColors.primaryLight.withOpacity(0.04))),
      Positioned(bottom: size.height * 0.2, right: -30, child: CircleAvatar(radius: 80, backgroundColor: AppColors.primaryLight.withOpacity(0.03))),
    ]);
  }

  IconData _getIconForStep() {
    if (_currentStep == 1) return Icons.security;
    if (_currentStep == 2) return Icons.vibration;
    return Icons.lock_open_rounded;
  }

  String _getTitleForStep(AppLocalizations tr) {
    if (_currentStep == 1) return tr.identity_verification;
    if (_currentStep == 2) return tr.enter_otp_hint;
    return tr.change_password;
  }
}