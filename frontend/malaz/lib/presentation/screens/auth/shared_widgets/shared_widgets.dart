import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/presentation/screens/auth/login/login_screen.dart';
import 'package:malaz/presentation/screens/auth/register/home_register_screen.dart';
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
  const BuildPincodeTextfield({super.key, this.pinKey});

  @override
  State<BuildPincodeTextfield> createState() => BuildPincodeTextfieldState();
}

class BuildPincodeTextfieldState extends State<BuildPincodeTextfield> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final GlobalKey<BuildPincodeTextfieldState> _pinKey;
  bool _showError = false;
  String? _errorMessage;


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
    // _focusNode.dispose();
    // _pinController.dispose();
    super.dispose();
  }

  void _validatePin(String value) {
    if (value.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a 6-digit PIN code';
      });
    } else {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  bool isPinValid() {
    return _pinController.text.length == 6;
  }

  void showError() {
    setState(() {
      _errorMessage = 'Please enter a 6-digit PIN code';
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _errorMessage == null ? Colors.yellow : Colors.red;

    return ShaderMask(
      shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
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
            textStyle: const TextStyle(
              color: Colors.yellow,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
            pinTheme: PinTheme(
              selectedBorderWidth: 2,
              inactiveBorderWidth: 2,
              activeBorderWidth: 2,
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(16),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.yellow,
              inactiveColor: Colors.yellow.withOpacity(0.5),
              selectedColor: borderColor,
              selectedFillColor: Colors.yellow,
              activeColor: borderColor,
            ),
            onChanged: (value) {
              if (_showError && value.length == 6) {
                setState(() {
                  _showError = false; // أخفي الخطأ لأن المدخل صحيح
                });
              }
            },
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
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
          shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
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
            shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
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
          shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
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
            shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
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
  final bool haveSuffixEyeIcon;
  final bool onPressedForDate;
  final GlobalKey<FormState>? formKey;

  const BuildTextfield({super.key, required this.label, required this.icon, this.obscure = false, this.haveSuffixEyeIcon = false, this.onPressedForDate = false, this.formKey});

  @override
  State<BuildTextfield> createState() => _BuildTextfieldState();
}

class _BuildTextfieldState extends State<BuildTextfield> {
  late bool _obscureText;
  late bool _haveSuffixEyeIcon;
  late bool _onPressedForDate;
  late final GlobalKey<FormState>? _formKey;
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
    _haveSuffixEyeIcon = widget.haveSuffixEyeIcon;
    _onPressedForDate = widget.onPressedForDate;
    _formKey = widget.formKey;
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return ShaderMask(
      shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
      child: TextFormField(
        controller: _controller,
        validator: (data){
          if(data!.isEmpty){
            return tr.field_required;
          }
        },
        onChanged: (data){
          if(_formKey != null){
            _formKey?.currentState?.validate();
          }
        },
        readOnly: _onPressedForDate == true ? true : false,
        obscureText: _obscureText,
        onTap: () async {
          if (_onPressedForDate) {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              _controller.text = "${pickedDate.toLocal()}".split(' ')[0];
            }
          }
        },
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
          prefixIcon: ShaderMask(
            shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
            child: Icon(
              widget.icon,
              color: Colors.yellow,
            ),
          ),
          suffixIcon: _haveSuffixEyeIcon == true ? ShaderMask(
            shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
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
          ): null,
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
  const BuildVerficationCodeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () {},
        icon: ShaderMask(
          shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
          child: Icon(Icons.send, color: colorScheme.primary
          ),
        ),
        label: ShaderMask(
          shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
          child: Text(tr.send_code,
              style: TextStyle(color: colorScheme.primary)),
        ),
      ),
    );
  }
}
