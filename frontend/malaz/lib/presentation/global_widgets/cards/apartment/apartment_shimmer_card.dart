import 'package:flutter/material.dart';

const Color _placeholderColor = Colors.white;

/// ============================================================================
/// [BuildShimmerCard]
/// A high-fidelity skeleton loading widget.
///
/// * [Fix]: The main container background is removed so the shimmer effect
/// applies only to the inner shapes (text lines, image box), creating a proper skeleton.
/// ============================================================================
class BuildShimmerCard extends StatelessWidget {
  const BuildShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BuildShimmerImageArea(),

            SizedBox(height: 16),

            _BuildShimmerDetailsArea(),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// [SUB-WIDGETS]
/// Breakdown of the Shimmer Card components
/// ============================================================================

/// [_BuildShimmerImageArea]
/// Represents the large image placeholder.
class _BuildShimmerImageArea extends StatelessWidget {
  const _BuildShimmerImageArea();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _placeholderColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              width: 60,
              height: 24,
              decoration: BoxDecoration(
                color: _placeholderColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[100]!, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// [_BuildShimmerDetailsArea]
/// Container for Title, Location, and Footer rows.
class _BuildShimmerDetailsArea extends StatelessWidget {
  const _BuildShimmerDetailsArea();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BuildShimmerTitleRow(),
          SizedBox(height: 8),
          _BuildShimmerLocationRow(),
          SizedBox(height: 16),
          Divider(color: _placeholderColor, thickness: 1),
          SizedBox(height: 12),
          _BuildShimmerBottomRow(),
        ],
      ),
    );
  }
}

/// [_BuildShimmerTitleRow]
/// Placeholder for Title + Verification Badge.
class _BuildShimmerTitleRow extends StatelessWidget {
  const _BuildShimmerTitleRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              color: _placeholderColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            color: _placeholderColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

/// [_BuildShimmerLocationRow]
/// Placeholder for Location Icon + Address Text.
class _BuildShimmerLocationRow extends StatelessWidget {
  const _BuildShimmerLocationRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: const BoxDecoration(
            color: _placeholderColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          height: 14,
          width: 150,
          decoration: BoxDecoration(
            color: _placeholderColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}

/// [_BuildShimmerBottomRow]
/// Placeholder for Price Column + Amenities Row.
class _BuildShimmerBottomRow extends StatelessWidget {
  const _BuildShimmerBottomRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _BuildShimmerPriceColumn(),

        _BuildShimmerAmenitiesRow(),
      ],
    );
  }
}

/// [_BuildShimmerPriceColumn]
/// Helper for the price part.
class _BuildShimmerPriceColumn extends StatelessWidget {
  const _BuildShimmerPriceColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 24,
          width: 80,
          decoration: BoxDecoration(
            color: _placeholderColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 10,
          width: 40,
          decoration: BoxDecoration(
            color: _placeholderColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

/// [_BuildShimmerAmenitiesRow]
/// Helper for the list of amenities.
class _BuildShimmerAmenitiesRow extends StatelessWidget {
  const _BuildShimmerAmenitiesRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _BuildAmenityShimmerItem(),
        SizedBox(width: 12),
        _BuildAmenityShimmerItem(),
        SizedBox(width: 12),
        _BuildAmenityShimmerItem(),
      ],
    );
  }
}

/// [_BuildAmenityShimmerItem]
/// Represents a single amenity (Icon Circle + Text Line).
class _BuildAmenityShimmerItem extends StatelessWidget {
  const _BuildAmenityShimmerItem();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            color: _placeholderColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          height: 12,
          width: 20,
          decoration: BoxDecoration(
            color: _placeholderColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}