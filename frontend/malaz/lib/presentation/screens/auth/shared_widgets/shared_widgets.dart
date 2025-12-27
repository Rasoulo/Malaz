import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/config/color/app_color.dart';
import '../../../../l10n/app_localizations.dart';

class BuildCard extends StatelessWidget {
  const BuildCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/icons/card_box.png'), fit: BoxFit.fill)),
    );
  }
}

class BuildPincodeTextfield extends StatefulWidget {
  final GlobalKey<BuildPincodeTextfieldState>? pinKey;
  final Function(String)? onChanged;
  final Function(bool)? onVerified;

  const BuildPincodeTextfield({super.key, this.pinKey, this.onChanged, this.onVerified});

  @override
  State<BuildPincodeTextfield> createState() => BuildPincodeTextfieldState();
}

class BuildPincodeTextfieldState extends State<BuildPincodeTextfield> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showError = false;
  String? _errorMessage;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _validatePin(_pinController.text);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _validatePin(String value) {
    if (value.length != 6) {
      setState(() => _errorMessage = 'Please enter a 6-digit PIN code');
    } else {
      setState(() => _errorMessage = null);
    }
  }

  bool isPinValid() {
    return _pinController.text.length == 6 && _errorMessage == null;
  }

  void showError() {
    setState(() => _errorMessage = 'Please enter a 6-digit PIN code');
  }

  Future<void> verifyStarted() async {
    setState(() => _isVerifying = true);
  }

  Future<void> verifyFinished({required bool success, String? message}) async {
    if (!mounted) return;
    setState(() {
      _isVerifying = false;
      _errorMessage = success ? null : (message ?? 'Invalid code');
    });
    widget.onVerified?.call(success);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = _errorMessage == null ? colorScheme.primary : Colors.red;

    return ShaderMask(
      shaderCallback: (bounds) => AppColors.premiumGoldGradient.createShader(bounds),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PinCodeTextField(
            key: widget.pinKey,
            appContext: context,
            length: 6,
            controller: _pinController,
            focusNode: _focusNode,
            keyboardType: TextInputType.number,
            textStyle: TextStyle(
              color: colorScheme.primary,
              fontSize: 18,
            ),
            pinTheme: PinTheme(
              selectedBorderWidth: 2,
              inactiveBorderWidth: 2,
              activeBorderWidth: 2,
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(16),
              fieldHeight: 45,
              fieldWidth: 35,
              activeFillColor: colorScheme.primary,
              inactiveColor: colorScheme.primary.withOpacity(0.5),
              selectedColor: borderColor,
              selectedFillColor: colorScheme.primary,
              activeColor: borderColor,
            ),
            onChanged: (value) {
              /// Important: We pass the change to the parent to which we passed onChanged
              widget.onChanged?.call(value);

              /// We also maintain the interior facade
              if (_showError && value.length == 6) {
                setState(() => _showError = false);
              }

              /// Simple local check
              if (value.length != 6) {
                setState(() => _errorMessage = 'Please enter a 6-digit PIN code');
              } else {
                setState(() => _errorMessage = null);
              }
            },
            beforeTextPaste: (text) => true,
          ),

          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ),

          if (_isVerifying) const Padding(padding: EdgeInsets.only(top: 8), child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))),
        ],
      ),
    );
  }
}

