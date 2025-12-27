import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:malaz/presentation/cubits/home/home_cubit.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../../core/config/color/app_color.dart';
import '../../global_widgets/apartment_card.dart';
import '../auth/my_profile/my_profile_screen.dart';
import '../details/details_screen.dart';
import '../property/add_property.dart';

class ManagePropertiesScreen extends StatefulWidget {
  const ManagePropertiesScreen({super.key});

  @override
  State<ManagePropertiesScreen> createState() => _ManagePropertiesScreenState();
}

class _ManagePropertiesScreenState extends State<ManagePropertiesScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() => _currentPage = next);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _currentPage == 0
          ? FloatingActionButton.extended(
        heroTag: 'manage_property_fab',
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddPropertyScreen())),
        backgroundColor: colorScheme.primary,
        elevation: 4,
        icon: Icon(Icons.add_home_work_rounded, color: colorScheme.onPrimary),
        label: Text("Add New",
            style: TextStyle(
                color: colorScheme.onPrimary, fontWeight: FontWeight.bold)),
      )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 360.0,
              backgroundColor: colorScheme.primary,
              elevation: 0,
              centerTitle: true,
              title: Text('Property Manager',
                  style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1, color: colorScheme.surface)),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withOpacity(0.8)
                      ],
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(top: kToolbarHeight + 10),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(35)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 25),
                        _buildProfileImage(),
                        const SizedBox(height: 12),
                        _buildUserName(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildGradientIndicator(),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTabItem("Properties", 0),
                            _buildTabItem("Inbound", 1),
                            _buildTabItem("History", 2),
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
            _buildInboundRequestsList(),
            _buildPastRentalsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserName() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String name = "Premium Member";
        if (state is AuthAuthenticated) {
          name = "${state.user.first_name} ${state.user.last_name}";
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.premiumGoldGradient.createShader(bounds),
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabItem(String title, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    bool isSelected = _currentPage == index;
    return GestureDetector(
      onTap: () => _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String? img;
        if (state is AuthAuthenticated) img = state.user.profile_image_url;

        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: colorScheme.primary.withOpacity(0.15),
                  blurRadius: 15,
                  spreadRadius: 1)
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) =>
                    AppColors.premiumGoldGradient.createShader(bounds),
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
              CircleAvatar(
                radius: 66,
                backgroundColor: colorScheme.surfaceVariant,
                child: (img == null || img.isEmpty)
                    ? Icon(Icons.person_rounded,
                    size: 55, color: colorScheme.primary.withOpacity(0.5))
                    : ClipOval(
                    child: UserProfileImage(imageUrl: img, size: 132.0)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGradientIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SmoothPageIndicator(
        controller: _pageController,
        count: 3,
        effect: ExpandingDotsEffect(
          activeDotColor: Theme.of(context).colorScheme.primary,
          dotColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
          dotHeight: 5,
          dotWidth: 5,
          expansionFactor: 4,
          spacing: 8,
        ),
      ),
    );
  }

  Widget _buildPropertiesList() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (state is HomeLoaded) {
          if (state.apartments.isEmpty) {
            return const Center(child: Text("No Properties Found"));
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            itemCount: state.apartments.length,
            itemBuilder: (context, index) => ApartmentCard(
              apartment: state.apartments[index],
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          DetailsScreen(apartment: state.apartments[index]))),
            ),
          );
        }
        return const Center(child: Text("Something went wrong"));
      },
    );
  }

  Widget _buildInboundRequestsList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        InboundRequestCard(
          tenantName: 'Samer Issa',
          dateRange: '22 Dec - 28 Dec',
          peopleCount: 3,
          apartmentImageUrl:
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=500',
          status: 'pending',
        ),
      ],
    );
  }

  Widget _buildPastRentalsList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        InboundRequestCard(
          tenantName: 'Omar Khaled',
          dateRange: '01 Nov - 10 Nov',
          peopleCount: 2,
          apartmentImageUrl:
          'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=500',
          status: 'completed',
        ),
      ],
    );
  }
}

class InboundRequestCard extends StatefulWidget {
  final String tenantName;
  final String dateRange;
  final int peopleCount;
  final String apartmentImageUrl;
  String status;

  InboundRequestCard({
    super.key,
    required this.tenantName,
    required this.dateRange,
    required this.peopleCount,
    required this.apartmentImageUrl,
    required this.status,
  });

  @override
  State<InboundRequestCard> createState() => _InboundRequestCardState();
}

class _InboundRequestCardState extends State<InboundRequestCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Column(
        children: [
          Stack(
            children: [
              Image.network(widget.apartmentImageUrl,
                  height: 140, width: double.infinity, fit: BoxFit.cover),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(widget.status),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(widget.status.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.tenantName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_month,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(widget.dateRange,
                        style:
                        const TextStyle(color: Colors.grey, fontSize: 13)),
                    const Spacer(),
                    const Icon(Icons.people, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text('${widget.peopleCount} Guests',
                        style:
                        const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
                if (widget.status == 'pending') ...[
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              setState(() => widget.status = 'canceled'),
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red)),
                          child: const Text('Reject'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              setState(() => widget.status = 'accepted'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white),
                          child: const Text('Accept'),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: _getStatusColor(widget.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        widget.status == 'accepted'
                            ? 'Request Accepted'
                            : widget.status == 'completed'
                            ? 'Successfully Rented'
                            : 'Request Canceled',
                        style: TextStyle(
                            color: _getStatusColor(widget.status),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'completed' || status == 'accepted') return Colors.green;
    if (status == 'canceled') return Colors.red;
    return Colors.orange;
  }
}