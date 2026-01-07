import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

const Color _placeholderColor = Colors.white;

class BuildBookingShimmer extends StatelessWidget {
  const BuildBookingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric( vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
        child: const Column(
          children: [
            _BuildShimmerUserHeader(),
            Divider(height: 32, color: _placeholderColor, thickness: 0.8),
            _BuildShimmerApartmentRow(),
            SizedBox(height: 20),
            _BuildShimmerActionButtons(),
          ],
        ),
      ),
    );
  }
}

class _BuildShimmerUserHeader extends StatelessWidget {
  const _BuildShimmerUserHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 55, height: 55,
          decoration: const BoxDecoration(color: _placeholderColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 100, height: 16, decoration: BoxDecoration(color: _placeholderColor, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 8),
              Container(width: 140, height: 12, decoration: BoxDecoration(color: _placeholderColor, borderRadius: BorderRadius.circular(4))),
            ],
          ),
        ),
        Container(width: 40, height: 40, decoration: const BoxDecoration(color: _placeholderColor, shape: BoxShape.circle)),
      ],
    );
  }
}

class _BuildShimmerApartmentRow extends StatelessWidget {
  const _BuildShimmerApartmentRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(color: _placeholderColor, borderRadius: BorderRadius.circular(12)),
        ),
        const SizedBox(width: 12),
        Expanded(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 120, height: 14, decoration: BoxDecoration(color: _placeholderColor, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 8),
              Container(width: 60, height: 14, decoration: BoxDecoration(color: _placeholderColor, borderRadius: BorderRadius.circular(4))),
            ],
          ),
        ),
        Container(width: 65, height: 24, decoration: BoxDecoration(color: _placeholderColor, borderRadius: BorderRadius.circular(10))),
      ],
    );
  }
}

class _BuildShimmerActionButtons extends StatelessWidget {
  const _BuildShimmerActionButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(color: _placeholderColor, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(color: _placeholderColor, borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}