import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/core/config/color/app_color.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../global_widgets/build_branding.dart';
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

  /// Calling the function to send code via cubit
  void _sendVerificationCode() {
    final phone = widget.registerData.phone.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.amber,content: Text('Please enter your phone first')));
      return;
    }
    /// Here we ask the cubit to send the code
    context.read<AuthCubit>().sendOtp(phone);
  }

  /// Calling a code validation function via AuthCubit
  void _verifyPin(String pin) {
    if (pin.length != 6) {
      setState(() => _pinError = 'Please enter a 6-digit PIN code');
      widget.onPinVerified?.call(false);
      return;
    }
    setState(() => _pinError = null);

    final phone = widget.registerData.phone.trim();
    /// Here we tell the field that verification has started
    widget.pinKey?.currentState?.verifyStarted();
    /// Here we ask Cubit to check
    context.read<AuthCubit>().verifyOtp(phone, pin);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        /// Send code
        if (state is OtpSending) {
          setState(() => _isSending = true);
        } else if (state is OtpSent) {
          setState(() => _isSending = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.amber,content: Text('Verification code sent!')));
        } else if (state is OtpSendError) {
          setState(() => _isSending = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.amber,content: Text(state.message)));
        }

        /// Verify Code
        if (state is OtpVerifying) {
          /// Ensure pin field shows progress
          widget.pinKey?.currentState?.verifyStarted();
        } else if (state is OtpVerified) {

          /// Success: Inform the field, and inform the parent (HomeRegister) that the PIN is valid
          widget.pinKey?.currentState?.verifyFinished(success: true);
          widget.onPinVerified?.call(true);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.amber,content: Text('Code verified successfully')));
        } else if (state is OtpVerifyError) {
          /// Failed: The field was told an error message, and a local error occurred.
          final msg = state.message.isNotEmpty ? state.message : 'Invalid code';
          widget.pinKey?.currentState?.verifyFinished(success: false, message: msg);
          widget.onPinVerified?.call(false);
          setState(() => _pinError = msg);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.amber,content: Text(msg)));
        }
      },
      child: ModalProgressHUD(
        color: Colors.white,
        inAsyncCall: _isSending,
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          body: Padding(
            padding: const EdgeInsets.all(6),
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
                            boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black12)],
                          ),
                          child: Image.asset('assets/icons/key_logo.png'),
                        ),
                        const SizedBox(
                          height: 24,
                        ),


                        ShaderMask(
                          shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
                          child: Text(tr.create_account,
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.yellow)),
                        ),
                        const SizedBox(
                          height: 8,
                        ),


                        ShaderMask(
                          shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
                          child: Text(tr.join_to_find, style: TextStyle(color: Colors.grey.shade600)),
                        ),
                        const SizedBox(
                          height: 100,
                        ),

                        // Mobile Field
                        BuildTextfield(
                          label: tr.mobile_number,
                          icon: Icons.phone,
                          obscure: false,
                          keyboardType: TextInputType.phone,
                          haveSuffixEyeIcon: false,
                          formKey: widget.formKey,
                          onChanged: (value) => widget.registerData.phone = value,
                        ),
                        const SizedBox(
                          height: 16,
                        ),

                        // Send Verification Code Button

                        BuildVerficationCodeButton(
                          onPressed: _isSending ? null : _sendVerificationCode,
                        ),
                        const SizedBox(
                          height: 4,
                        ),

                        // Pin Code TextField
                        BuildPincodeTextfield(
                          key: widget.pinKey,
                          onChanged: (pin) {
                            /// When the PIN length reaches 6 digits, we call Cubit verification.
                            if (pin.length == 6) {
                              _verifyPin(pin);
                            }
                          },
                          onVerified: (success) {
                            /// it is called after verifyFinished within the field
                            /// UI update here too
                            widget.onPinVerified?.call(success);
                          },
                        ),
                        if (_pinError != null) Text(_pinError!, style: const TextStyle(color: Colors.red)),
                        const SizedBox(
                          height: 100,
                        ),

                        // Login Row
                        const BuildLoginRow(),
                        const SizedBox(
                          height: 80,
                        ),

                        // Branding
                        BuildBranding(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}