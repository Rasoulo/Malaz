import 'dart:io';
import 'dart:ui';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    height: 25,
                  ),

                  // Logo
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
                            border: Border.all(
                                color: colorScheme.primary.withOpacity(0.1)),
                          ),
                          child: Image.asset('assets/icons/key_logo.png',
                              width: 65, color: colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  // Create Account - Header Text 1
                  Text(
                    tr.create_account,
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  // Join To Find - Header Text 2
                  Text(
                    tr.join_to_find,
                    style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12),
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  // Profile Image Message
                  Text(
                      tr.profile_image_message,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
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
                    height: 50,
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

  const ImageUploadWidget({Key? key, required this.onImageSelected, this.isError = false}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 150,
      height: 150,
      child: _uploadBox(
        icon: Icons.person,
        color: colorScheme.primary,
      ),
    );
  }

  Widget _uploadBox({required IconData icon, required Color color}) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: _pickImage,
      child: DottedBox(
        isError: widget.isError,
        hasImage: _image != null,
        child: _image == null
            ? Icon(icon, size: 80, color: color)
            : Image.file(
          File(_image!.path),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

class DottedBox extends StatelessWidget {
  final Widget child;
  final bool isError;
  final bool hasImage;

  const DottedBox({
    required this.child,
    this.isError = false,
    this.hasImage = false,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: hasImage ? EdgeInsets.zero : const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: isError ? colorScheme.error : colorScheme.primary,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: hasImage
            ? child
            : ShaderMask(
          shaderCallback: (bounds) => AppColors.premiumGoldGradient.createShader(bounds),
          child: child,
        ),
      ),
    );
  }
}