class BuildRegisterRow extends StatelessWidget {
  const BuildRegisterRow({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppColors.premiumGoldGradient.createShader(bounds),
          child: Text(
            tr.dont_have_account,
            style: TextStyle(color: colorScheme.secondary),
          ),
        ),
        GestureDetector(
          onTap: () {
            context.go('/home_register');
          },
          child: ShaderMask(
            shaderCallback: (bounds) => AppColors.premiumGoldGradient.createShader(bounds),
            child: Text(
              tr.register,
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class BuildLoginRow extends StatelessWidget {
  const BuildLoginRow({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppColors.premiumGoldGradient.createShader(bounds),
          child: Text(
            tr.have_account,
            style: TextStyle(color: colorScheme.secondary),
          ),
        ),
        GestureDetector(
          onTap: () {
            context.go('/login');
          },
          child: ShaderMask(
            shaderCallback: (bounds) => AppColors.premiumGoldGradient.createShader(bounds),
            child: Text(
              tr.login,
              style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class BuildRibbon extends StatelessWidget {
  const BuildRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/icons/ribbon.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class BuildTextfield extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool obscure;
  final TextInputType keyboardType;
  final bool haveSuffixEyeIcon;
  final bool onPressedForDate;
  final GlobalKey<FormState>? formKey;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const BuildTextfield({
    super.key,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.haveSuffixEyeIcon = false,
    this.onPressedForDate = false,
    this.keyboardType = TextInputType.text,
    this.formKey,
    this.controller,
    this.onChanged,
  });

  @override
  State<BuildTextfield> createState() => _BuildTextfieldState();
}

class _BuildTextfieldState extends State<BuildTextfield> {
  late bool _obscureText;
  late TextInputType _keyboardType;
  late bool _haveSuffixEyeIcon;
  late bool _onPressedForDate;
  late final GlobalKey<FormState>? _formKey;
  late final TextEditingController _internalController;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
    _keyboardType = widget.keyboardType;
    _haveSuffixEyeIcon = widget.haveSuffixEyeIcon;
    _onPressedForDate = widget.onPressedForDate;
    _formKey = widget.formKey;
    _internalController = TextEditingController();
  }

  @override
  void dispose() {
    _internalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return ShaderMask(
      shaderCallback: (bounds) => AppColors.premiumGoldGradient.createShader(bounds),
      child: TextFormField(
        controller: _effectiveController,
        validator: (data) {
          if (data == null || data.isEmpty) {
            return tr.field_required;
          }
          return null;/// Returning null means the verification was successful
        },
        onChanged: (data) {
          /// We update the form if it exists and pass an external callback if it exists
          if (_formKey != null) {
            _formKey?.currentState?.validate();
          }
          if (widget.onChanged != null) widget.onChanged!(data);
        },
        readOnly: _onPressedForDate == true ? true : false,
        obscureText: _obscureText,
        keyboardType: _keyboardType,
        onTap: () async {
          if (_onPressedForDate) {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              final formattedDate = "${pickedDate.year.toString().padLeft(4,'0')}-"
                  "${pickedDate.month.toString().padLeft(2,'0')}-"
                  "${pickedDate.day.toString().padLeft(2,'0')}";
              _effectiveController.text = formattedDate;
              if (_formKey != null) _formKey?.currentState?.validate();

              /// Manually call onChanged
              if (widget.onChanged != null) {
                widget.onChanged!(formattedDate);
              }

              if (_formKey != null) _formKey?.currentState?.validate();
            }
          }
        },
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
          prefixIcon: ShaderMask(
            shaderCallback: (bounds) => AppColors.premiumGoldGradient.createShader(bounds),
            child: Icon(
              widget.icon,
              color: Colors.yellow,
            ),
          ),
          suffixIcon: _haveSuffixEyeIcon == true
              ? ShaderMask(
            shaderCallback: (bounds) => AppColors.premiumGoldGradient.createShader(bounds),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                color: Colors.yellow,
              ),
            ),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.yellow,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(30),
            ),
            borderSide: BorderSide(
              color: Colors.yellow,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(30),
            ),
            borderSide: BorderSide(
              color: Colors.yellow,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(30),
            ),
            borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(30),
            ),
            borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}


class BuildVerficationCodeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const BuildVerficationCodeButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: ShaderMask(
          shaderCallback: (bounds) => AppColors.premiumGoldGradient.createShader(bounds),
          child: Icon(Icons.send, color: colorScheme.primary
          ),
        ),
        label: ShaderMask(
          shaderCallback: (bounds) => AppColors.premiumGoldGradient.createShader(bounds),
          child: Text(tr.send_code,
              style: TextStyle(color: colorScheme.primary)),
        ),
      ),
    );
  }
}
