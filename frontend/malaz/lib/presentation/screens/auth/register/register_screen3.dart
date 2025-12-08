import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malaz/core/config/color/app_color.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../global_widgets/build_branding.dart';
import '../shared_widgets/shared_widgets.dart';

class RegisterScreen3 extends StatelessWidget {
  const RegisterScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
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
                        tr.create_account, // Using getter
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
                      tr.join_to_find, // Using getter
                      style: TextStyle(
                          color: Colors.grey.shade600
                      ),
                    ),
                  ),
                  const SizedBox(height: 135),
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
                    child: Text(
                        tr.id_document_message, // Using getter
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        )
                    ),
                  ),
                  const SizedBox(height: 24),
                  ImageUploadWidget(),
                  const SizedBox(height: 70),
                  const BuildLoginRow(),
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

  Widget _uploadBox({required IconData icon, required String label, String? sub}) {
    return InkWell(
      onTap: _pickImage,
      child: DottedBox(
        child: _image == null
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: Colors.yellow),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.yellow)),
            if (sub != null) ...[
              const SizedBox(height: 6),
              Text(sub, style: TextStyle(fontSize: 12, color: Colors.yellow)),
            ],
          ],
        )
            : Image.file(_image!, fit: BoxFit.cover),
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
  const DottedBox({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
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
    );
  }
}