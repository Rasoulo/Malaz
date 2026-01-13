import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/presentation/global_widgets/buttons/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/domain/entities/user/user_entity.dart';
import 'package:malaz/presentation/global_widgets/user_profile_image/user_profile_image.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../../domain/entities/apartment/apartment.dart';
import '../../../core/config/color/app_color.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/favorites/favorites_cubit.dart';
import '../../cubits/chat/chat_cubit.dart';
import '../../cubits/review/review_cubit.dart';
import '../book_now/book_now_screen.dart';
import '../reviews_bottom_sheet/reviews_bottom_sheet.dart';

/// ============================================================================
/// [DetailsScreen]
/// The full details page for a specific apartment.
/// Uses [CustomScrollView] with [SliverAppBar] for a premium scrolling experience.
/// ============================================================================
class DetailsScreen extends StatefulWidget {
  final Apartment apartment;

  const DetailsScreen({super.key, required this.apartment});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().getConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: _BuildBottomBookingBar(apartment: widget.apartment),
      body: CustomScrollView(
        slivers: [
          _BuildSliverAppBar(apartment: widget.apartment),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BuildTitleAndRating(apartment: widget.apartment),
                  const SizedBox(height: 24),
                  _BuildOwnerCard(
                    owner: widget.apartment.owner,
                  ),
                  const SizedBox(height: 24),
                  _BuildAmenitiesSection(apartment: widget.apartment),
                  const SizedBox(height: 24),
                  _BuildDescription(description: widget.apartment.description),
                  const SizedBox(height: 24),
                  _BuildReviewSection(
                    id: widget.apartment.id,
                    rating: widget.apartment.rating,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// [UI_BUILDING_WIDGETS]
/// ============================================================================

/// [_BuildSliverAppBar]
/// Handles the collapsible header with the Hero image and action buttons.
class _BuildSliverAppBar extends StatelessWidget {
  final Apartment apartment;

  const _BuildSliverAppBar({required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<String> galleryImages = [
      apartment.mainImageUrl,
      apartment.mainImageUrl,
      apartment.mainImageUrl,
    ];

    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      backgroundColor: theme.colorScheme.background,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _AppBarActionButton(
          icon: Icons.arrow_back_ios_rounded,
          onTap: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _AppBarActionButton(
            icon: Icons.share,
            onTap: () {
              // TODO: Implement Share Logic
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              final isFav =
                  context.read<FavoritesCubit>().isFavorite(apartment.id);

              return _AppBarActionButton(
                icon: isFav ? Icons.favorite : Icons.favorite_border,
                iconColor: isFav ? Colors.red : null,
                onTap: () {
                  context.read<FavoritesCubit>().toggleFavorite(apartment);
                },
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'apartment_image_${apartment.id}',
          child: PageView.builder(
            itemCount: galleryImages.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    galleryImages[index],
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black26,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// [HELPER_WIDGET] - _AppBarActionButton
/// ============================================================================
class _AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _AppBarActionButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor ?? Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

/// [_BuildTitleAndRating]
/// Displays the main title, location, and rating summary.
class _BuildTitleAndRating extends StatelessWidget {
  final Apartment apartment;

  const _BuildTitleAndRating({required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BuildTypeBadge(type: apartment.type),
        const SizedBox(height: 12),
        Text(
          apartment.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on,
                size: 16, color: theme.colorScheme.secondary),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                maxLines: 2,
                '${apartment.city}, ${apartment.address}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                softWrap: true,
              ),
            )
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            RichText(
              text: TextSpan(
                style: theme.textTheme.bodyLarge,
                children: [
                  TextSpan(
                    text: '${apartment.rating}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' ${l10n.reviews_count(apartment.numberOfReviews)}',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BuildTypeBadge extends StatelessWidget {
  final String type;

  const _BuildTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    String localizedType = type;
    if (type.toLowerCase() == 'apartment')
      localizedType = l10n.apartment;
    else if (type.toLowerCase() == 'villa')
      localizedType = l10n.villa;
    else if (type.toLowerCase() == 'house')
      localizedType = l10n.house;
    else if (type.toLowerCase() == 'farm')
      localizedType = l10n.farm;
    else if (type.toLowerCase() == 'country house')
      localizedType = l10n.country_house;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.tertiary.withOpacity(0.2),
        ),
      ),
      child: Text(
        localizedType.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.tertiary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

/// [_BuildOwnerCard]
/// A mock card to display host information.
class _BuildOwnerCard extends StatelessWidget {
  final UserEntity owner;
  const _BuildOwnerCard({required this.owner});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              gradient: AppColors.premiumGoldGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFAF895F).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            padding: const EdgeInsets.all(1.5),
            child: UserProfileImage(
              userId: owner.id,
              firstName: owner.first_name,
              lastName: owner.last_name,
              isPremiumStyle: true,
              radius: 25,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${owner.first_name} ${owner.last_name}',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Icons.verified_user_rounded,
                        size: 14, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      l10n.verified_host,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () async {
                  int? myId = _getMyId(context);
                  if (owner.id == myId) {
                    _showSnackBar(
                        context, l10n.not_chat_yourself, theme.primaryColor);
                  } else {
                    final chatCubit = context.read<ChatCubit>();
                    final router = GoRouter.of(context);

                    await chatCubit.getConversations();

                    int existingId = 0;
                    final state = chatCubit.state;

                    if (state is ChatConversationsLoaded) {
                      final foundConversations = state.conversations
                          .where((c) =>
                              c.userOneId == owner.id ||
                              c.userTwoId == owner.id)
                          .toList();

                      if (foundConversations.isNotEmpty) {
                        existingId = foundConversations.first.id;
                      }
                    }

                    if (existingId > 0) {
                      chatCubit.getMessages(existingId);
                    } else {
                      chatCubit.clearMessages();
                    }

                    router.push('/one_chat', extra: {
                      'id': existingId,
                      'firstName': owner.first_name,
                      'lastName': owner.last_name,
                      'otherUserId': owner.id,
                    });
                  }
                },
                icon:
                    Icon(Icons.chat_outlined, color: theme.colorScheme.primary),
              ))
        ],
      ),
    );
  }

  int? _getMyId(BuildContext context) {
    final state = context.read<AuthCubit>().state;
    if (state is AuthAuthenticated) return state.user.id;
    if (state is AuthPending) return state.user.id;
    return null;
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/// [_BuildAmenitiesSection]
/// Displays the numbers (Rooms, Baths, Area) in stylish boxes.
class _BuildAmenitiesSection extends StatelessWidget {
  final Apartment apartment;

  const _BuildAmenitiesSection({required this.apartment});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _BuildAmenityBox(
          icon: Icons.bed_outlined,
          label: l10n.rooms,
          value: '${apartment.rooms}',
        ),
        _BuildAmenityBox(
          icon: Icons.bathtub_outlined,
          label: l10n.baths,
          value: '${apartment.bathrooms}',
        ),
        _BuildAmenityBox(
          icon: Icons.square_foot,
          label: l10n.area.replaceAll(':', ''),
          value: '${apartment.area} m²',
        ),
      ],
    );
  }
}

class _BuildAmenityBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _BuildAmenityBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.tertiary, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

/// [_BuildDescription]
/// Displays the description text.
class _BuildDescription extends StatelessWidget {
  final String description;

  const _BuildDescription({required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.description,
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          description.isEmpty ? l10n.no_description : description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

/// [_BuildReviewSection]
/// Shows a mock review to fulfill the requirement.
class _BuildReviewSection extends StatelessWidget {
  final int id;
  final num rating;
  const _BuildReviewSection({required this.id, required this.rating});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.reviews,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // مهم جداً ليأخذ الارتفاع المحدد
                    backgroundColor: Colors.transparent,
                    builder: (context) => BlocProvider(
                      // تأكد من حقن الـ Cubit هنا أو في مكان أعلى
                      create: (context) => sl<ReviewsCubit>(),
                      child: ReviewsBottomSheet(propertyId: id, rating: rating),
                    ),
                  );
                },
                child: Text(l10n.view_all)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    child: Icon(Icons.person, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text('Happy Guest',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const Text('5.0'),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                  'Great apartment! Loved the view and the host was very nice.'),
            ],
          ),
        ),
      ],
    );
  }
}

/// [_BuildBottomBookingBar]
/// The fixed bottom bar containing Price and Book Button.
class _BuildBottomBookingBar extends StatelessWidget {
  final Apartment apartment;

  const _BuildBottomBookingBar({required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${apartment.price}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  l10n.per_month,
                  style:
                      theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => BookingBottomSheet(
                    apartment: apartment,
                  ),
                );
              },
              text: l10n.book_now,
            ),
          ),
        ],
      ),
    );
  }
}
