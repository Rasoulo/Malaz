import 'package:flutter/material.dart';
import 'package:malaz/core/config/color/app_color.dart';

class BuildBranding extends StatelessWidget {
  const BuildBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
              child: Text(
                'FROM',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 4),
            ShaderMask(
              shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
              child: Text(
                'MALAZ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
