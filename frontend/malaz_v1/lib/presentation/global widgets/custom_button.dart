import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/config/theme/theme_config.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutline;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isOutline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: isOutline ? null : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        border: isOutline ? Border.all(color: AppColors.primary, width: 2) : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isOutline ? AppColors.primary : Colors.white,
          ),
        ),
      ),
    );
  }
}