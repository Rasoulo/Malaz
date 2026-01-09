import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/l10n/app_localizations.dart';
import 'package:malaz/presentation/global_widgets/buttons/animated_heart_button.dart';
import '../../../domain/entities/apartment/apartment.dart';
import '../../cubits/favorites/favorites_cubit.dart';

/// ============================================================================
/// [ApartmentCard]
/// A modern, high-end card widget that displays property summary.
///
/// * [Features]:
/// - Hero Animation for seamless transitions.
/// - Image Slider (Simulated using PageView).
/// - Floating Rating Badge.
/// - Clean Typography utilizing the app theme.
/// ============================================================================
class ApartmentCard extends StatelessWidget {
  final Apartment apartment;
  final VoidCallback onTap;

  const ApartmentCard({
    super.key,
    required this.apartment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BuildCardImageArea(apartment: apartment),

                _BuildCardDetails(apartment: apartment),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// [_BuildCardImageArea]
/// Handles the top part of the card: The Image Slider and the Overlay Badges.
class _BuildCardImageArea extends StatefulWidget {
  final Apartment apartment;

  const _BuildCardImageArea({required this.apartment});

  @override
  State<_BuildCardImageArea> createState() => _BuildCardImageAreaState();
}

class _BuildCardImageAreaState extends State<_BuildCardImageArea> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      widget.apartment.mainImageUrl,
      widget.apartment.mainImageUrl,
      widget.apartment.mainImageUrl,
    ];

    return Stack(
      children: [
        SizedBox(
          height: 400,
          width: double.infinity,
          child: Hero(
            tag: 'apartment_image_${widget.apartment.id}',
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[300], child: const Icon(Icons.error)),
                );
              },
            ),
          ),
        ),

        Positioned(
          top: 16,
          left: 16,
          child: _BuildRatingBadge(rating: widget.apartment.rating),
        ),

        Positioned(
          top: 16,
          right: 16,
          child: _BuildFavoriteIcon(apartment: widget.apartment),
        ),

        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                width: _currentPage == index ? 20 : 6,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// [_BuildCardDetails]
/// Displays the textual information below the image.
class _BuildCardDetails extends StatelessWidget {
  final Apartment apartment;

  const _BuildCardDetails({required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  apartment.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (apartment.status == 'approved')
                const Icon(Icons.verified, size: 16, color: Colors.blue),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: theme.colorScheme.secondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${apartment.city}, ${apartment.address}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Divider(color: Colors.grey.withOpacity(0.1)),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '\$${apartment.price}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    TextSpan(
                      text: ' / ${AppLocalizations.of(context).month}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  _BuildMiniAmenity(icon: Icons.bed, text: '${apartment.bedrooms}'),
                  const SizedBox(width: 8),
                  _BuildMiniAmenity(icon: Icons.bathtub, text: '${apartment.bathrooms}'),
                  const SizedBox(width: 8),
                  _BuildMiniAmenity(icon: Icons.square_foot, text: '${apartment.area} m²'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// [_BuildRatingBadge]
/// A blurry glass-effect badge for rating.
class _BuildRatingBadge extends StatelessWidget {
  final num rating;

  const _BuildRatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 14),
          const SizedBox(width: 4),
          Text(
            rating > 0 ? rating.toString() : AppLocalizations.of(context).new_,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// [_BuildFavoriteIcon]
/// A dedicated widget for the favorite button on the card.
class _BuildFavoriteIcon extends StatelessWidget {
  final Apartment apartment;

  const _BuildFavoriteIcon({required this.apartment});

  @override
  Widget build(BuildContext context) {
    bool isFav = context.read<FavoritesCubit>().isFavorite(apartment.id);
    return AnimatedHeartButton(isFavorite: isFav,apartment: apartment, onTap: () {
      context.read<FavoritesCubit>().toggleFavorite(apartment);
    });
  }
}

/// [_BuildMiniAmenity]
/// Small icon and text for quick info (Bed/Bath).
class _BuildMiniAmenity extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BuildMiniAmenity({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.tertiary),
        const SizedBox(width: 4),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}