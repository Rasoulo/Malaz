import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entities/apartment.dart';
import '../../../core/config/routes/route_info.dart';
import '../../cubits/home/home_cubit.dart';
import '../../global_widgets/apartment_card.dart';
import '../side_drawer/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    final cubit = context.read<HomeCubit>();
    if (cubit.state is HomeInitial) {
      cubit.loadApartments();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HomeCubit>().loadApartments(loadNext: true);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorScheme.background,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _BuildHomeHeader(scaffoldKey: _scaffoldKey),
            const _BuildFilterList(),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await context.read<HomeCubit>().loadApartments(isRefresh: true);
                },
                child: _BuildHomeBody(scrollController: _scrollController),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// [UI_BUILDING_WIDGETS]

/// *[contains]
/// - [_BuildHomeHeader]
/// - [_BuildFilterList]
/// - [_BuildHomeBody]
/// - [_BuildApartmentList]
/// - [_BuildBottomLoader]
/// - [_BuildErrorView]
/// - [_BuildAddPropertyFab]
///
class _BuildHomeHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _BuildHomeHeader({required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _BuildIconButton(
            icon: Icons.menu,
            onTap: () => scaffoldKey.currentState?.openDrawer(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: colorScheme.onSurface.withOpacity(0.5)),
                  const SizedBox(width: 8),
                  Text( /// TODO: this's must be a text field
                    'Search apartments...',
                    style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          _BuildIconButton(
            icon: Icons.tune,
            onTap: () {},
            color: colorScheme.primary,
            iconColor: colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}

class _BuildFilterList extends StatelessWidget {
  const _BuildFilterList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: const [
          _BuildFilterChip(label: 'All', isSelected: true),
          _BuildFilterChip(label: 'Near Me'),
          _BuildFilterChip(label: 'High Rated'),
          _BuildFilterChip(label: 'Newest'),
        ],
      ),
    );
  }
}

class _BuildHomeBody extends StatelessWidget {
  final ScrollController scrollController;

  const _BuildHomeBody({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HomeError) {
          return _BuildErrorView(message: state.message);
        }

        if (state is HomeLoaded) {
          if (state.apartments.isEmpty) {
            /// TODO: put some nice pic and animation with this text.
            return const Center(child: Text("No apartments found!"));
          }
          return _BuildApartmentList(
            apartments: state.apartments,
            hasReachedMax: state.hasReachedMax,
            scrollController: scrollController,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _BuildApartmentList extends StatelessWidget {
  final List<Apartment> apartments;
  final bool hasReachedMax;
  final ScrollController scrollController;

  const _BuildApartmentList({
    required this.apartments,
    required this.hasReachedMax,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: hasReachedMax ? apartments.length : apartments.length + 1,
      itemBuilder: (context, index) {
        if (index >= apartments.length) {
          return const _BuildBottomLoader();
        }

        final apartment = apartments[index];
        return ApartmentCard(
          apartment: apartment,
          onTap: () {
            context.pushNamed(RouteNames.details, extra: apartment);
          },
        );
      },
    );
  }
}

class _BuildBottomLoader extends StatelessWidget {
  const _BuildBottomLoader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}


class _BuildErrorView extends StatelessWidget {
  final String message;

  const _BuildErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => context.read<HomeCubit>().loadApartments(isRefresh: true),
            child: const Text('Retry'),
          )
        ],
      ),
    );
  }
}

// !important note : do not uncomment this block it's cause a failure in
// !bottom bar navigation

/*class _BuildAddPropertyFab extends StatelessWidget {
  const _BuildAddPropertyFab();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FloatingActionButton(
      heroTag: 'add_property_fab',
      onPressed: () {
        context.pushNamed(RouteNames.addProperty);
      },
      backgroundColor: colorScheme.primary,
      shape: const CircleBorder(),
      child: Icon(Icons.add, color: colorScheme.onPrimary, size: 30),
    );
  }
}*/


/// [UI_BUILDING_SUB_WIDGET]
/// *[contains]
///
/// - [_BuildIconButton]
/// - [_BuildFilterChip]

class _BuildIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final Color? iconColor;

  const _BuildIconButton({required this.icon, required this.onTap, this.color, this.iconColor});

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
            border: Border.all(color: Colors.grey.withOpacity(0.2))),
        child: Icon(icon, color: iconColor ?? colorScheme.onSurface.withOpacity(0.7)),
      ),
    );
  }
}

class _BuildFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _BuildFilterChip({required this.label, this.isSelected = false});

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
          color: isSelected ? colorScheme.primary : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.bold),
      ),
    );
  }
}