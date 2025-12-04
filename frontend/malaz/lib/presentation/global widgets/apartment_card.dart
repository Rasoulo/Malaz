
import 'package:flutter/material.dart';
import '../../core/config/color/app_color.dart';
import '../../domain/entities/apartment.dart';

class ApartmentCard extends StatelessWidget {
  final Apartment apartment;
  final VoidCallback onTap;

  const ApartmentCard({Key? key, required this.apartment, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Hero Animation
            Hero(
              tag: apartment.id,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.network(
                  apartment.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apartment.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: colorScheme.primary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        apartment.location,
                        style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Amenities Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Amenity(icon: Icons.bed, text: '${apartment.bedrooms} Beds'),
                      _Amenity(icon: Icons.bathtub, text: '${apartment.bathrooms} Baths'),
                      _Amenity(icon: Icons.square_foot, text: '${apartment.areaSqft} sqft'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${apartment.price.toInt()}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.primary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: isDarkMode ? AppColors.primaryGradientDark : AppColors.primaryGradientLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('View', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Amenity extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Amenity({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.secondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

