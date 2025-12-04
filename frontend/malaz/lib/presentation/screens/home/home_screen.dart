
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/presentation/cubits/home/home_cubit.dart';
import '../../../domain/entities/apartment.dart';
import '../../global widgets/apartment_card.dart';
import '../details/details_screen.dart';
import '../side drawer/app_drawer.dart';


/// [HomeScreen]
/// must be cleaned up
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<HomeCubit>()..fetchApartments(),
      child: const HomeView(),
    );
  }
}


class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: colorScheme.background,
        drawer: const AppDrawer(),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, scaffoldKey),
              _buildFilterChips(context),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading || state is HomeInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is HomeLoaded) {
                      return _buildApartmentList(context, state.apartments);
                    }
                    if (state is HomeError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildHeader(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _IconBtn(
            icon: Icons.menu,
            onTap: () => scaffoldKey.currentState?.openDrawer(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.transparent
                        : Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.search,
                      color: colorScheme.onSurface.withOpacity(0.5)),
                  const SizedBox(width: 8),
                  Text('Search apartments...',
                      style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.5))),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          _IconBtn(
            icon: Icons.tune,
            onTap: () {},
            color: colorScheme.primary,
            iconColor: colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: const [
          _FilterChip(label: 'All', isSelected: true),
          _FilterChip(label: 'Near Me'),
          _FilterChip(label: 'High Rated'),
          _FilterChip(label: 'Newest'),
        ],
      ),
    );
  }

  Widget _buildApartmentList(
      BuildContext context, List<Apartment> apartments) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: apartments.length,
      itemBuilder: (context, index) {
        final apartment = apartments[index];
        return ApartmentCard(
          apartment: apartment,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailsScreen(apartment: apartment),
              ),
            );
          },
        );
      },
    );
  }
}


class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final Color? iconColor;

  const _IconBtn(
      {required this.icon, required this.onTap, this.color, this.iconColor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: color ?? colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.transparent
                    : Colors.grey.shade100)),
        child: Icon(icon,
            color: iconColor ?? colorScheme.onSurface.withOpacity(0.7)),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary : colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : (Theme.of(context).brightness == Brightness.dark
                  ? Colors.transparent
                  : Colors.grey.shade300),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
