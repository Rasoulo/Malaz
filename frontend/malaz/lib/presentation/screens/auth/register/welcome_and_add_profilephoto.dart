import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/config/color/app_color.dart';
import 'package:malaz/presentation/global_widgets/custom_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../global_widgets/build_branding.dart';

class WelcomeAndAddProfilephoto extends StatelessWidget {
  const WelcomeAndAddProfilephoto({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(150),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
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
                  const SizedBox(height: 24),
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
                    child: Text(
                        tr.create_account,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        )
                    ),
                  ),
                  const SizedBox(height: 8),
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
                    child: Text(
                      tr.join_to_find,
                      style: TextStyle(
                          color: Colors.grey.shade600
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
                    child: Text(
                        tr.profile_image_message, // Using getter
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600
                        )
                    ),
                  ),
                  const SizedBox(height: 24),
                  ImageUploadWidget(),
                  const SizedBox(height: 50),
                  CustomButton(
                    text: tr.register,
                    onPressed: () {
                      //
                    },
                  ),
                  const SizedBox(height: 40,),
                  BuildBranding()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class ImageUploadWidget extends StatefulWidget {
  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Widget _uploadBox({required IconData icon}) {
    return InkWell(
      borderRadius: BorderRadius.circular(150),
      onTap: _pickImage,
      child: DottedBox(
        child: _image == null
            ? Icon(icon, size: 100, color: Colors.yellow)
            : CircleAvatar(radius: 150,backgroundImage: FileImage(_image!)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return SizedBox(
      width: 150,
      height: 150,
      child: _uploadBox(
        icon: Icons.person,
      ),
    );
  }
}

class DottedBox extends StatelessWidget {
  final Widget child;
  const DottedBox({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(150)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.yellow, style: BorderStyle.solid),
          ),
          child: child,
        ),
      ),
    );
  }
}