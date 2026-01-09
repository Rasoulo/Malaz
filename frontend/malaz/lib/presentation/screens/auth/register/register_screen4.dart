import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/config/color/app_color.dart';
import 'package:malaz/presentation/screens/auth/register/home_register_screen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../global_widgets/brand/build_branding.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    height: 100,
                  ),

                  // ID Document Message
                  Text(
                    tr.id_document_message, // Using getter
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
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
                  BuildBranding.metaStyle()
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

  Widget _uploadBox({required IconData icon, required String label, String? sub, required Color color}) {
    return InkWell(
      onTap: _pickImage,
      child: DottedBox(
        isError: widget.isError,
        hasImage: _image != null,
        child: _image == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
            if (sub != null) ...[
              const SizedBox(height: 6),
              Text(sub, style: TextStyle(fontSize: 12, color: color)),
            ],
          ],
        )
            : Image.file(
          File(_image!.path),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return SizedBox(
      width: 350,
      height: 145,
      child: _uploadBox(
        color: colorScheme.primary,
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
  final bool hasImage;

  const DottedBox({
    required this.child,
    this.isError = false,
    this.hasImage = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Widget content = hasImage
        ? child
        : ShaderMask(
      shaderCallback: (bounds) => AppColors.premiumGoldGradient2.createShader(bounds),
      child: child,
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isError ? colorScheme.error : colorScheme.primary,
          style: BorderStyle.solid,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: content,
      ),
    );
  }
}
