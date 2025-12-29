import 'package:flutter/material.dart';
import 'package:malaz/core/config/color/app_color.dart';

import '../../l10n/app_localizations.dart';

class BuildBranding extends StatelessWidget {
  const BuildBranding({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'FROM',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'MALAZ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
