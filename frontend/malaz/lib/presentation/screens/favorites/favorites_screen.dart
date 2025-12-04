
import 'package:flutter/material.dart';
import '../../../data/source/apartments/apartments_source.dart';
import '../../../l10n/app_localizations.dart';
import '../../global widgets/apartment_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    final favorites = mockApartments;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(tr.my_favorites, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              ApartmentCard(
                apartment: favorites[index],
                onTap: () {
                  // Navigate to details
                },
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.favorite, color: colorScheme.error),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
