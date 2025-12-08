import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

class BuildPincodeTextfield extends StatelessWidget {
  const BuildPincodeTextfield({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ShaderMask(
      shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
      child: PinCodeTextField(
        mainAxisAlignment: MainAxisAlignment.center,
        appContext: context,
        textStyle: TextStyle(
          color: Colors.yellow,
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
        length: 6,
        onChanged: (value) {},
        onCompleted: (value) {},
        pinTheme: PinTheme(
          selectedBorderWidth: 2,
          inactiveBorderWidth: 2,
          activeBorderWidth: 2,
          borderWidth: 2,
          shape: PinCodeFieldShape.box,
          fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 10),
          borderRadius: BorderRadius.circular(16),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.yellow,
          inactiveColor: Colors.yellow.withOpacity(0.5),
          selectedColor: Colors.yellow,
          selectedFillColor: Colors.yellow,
          activeColor: Colors.yellow,
        ),
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
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => HomeRegisterScreen()));
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
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => LoginScreen()));
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
  const BuildTextfield({super.key, required this.label, required this.icon, this.obscure = false, this.haveSuffixEyeIcon = false});

  @override
  State<BuildTextfield> createState() => _BuildTextfieldState();
}

class _BuildTextfieldState extends State<BuildTextfield> {
  late bool _obscureText;
  late bool _haveSuffixEyeIcon;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
    _haveSuffixEyeIcon = widget.haveSuffixEyeIcon;
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ShaderMask(
      shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
      child: TextFormField(
        validator: (data){
          if(data!.isEmpty){
            return 'That field is required';
          }
        },
        obscureText: _obscureText,
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
        ),
      ),
    );
  }
}

class ImageInput extends StatefulWidget {
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    var _image = await picker.pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: const Radius.circular(30),
          topRight: const Radius.circular(8),
          bottomLeft: const Radius.circular(8),
          bottomRight: const Radius.circular(30),
        ),
        border: Border.all(
          color: Color(0xFFFFD240),
          width: 2,
        ),
        color: colorScheme.surface,
      ),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('اختر صورة من الاستوديو'),
          ),
          SizedBox(height: 20),
          CircleAvatar(
            radius: 80,
            backgroundImage: _image == null ? null : FileImage(_image!),
          ),
        ],
      ),
    );
  }
}


class BuildVerficationCodeButton extends StatelessWidget {
  const BuildVerficationCodeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
          child: Text('Send verification code',
              style: TextStyle(color: colorScheme.primary)),
        ),
      ),
    );
  }
}
