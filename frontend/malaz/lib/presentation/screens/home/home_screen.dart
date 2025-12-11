import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/presentation/cubits/home/home_cubit.dart';
import '../../../domain/entities/apartment.dart';
import '../../global_widgets/apartment_card.dart';
import '../details/details_screen.dart';
import '../property/add_property.dart';
import '../side_drawer/app_drawer.dart';


/// [HomeScreen]
/// must be cleaned up
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تم حذف .read() واستخدام .watch() أو .select() إذا كان Cubit يحتاج استماع
    // ولكن الطريقة الحالية جيدة إذا كان .read() يعطي instance جاهز
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
        floatingActionButton: _FabAnimationWrapper(
          child: FloatingActionButton(
            heroTag: 'add_property_fab',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // استدعاء الكلاس الذي أنشأناه سابقاً
                  builder: (context) => const AddProperty(),
                ),
              );
            },
            backgroundColor: colorScheme.primary,
            child: Icon(Icons.add, color: colorScheme.onPrimary, size: 30),
            shape: const CircleBorder(),
          ),
        ),
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
  // ... بقية الـ Widgets الأخرى تبقى كما هي ...

  // Widget _buildHeader(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {...}
  // Widget _buildFilterChips(BuildContext context) {...}
  // Widget _buildApartmentList(BuildContext context, List<Apartment> apartments) {...}

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

// الكلاس الجديد في نهاية ملف HomeScreen.dart

class _FabAnimationWrapper extends StatefulWidget {
  final Widget child;
  const _FabAnimationWrapper({required this.child});

  @override
  State<_FabAnimationWrapper> createState() => _FabAnimationWrapperState();
}

class _FabAnimationWrapperState extends State<_FabAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<Offset> _slideAnimation; // NEW: لتأثير الحركة

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // مدة التحريك
    );

    // 1. تحريك الشفافية (Fade In)
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // 2. تحريك الموضع (Slide Up)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // يبدأ من أسفل موضعه الأصلي
      end: Offset.zero, // ينتهي في موضعه الأصلي (0.0, 0.0)
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    // يبدأ التحريك بعد 300 مللي ثانية
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // دمج التحريكين
    return SlideTransition(
      position: _slideAnimation, // الحركة
      child: FadeTransition(
        opacity: _opacityAnimation, // الظهور التدريجي
        child: widget.child,
      ),
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
    final colorScheme = Theme
        .of(context)
        .colorScheme;

    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary : colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : (Theme
              .of(context)
              .brightness == Brightness.dark
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