
import 'package:flutter/material.dart';
import '../../../domain/entities/apartment.dart';
import '../../global widgets/custom_button.dart';

class DetailsScreen extends StatelessWidget {
  final Apartment apartment;

  const DetailsScreen({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: apartment.id,
                child: Image.network(apartment.imageUrl, fit: BoxFit.cover),
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: colorScheme.surface, shape: BoxShape.circle),
                child: Icon(Icons.arrow_back, color: colorScheme.onSurface, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.background,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          apartment.title,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onBackground),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${apartment.price.toInt()}',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.primary),
                          ),
                          Text('/month', style: TextStyle(color: colorScheme.onBackground.withOpacity(0.6))),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Stats Grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatBadge(
                        icon: Icons.bed,
                        label: '${apartment.bedrooms} Beds',
                        color: Colors.green,
                      ),
                      _StatBadge(
                        icon: Icons.bathtub,
                        label: '${apartment.bathrooms} Baths',
                        color: Colors.blue,
                      ),
                      _StatBadge(
                        icon: Icons.square_foot,
                        label: '${apartment.areaSqft} sqft',
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onBackground)),
                  const SizedBox(height: 12),
                  Text(
                    'Beautiful modern apartment in the heart of downtown. This stunning unit features high ceilings, hardwood floors, and floor-to-ceiling windows.',
                    style: TextStyle(color: colorScheme.onBackground.withOpacity(0.6), height: 1.5),
                  ),

                  const SizedBox(height: 32),

                  // Actions
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.primary),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.favorite_border, color: colorScheme.primary),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: CustomButton(
                          text: 'Book Now',
                          onPressed: null, // Deactivated for now
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatBadge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground),
          ),
        ],
      ),
    );
  }
}
