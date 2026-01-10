import 'package:flutter/material.dart';
import 'package:malaz/core/constants/app_constants.dart';

import '../../../core/config/color/app_color.dart';

class BuildGlowingKey extends StatelessWidget {
  final double size, opacity, rotation;
  final Color? color, shadowColor;
  const BuildGlowingKey({super.key, required this.size, required this.opacity, required this.rotation, this.color = Colors.white, this.shadowColor = AppColors.primaryLight});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: shadowColor?.withOpacity(0.4) ?? Colors.white,
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Image.asset(
            AppConstants.LogoPath,
            width: size,
            height: size,
            color: color ?? Colors.white,
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
