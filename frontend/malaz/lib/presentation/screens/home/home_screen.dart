import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:malaz/core/config/color/app_color.dart';
import 'package:malaz/core/constants/app_constants.dart';
import 'package:malaz/presentation/global_widgets/brand/build_branding.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/config/routes/route_info.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubits/home/home_cubit.dart';
import '../../global_widgets/apartment_cards/apartment_card.dart';
import '../side_drawer/app_drawer.dart';
import '../../global_widgets/apartment_cards/apartment_shimmer.dart';
import 'filter_bottom_sheet.dart';

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

  bool _showStickyHeader = false;

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

    if (_scrollController.hasClients) {
      final show = _scrollController.offset > 200;
      if (show != _showStickyHeader) {
        setState(() {
          _showStickyHeader = show;
        });
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutQuint,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            _BuildScrollableBody(
              scrollController: _scrollController,
              scaffoldKey: _scaffoldKey,
            ),
            _BuildStickyHeader(
              isVisible: _showStickyHeader,
              onTapBack: _scrollToTop,
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// [UI_BUILDING_WIDGETS]
/// ============================================================================

/// [_BuildScrollableBody]
class _BuildScrollableBody extends StatelessWidget {
  final ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _BuildScrollableBody({
    required this.scrollController,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<HomeCubit>().loadApartments(isRefresh: true);
      },
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: _BuildMainBrandingHeader(scaffoldKey: scaffoldKey),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const SliverToBoxAdapter(child: _BuildShimmerLoading());
              }

              if (state is HomeError) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _BuildErrorView(message: state.message),
                );
              }

              if (state is HomeLoaded) {
                if (state.apartments.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _BuildErrorView(
                        message: AppLocalizations.of(context)
                            .unexpected_error_message),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= state.apartments.length) {
                        return state.hasReachedMax
                            ? const SizedBox.shrink()
                            : const _BuildBottomLoader();
                      }
                      final apartment = state.apartments[index];
                      return ApartmentCard(
                        apartment: apartment,
                        onTap: () {
                          context.pushNamed(RouteNames.details,
                              extra: apartment);
                        },
                      );
                    },
                    childCount: state.hasReachedMax
                        ? state.apartments.length
                        : state.apartments.length + 1,
                  ),
                );
              }

              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}

/// [_BuildMainBrandingHeader]
class _BuildMainBrandingHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _BuildMainBrandingHeader({required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _BuildIconButton(
            icon: Icons.menu_rounded,
            onTap: () => scaffoldKey.currentState?.openDrawer(),
          ),
          BuildBranding.nameLottie(
              lottie: Lottie.asset('assets/lottie/shake_share_laptop.json'),
              width: 80,
              height: 80),
          _BuildIconButton(
            icon: Icons.tune_rounded,
            color: AppColors.primaryDark.withOpacity(0.1),
            iconColor: AppColors.primaryDark,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const FilterBottomSheet(),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// [_BuildStickyHeader]
class _BuildStickyHeader extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTapBack;

  const _BuildStickyHeader({
    required this.isVisible,
    required this.onTapBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutBack,
      top: isVisible ? 10 : -80,
      left: 0,
      right: 0,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTapBack,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 100,
              height: 25,
              decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.rectangle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(32)),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: theme.colorScheme.primary,
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// [HELPER_WIDGETS]
/// ============================================================================
class _BuildIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final Color? iconColor;

  const _BuildIconButton({
    required this.icon,
    required this.onTap,
    this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color ?? (isDark ? Colors.grey[800] : Colors.white),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.25),
                blurRadius: 15,
                offset: const Offset(0, 4),
              )
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1))),
        child: Icon(icon,
            color: iconColor ?? theme.colorScheme.onSurface.withOpacity(0.8),
            size: 24),
      ),
    );
  }
}

class _BuildBottomLoader extends StatelessWidget {
  const _BuildBottomLoader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24.0),
      child: Center(
          child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2))),
    );
  }
}

class _BuildShimmerLoading extends StatelessWidget {
  const _BuildShimmerLoading();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: List.generate(
        3,
        (index) => Shimmer.fromColors(
          baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
          child: const BuildShimmerCard(),
        ),
      ),
    );
  }
}

/// [_BuildErrorView]
class _BuildErrorView extends StatelessWidget {
  final String message;

  const _BuildErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String displayMessage = message;

    if (message == AppConstants.networkFailureKey) {
      displayMessage = AppLocalizations.of(context).network_error_message;
    } else if (message == AppConstants.cancelledFailureKey) {
      displayMessage =
          AppLocalizations.of(context).request_cancelled_error_message;
    } else {
      displayMessage = AppLocalizations.of(context).unexpected_error_message;
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 64,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context).warring,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              displayMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<HomeCubit>().loadApartments(isRefresh: true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  elevation: 4,
                  shadowColor: theme.colorScheme.primary.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(
                  AppLocalizations.of(context).retry,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
