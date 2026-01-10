import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/config/color/app_color.dart';
import '../../../core/constants/app_constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/booking/manage_booking.dart';
import '../../cubits/property/property_cubit.dart';
import '../../global_widgets/apartment_cards/apartment_card.dart';
import '../../global_widgets/apartment_cards/apartment_shimmer.dart';
import '../../global_widgets/glowing_key/build_glowing_key.dart';
import '../../global_widgets/user_profile_image/user_profile_image.dart';
import '../details/details_screen.dart';
import '../property/add_property.dart';
import 'booking_card.dart';
import 'booking_shimmer.dart';

class ManagePropertiesScreen extends StatefulWidget {
  const ManagePropertiesScreen({super.key});

  @override
  State<ManagePropertiesScreen> createState() => _ManagePropertiesScreenState();
}

class _ManagePropertiesScreenState extends State<ManagePropertiesScreen> {
  final PageController _pageController = PageController();
  final ScrollController _myApartmentsScrollController = ScrollController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _refreshInitialData();

    _myApartmentsScrollController.addListener(() {
      if (_myApartmentsScrollController.position.pixels >=
          _myApartmentsScrollController.position.maxScrollExtent * 0.9) {
        context.read<MyApartmentsCubit>().fetchMyApartments();
      }
    });

    _pageController.addListener(() {
      if (_pageController.hasClients) {
        int next = _pageController.page!.round();
        if (_currentPage != next) {
          setState(() => _currentPage = next);
        }
      }
    });
  }

  void _refreshInitialData() {
    context.read<MyApartmentsCubit>().fetchMyApartments(isRefresh: true);
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<ManageBookingCubit>().fetchAllBookings(authState.user.id);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _myApartmentsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: _currentPage == 0
          ? GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddPropertyScreen()),
        ),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            gradient: AppColors.premiumGoldGradient2,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryLight.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_home_work_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                tr.add_new,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 340.0,
              backgroundColor: Theme.of(context).primaryColor,
              centerTitle: true,
              elevation: 0,
              title: Text(tr.property_manager,
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: Theme.of(context).scaffoldBackgroundColor)),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.premiumGoldGradient2,
                      ),
                    ),

                    PositionedDirectional(
                      top: 40,
                      end: -30,
                      child: const BuildGlowingKey(size: 140,opacity:  0.15,rotation:  0.5),
                    ),
                    PositionedDirectional(
                      top: 10,
                      start: 10,
                      child: const BuildGlowingKey(size: 80,opacity:  0.15,rotation: -0.3),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: kToolbarHeight + 40),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),

                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildProfileHeader(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      _buildGradientIndicator(),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTabItem(tr.properties, 0),
                            _buildTabItem(tr.inbound, 1),
                            _buildTabItem(tr.history, 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },

          body: PageView(
            controller: _pageController,
            children: [
              _buildPropertiesList(),
              _buildBookingsTab(targetStatus: 'pending'),
              _buildBookingsTab(targetStatus: 'history'),
            ],
          ),
        ),
      );
  }

  Widget _buildBookingsTab({required String targetStatus}) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return const Center(child: Text("Please Login"));
        }

        return BlocBuilder<ManageBookingCubit, ManageBookingState>(
          buildWhen: (prev, curr) =>
          curr is AllBookingLoading || curr is AllBookingsLoaded,
          builder: (context, state) {
            if (state is AllBookingLoading) {
              return const _BuildShimmerRequest();
            }

            if (state is AllBookingsLoaded) {
              final bookings = state.bookings.where((b) {
                return (targetStatus == 'pending')
                    ? b.status == 'pending'
                    : b.status != 'pending';
              }).toList();

              if (bookings.isEmpty) {
                return const Center(child: Text("No data found"));
              }

              return RefreshIndicator(
                onRefresh: () async => context
                    .read<ManageBookingCubit>()
                    .fetchAllBookings(authState.user.id),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    return BookingCardWidget(
                      booking: bookings[index],
                      isPending: targetStatus == 'pending',
                      ownerId: authState.user.id,
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildPropertiesList() {
    return BlocBuilder<MyApartmentsCubit, ApartmentState>(
      builder: (context, state) {
        if (state is MyApartmentsLoading) {
          return const _BuildShimmerPropertying();
        }
        if (state is MyApartmentsLoaded) {
          if (state.myApartments.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => context
                  .read<MyApartmentsCubit>()
                  .fetchMyApartments(isRefresh: true),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200, child: Center(child: Text("No properties added yet.")))
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context
                .read<MyApartmentsCubit>()
                .fetchMyApartments(isRefresh: true),
            child: ListView.builder(
              controller: _myApartmentsScrollController,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
              itemCount: state.myApartments.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index < state.myApartments.length) {
                  return ApartmentCard(
                    apartment: state.myApartments[index],
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DetailsScreen(
                                apartment: state.myApartments[index]))),
                  );
                } else {
                  return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator.adaptive()));
                }
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProfileHeader() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String name = "User";
        int? id;
        if (state is AuthAuthenticated) {
          name = "${state.user.first_name} ${state.user.last_name}";
          id = state.user.id;
        }
        return Column(
          children: [
            UserProfileImage(
              userId: id ?? 0,
              radius: 60,
              firstName: name.split(' ')[0],
              lastName: name.split(' ')[1],
              isPremiumStyle: true,
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          ],
        );
      },
    );
  }

  Widget _buildTabItem(String title, int index) {
    bool isSelected = _currentPage == index;
    return GestureDetector(
      onTap: () => _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(15)),
        child: Text(title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey)),
      ),
    );
  }

  Widget _buildGradientIndicator() {
    return SmoothPageIndicator(
      controller: _pageController,
      count: 3,
      effect: ExpandingDotsEffect(
          activeDotColor: Theme.of(context).colorScheme.primary,
          dotHeight: 6,
          dotWidth: 6,
          expansionFactor: 4),
    );
  }
}

class _BuildShimmerPropertying extends StatelessWidget {
  const _BuildShimmerPropertying();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: AppConstants.numberOfApartmentsEachRequest,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
        child: const BuildShimmerCard(),
      ),
    );
  }
}

class _BuildShimmerRequest extends StatelessWidget {
  const _BuildShimmerRequest();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: AppConstants.numberOfBookingEachRequest,
      itemBuilder: (context, index) => const BuildBookingShimmer(),
    );
  }
}