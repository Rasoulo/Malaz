// file: lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import '../../../core/config/theme/theme_config.dart';
import '../../global widgets/custom_button.dart';
import '../main wrapper/main_wrapper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Blobs (Decoration)
          Positioned(top: -50, left: -50, child: _buildBlob(AppColors.primaryLight)),
          Positioned(top: 100, right: -50, child: _buildBlob(const Color(0xFF99F6E4))), // teal-200

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Area
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black12)]),
                    child: const Icon(Icons.apartment, size: 40, color: AppColors.primary),
                  ),
                  const SizedBox(height: 24),
                  const Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  const Text('Login to continue your search', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 48),

                  // Inputs
                  _buildTextField('Mobile Number', Icons.phone),
                  const SizedBox(height: 16),
                  _buildTextField('Verification Code', Icons.lock_outline),

                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'Login',
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainWrapper()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlob(Color color) {
    return Container(
      width: 200, height: 200,
      decoration: BoxDecoration(color: color.withOpacity(0.3), shape: BoxShape.circle),
    );
  }

  Widget _buildTextField(String label, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
      ),
    );
  }
}