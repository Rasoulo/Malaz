import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../l10n/app_localizations.dart';

void showLoadingDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/lottie/sending_booking.json', width: 100),
            const SizedBox(height: 20),
            Text(
              l10n.booking_in_progress,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

void showSuccessDialog(BuildContext context, VoidCallback onClosed) {
  final theme = Theme.of(context).colorScheme;
  final l10n = AppLocalizations.of(context);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
            const SizedBox(height: 16),
             Text(
              l10n.booking_success_title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
             Text(
              l10n.booking_success_message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.pop(ctx);
                  onClosed();
                },
                style: ElevatedButton.styleFrom(backgroundColor: theme.primary,foregroundColor: theme.onPrimary),
                child: Text(l10n.action_okay),
              ),
            )
          ],
        ),
      ),
    ),
  );
}