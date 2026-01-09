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
              image: AssetImage('assets/icons/card_box.png'),
              fit: BoxFit.fill)),
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

  // @override
  // void dispose() {
  //   _pinController.dispose();
  //   _focusNode.dispose();
  //   //super.dispose();
  // }

  void _validatePin(String value) {
    setState(() {
      if (value.length != 6) {
        _errorMessage = 'Please enter a 6-digit PIN code';
      } else {
        _errorMessage = null;
      }
    });
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
    final bool hasError = _errorMessage != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PinCodeTextField(
          key: widget.pinKey,
          appContext: context,
          length: 6,
          controller: _pinController,
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
          cursorColor: colorScheme.primary,
          animationType: AnimationType.fade,
          textStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: colorScheme.primary
          ),
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(12),
            fieldHeight: 48,
            fieldWidth: 40,
            borderWidth: 1,
            inactiveFillColor: Colors.transparent,
            selectedFillColor: Colors.transparent,
            activeFillColor: Colors.transparent,
            inactiveColor: colorScheme.outlineVariant.withOpacity(0.4),
            selectedColor: hasError ? Colors.redAccent : colorScheme.primary,
            activeColor: hasError ? Colors.redAccent : colorScheme.primary.withOpacity(0.4),
          ),
          enableActiveFill: true,
          onChanged: (value) {
            widget.onChanged?.call(value);
            if (value.length != 6) {
              setState(() => _errorMessage = 'Please enter a 6-digit PIN code');
            } else {
              setState(() => _errorMessage = null);
            }
          },
          beforeTextPaste: (text) => true,
        ),

        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                  fontSize: 13
              ),
            ),
          ),

        if (_isVerifying)
          const Padding(
            padding: EdgeInsets.only(top: 15),
            child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.5)
            ),
          ),
      ],
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
        Text(
          tr.dont_have_account,
          style: TextStyle(color: colorScheme.onSurface),
        ),
        GestureDetector(
          onTap: () {
            context.go('/home_register');
          },
          child: Text(
            '   ' + tr.register,
            style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
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
        Text(
          tr.have_account,
          style: TextStyle(color: colorScheme.onSurface),
        ),
        GestureDetector(
          onTap: () {
            context.go('/login');
          },
          child: Text(
            '  '+tr.login,
            style: TextStyle(
                color: colorScheme.primary, fontWeight: FontWeight.bold
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
  final String hintText;
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
    required this.hintText,
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
  late final TextEditingController _internalController;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8, right: 12),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary.withOpacity(0.8),
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: TextFormField(
            controller: _effectiveController,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            readOnly: widget.onPressedForDate,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            validator: (data) {
              if (data == null || data.isEmpty) {
                return tr.field_required;
              }
              return null;
            },
            onChanged: (data) {
              if (widget.formKey != null) {
                widget.formKey!.currentState?.validate();
              }
              if (widget.onChanged != null) widget.onChanged!(data);
            },
            onTap: widget.onPressedForDate ? _handleDatePicker : null,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                  color: colorScheme.secondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              prefixIcon:
                  Icon(widget.icon, color: colorScheme.primary, size: 22),
              suffixIcon: widget.haveSuffixEyeIcon
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: colorScheme.primary.withOpacity(0.7),
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                    )
                  : null,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(0.4),
                    width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide:
                    const BorderSide(color: Colors.redAccent, width: 1.2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide:
                    const BorderSide(color: Colors.redAccent, width: 1.5),
              ),
              errorStyle: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _handleDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2008),
      firstDate: DateTime(1900),
      lastDate: DateTime(2008),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      final formattedDate = "${pickedDate.year.toString().padLeft(4, '0')}-"
          "${pickedDate.month.toString().padLeft(2, '0')}-"
          "${pickedDate.day.toString().padLeft(2, '0')}";
      _effectiveController.text = formattedDate;

      if (widget.formKey != null) widget.formKey!.currentState?.validate();
      if (widget.onChanged != null) widget.onChanged!(formattedDate);
    }
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
      alignment: AlignmentDirectional.centerStart,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.send, color: colorScheme.primary),
        label: Text(tr.send_code, style: TextStyle(color: colorScheme.primary)),
      ),
    );
  }
}
