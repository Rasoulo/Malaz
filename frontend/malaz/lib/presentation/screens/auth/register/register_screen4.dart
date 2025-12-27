import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/config/color/app_color.dart';
import 'package:malaz/presentation/screens/auth/register/home_register_screen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../global_widgets/build_branding.dart';
import '../shared_widgets/shared_widgets.dart';

class RegisterScreen4 extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final RegisterData registerData;
  const RegisterScreen4({super.key, required this.formKey, required this.registerData});

  @override
  State<RegisterScreen4> createState() => RegisterScreen4State();
}

class RegisterScreen4State extends State<RegisterScreen4> {
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
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
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
                        AppColors.premiumGoldGradient.createShader(bounds),
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
                        AppColors.premiumGoldGradient.createShader(bounds),
                    child: Text(
                      tr.join_to_find, // Using getter
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),

                  // ID Document Message
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.premiumGoldGradient.createShader(bounds),
                    child: Text(tr.id_document_message, // Using getter
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        )),
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  // Image Input
                  ImageUploadWidget(
                    isError: _showImageError,
                    onImageSelected: (XFile? img) {
                      setState(() {
                        _image = img;
                        widget.registerData.identityImage = img;
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
                    height: 70,
                  ),

                  // Navigator.push to Login Page
                  const BuildLoginRow(),
                  const SizedBox(
                    height: 100,
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

  Widget _uploadBox(
      {required IconData icon, required String label, String? sub}) {
    return InkWell(
      onTap: _pickImage,
      child: DottedBox(
        isError: widget.isError,
        child: _image == null
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: Colors.yellow),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.yellow)),
            if (sub != null) ...[
              const SizedBox(height: 6),
              Text(sub,
                  style: TextStyle(fontSize: 12, color: Colors.yellow)),
            ],
          ],
        ) : Image.file(File(_image!.path), fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return SizedBox(
      width: 350,
      height: 150,
      child: _uploadBox(
        icon: Icons.cloud_upload_outlined,
        label: tr.upload_id_message,
        sub: tr.png_jpg,
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
      shaderCallback: (bounds) =>
          AppColors.premiumGoldGradient.createShader(bounds),
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
    );
  }
}
