import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/config/color/app_color.dart';
import 'package:malaz/presentation/global_widgets/custom_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../global_widgets/build_branding.dart';
import 'home_register_screen.dart';

class RegisterScreen5 extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final RegisterData registerData;
  final VoidCallback onRegisterPressed;

  const RegisterScreen5({super.key, required this.formKey, required this.registerData, required this.onRegisterPressed});

  @override
  State<RegisterScreen5> createState() => RegisterScreen5State();
}

class RegisterScreen5State extends State<RegisterScreen5> {
  XFile? _image;
  bool _showImageError = false;

  void _submit() {
    if (_image == null) {
      setState(() {
        _showImageError = true;
      });
    } else {
      setState(() {
        _showImageError = false;
      });
    }
  }
  void showImageError(bool show) {
    setState(() {
      _showImageError = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
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
                        ]),
                    child: Image.asset('assets/icons/key_logo.png'),
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  // Create Account - Header Text 1
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.realGoldGradient.createShader(bounds),
                    child: Text(tr.create_account, // Using getter
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        )),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  // Join To Find - Header Text 2
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.realGoldGradient.createShader(bounds),
                    child: Text(
                      tr.join_to_find, // Using getter
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),

                  // Profile Image Message
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
                  const SizedBox(
                    height: 24,
                  ),

                  // Profile Image Input
                  ImageUploadWidget(
                    isError: _showImageError,
                    onImageSelected: (XFile? img) {
                      setState(() {
                        widget.registerData.profileImage = img;
                        _image = img;
                        _showImageError = false;
                      });
                    },
                  ),
                  if (_showImageError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        tr.image_required,
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  const SizedBox(
                    height: 50,
                  ),

                  // Register Button
                  CustomButton(
                    text: tr.register,
                    onPressed: widget.onRegisterPressed,
                  ),
                  const SizedBox(
                    height: 60,
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
  }
  bool isImageSelected() {
    return _image != null;
  }
}
class ImageUploadWidget extends StatefulWidget {
  final Function(XFile?) onImageSelected;
  final bool isError;

  const ImageUploadWidget({Key? key, required this.onImageSelected,this.isError = false,}) : super(key: key);

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  XFile? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
      widget.onImageSelected(_image);
    }
  }

  Widget _uploadBox({required IconData icon}) {
    return InkWell(
      borderRadius: BorderRadius.circular(150),
      onTap: _pickImage,
      child: DottedBox(
        isError: widget.isError,
        child: _image == null
            ? Icon(icon, size: 100, color: Colors.yellow)
            : CircleAvatar(radius: 150,backgroundImage: FileImage(File(_image!.path))),
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
  final bool isError;
  const DottedBox({required this.child, this.isError = false, Key? key}) : super(key: key);

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
            border: Border.all(
              color: isError ? Colors.red : Colors.yellow,
              style: BorderStyle.solid,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}