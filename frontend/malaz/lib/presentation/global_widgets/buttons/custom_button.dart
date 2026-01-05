import 'package:flutter/material.dart';
import '../../../core/config/color/app_color.dart';

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
    final isDeactivated = onPressed == null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: isOutline ? Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5), width: 1.5) : null,
        gradient: isOutline || isDeactivated ? null : AppColors.premiumGoldGradient2,
        color: isOutline ? Colors.transparent : (isDeactivated ? Colors.grey.shade300 : null),
        boxShadow: isDeactivated || isOutline ? [] : [
           BoxShadow(
             color: const Color(0xFFD4AF37).withOpacity(0.3),
             blurRadius: 15,
             offset: const Offset(0, 8),
             spreadRadius: -2,
           ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18),
          splashColor: Colors.white12,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: isOutline ? const Color(0xFFD4AF37) : (isDeactivated ? Colors.grey.shade600 : Colors.white),
                shadows: isOutline || isDeactivated ? [] : [
                   const Shadow(
                     color: Colors.black26,
                     offset: Offset(0, 1),
                     blurRadius: 2,
                   )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
