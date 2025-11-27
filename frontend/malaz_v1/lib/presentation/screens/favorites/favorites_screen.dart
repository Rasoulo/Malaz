import 'package:flutter/material.dart';
import '../../../core/config/theme/theme_config.dart';
import '../../../data/source/apartments/apartments_source.dart';
import '../../global widgets/apartment_card.dart';


class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter logic would happen here in a real app
    final favorites = mockApartments; // Assuming all mocks are favorites for demo

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Favorites', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          // يمكننا هنا وضع ApartmentCard داخل Stack لإضافة زر حذف مخصص
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
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.favorite, color: Colors.red),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}