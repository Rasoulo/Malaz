import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/core/config/color/app_color.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../global_widgets/brand/build_branding.dart';
import '../shared_widgets/shared_widgets.dart';
import 'home_register_screen.dart';

class RegisterScreen1 extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final GlobalKey<BuildPincodeTextfieldState> pinKey;
  final RegisterData registerData;
  final Function(bool)? onPinVerified;

  const RegisterScreen1({
    super.key,
    required this.formKey,
    required this.pinKey,
    required this.registerData,
    this.onPinVerified,
  });

  @override
  State<RegisterScreen1> createState() => _RegisterScreen1State();
}

class _RegisterScreen1State extends State<RegisterScreen1> {
  bool _isSending = false;
  String? _pinError;

  void _showCustomSnackBar(BuildContext context, String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _sendVerificationCode() {
    final phone = widget.registerData.phone.trim();
    if (phone.isEmpty) {
      _showCustomSnackBar(context, 'Please enter your phone first', isError: true);
      return;
    }
    context.read<AuthCubit>().sendOtp(phone);
  }

  void _verifyPin(String pin) {
    if (pin.length != 6) {
      setState(() => _pinError = 'Please enter a 6-digit PIN code');
      widget.onPinVerified?.call(false);
      return;
    }
    setState(() => _pinError = null);
    final phone = widget.registerData.phone.trim();
    widget.pinKey.currentState?.verifyStarted();
    context.read<AuthCubit>().verifyOtp(phone, pin);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (!mounted) return;

        if (state is OtpSending) {
          setState(() => _isSending = true);
        } else if (state is OtpSent) {
          setState(() => _isSending = false);
          _showCustomSnackBar(context, tr.otp_sent_success);
        } else if (state is OtpSendError) {
          setState(() => _isSending = false);
          _showCustomSnackBar(context, state.message, isError: true);
        }

        if (state is OtpVerified) {
          widget.pinKey.currentState?.verifyFinished(success: true);
          widget.onPinVerified?.call(true);
          _showCustomSnackBar(context, tr.otp_verified_success);
        } else if (state is OtpVerifyError) {
          final msg = state.message.isNotEmpty ? state.message : 'Invalid code';
          widget.pinKey.currentState?.verifyFinished(success: false, message: msg);
          widget.onPinVerified?.call(false);
          setState(() => _pinError = msg);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          color: Colors.white,
          inAsyncCall: _isSending,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: widget.formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
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
                        const SizedBox(height: 24),
                        Text(
                          tr.create_account,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tr.join_to_find,
                          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12),
                        ),
                        const SizedBox(height: 100),
                        BuildTextfield(
                          label: tr.mobile_number,
                          hintText: tr.phone_number_hint,
                          icon: Icons.phone,
                          obscure: false,
                          keyboardType: TextInputType.phone,
                          haveSuffixEyeIcon: false,
                          formKey: widget.formKey,
                          onChanged: (value) => widget.registerData.phone = value,
                        ),
                        const SizedBox(height: 16),
                        BuildVerficationCodeButton(
                          onPressed: _isSending ? null : _sendVerificationCode,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: BuildPincodeTextfield(
                            key: widget.pinKey,
                            onChanged: (pin) {
                              if (pin.length == 6) _verifyPin(pin);
                            },
                            onVerified: (success) => widget.onPinVerified?.call(success),
                          ),
                        ),
                        if (_pinError != null)
                        Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(_pinError!, style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 40),
                        const BuildLoginRow(),
                        const SizedBox(height: 90),
                        BuildBranding.metaStyle()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}