import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:malaz/presentation/cubits/home/home_cubit.dart';
import '../../../core/config/color/app_color.dart';
import '../../global_widgets/apartment_card.dart';
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
        setState(() {
          _currentPage = next;
        });
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: _currentPage == 0
          ? FloatingActionButton(
        heroTag: 'manage_property_fab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddPropertyScreen()),
          );
        },
        backgroundColor: colorScheme.primary,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: colorScheme.onPrimary, size: 30),
      )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 410.0,
              backgroundColor: colorScheme.primary,
              elevation: 0,
              centerTitle: true,
              title: const Text('My Profile',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  margin: const EdgeInsets.only(top: kToolbarHeight + 20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildProfileImage(),
                      const SizedBox(height: 15),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.realGoldGradient.createShader(bounds),
                        child: const Text(
                          'John Doe',
                          style: TextStyle(
                              color: AppColors.surfaceLight,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Container(
                  width: double.infinity,
                  color: colorScheme.surface,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildGradientIndicator(),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Properties",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text("Inbound",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text("Past Rentals",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
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
        body: Container(
          color: colorScheme.surface,
          child: PageView(
            controller: _pageController,
            children: [
              _buildPropertiesList(),
              _buildInboundRequestsList(),
              _buildPastRentalsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertiesList() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is HomeLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: state.apartments.length,
            itemBuilder: (context, index) {
              final apartment = state.apartments[index];
              return ApartmentCard(
                apartment: apartment,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailsScreen(apartment: apartment))),
              );
            },
          );
        }
        return const Center(child: Text("Error loading properties"));
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
        InboundRequestCard(
          tenantName: 'Ali Ahmed',
          dateRange: '05 Jan - 12 Jan',
          peopleCount: 2,
          apartmentImageUrl:
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500',
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

  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) => const LinearGradient(
            colors: [Colors.yellow, Colors.orange, Colors.yellowAccent],
          ).createShader(bounds),
          child: Container(
            width: 190,
            height: 190,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
          ),
        ),
        const CircleAvatar(
          radius: 90,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=600'),
        ),
      ],
    );
  }

  Widget _buildGradientIndicator() {
    return ShaderMask(
      shaderCallback: (bounds) =>
          AppColors.realGoldGradient.createShader(bounds),
      child: SmoothPageIndicator(
        controller: _pageController,
        count: 3,
        effect: const ExpandingDotsEffect(
          activeDotColor: Colors.white,
          dotColor: AppColors.surfaceLight,
          dotHeight: 10,
          expansionFactor: 3,
        ),
      ),
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
                  child: Text(
                      widget.status.toUpperCase(), // سيظهر هنا ACCEPTED أو PENDING
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
    return Colors.orange; // لـ pending
  }
}