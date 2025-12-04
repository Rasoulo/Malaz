
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


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

    return PinCodeTextField(
      mainAxisAlignment: MainAxisAlignment.center,
      appContext: context,
      textStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
      length: 5,
      onChanged: (value) {},
      onCompleted: (value) {},
      pinTheme: PinTheme(
        selectedBorderWidth: 2,
        inactiveBorderWidth: 2,
        activeBorderWidth: 2,
        borderWidth: 2,
        shape: PinCodeFieldShape.box,
        fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 8),
        borderRadius: BorderRadius.circular(16),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: colorScheme.primary,
        inactiveColor: colorScheme.primary.withOpacity(0.5),
        selectedColor: colorScheme.secondary,
        selectedFillColor: colorScheme.primary,
        activeColor: colorScheme.primary,
      ),
    );
  }
}

class BuildRegisterRow extends StatelessWidget {
  const BuildRegisterRow({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account ? ',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
        ),
        GestureDetector(
          onTap: () {
            //Navigator.pushNamed(context, RegisterPage.id);
          },
          child: Text(
            'Register',
            style: TextStyle(color: colorScheme.primary),
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

class BuildTextfield extends StatelessWidget {
  final String label;
  final IconData icon;
  const BuildTextfield({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
        prefixIcon: Icon(
          icon,
          color: colorScheme.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
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
            color: colorScheme.primary,
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
            color: colorScheme.primary,
            width: 2,
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

    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () {},
        icon: Icon(Icons.send, color: colorScheme.primary),
        label: Text('Send verification code',
            style: TextStyle(color: colorScheme.primary)),
      ),
    );
  }
}
