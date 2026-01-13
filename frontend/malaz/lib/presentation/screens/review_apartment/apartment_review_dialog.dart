import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApartmentReviewDialog extends StatefulWidget {
  final String propertyName;
  final Function(double rating, String comment) onSubmitted;

  const ApartmentReviewDialog({
    super.key,
    required this.propertyName,
    required this.onSubmitted,
  });

  @override
  State<ApartmentReviewDialog> createState() => _ApartmentReviewDialogState();
}

class _ApartmentReviewDialogState extends State<ApartmentReviewDialog> {
  double _currentRating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        contentPadding: const EdgeInsets.all(25),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star_rounded, color: Colors.amber, size: 40),
            ),
            const SizedBox(height: 20),

            Text(
              "Rate your stay", // استخدم المترجم هنا tr.rate_apartment
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text(
              widget.propertyName,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    setState(() => _currentRating = index + 1.0);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.star_rounded,
                      size: 45,
                      color: index < _currentRating ? Colors.amber : Colors.grey[300],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 25),

            // حقل التعليق
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Tell us about your experience...",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
            const SizedBox(height: 30),

            // أزرار التحكم
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Later", style: TextStyle(color: Colors.grey[400])),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentRating == 0
                        ? null
                        : () {
                      widget.onSubmitted(_currentRating, _commentController.text);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("Submit", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}