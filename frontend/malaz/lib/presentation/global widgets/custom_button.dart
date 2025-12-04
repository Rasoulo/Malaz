
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/config/color/app_color.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutline;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isOutline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    final bool isDeactivated = onPressed == null;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: isOutline || isDeactivated
            ? null
            : (isDarkMode ? AppColors.primaryGradientDark : AppColors.primaryGradientLight),
        color: isDeactivated ? Colors.grey.shade400 : null,
        borderRadius: BorderRadius.circular(16),
        border: isOutline ? Border.all(color: colorScheme.primary, width: 2) : null,
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
            color: isOutline ? colorScheme.primary : colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
