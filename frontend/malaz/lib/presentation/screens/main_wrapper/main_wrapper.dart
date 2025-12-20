import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../booking/booking_screen.dart';
import '../chats/chats_screen.dart';
import '../favorites/favorites_screen.dart';
import '../home/home_screen.dart';
import '../property/add_property.dart';
import '../side_drawer/app_drawer.dart';
import '../../../l10n/app_localizations.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ChatsScreen(),
    FavoritesScreen(),
    BookingsScreen(),
  ];

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;
    final Color fabColor = colorScheme.primary;

    final item = <Widget>[
      Icon(Icons.home_outlined, size: 30, color:colorScheme.onPrimary),
      Icon(Icons.chat_outlined, size: 30, color:colorScheme.onPrimary),
      Icon(Icons.favorite_outline, size: 30, color:colorScheme.onPrimary),
      Icon(Icons.calendar_today_outlined, size: 30, color:colorScheme.onPrimary),
    ];

    return Padding(padding: EdgeInsetsGeometry.only(bottom: 20),
        child: Scaffold(
            //extendBody: true,
            drawer: const AppDrawer(),
            body: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),

            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

            floatingActionButton: Visibility(
              visible: _currentIndex == 0,
              child: _FabAnimationWrapper(
                child: FloatingActionButton(
                  heroTag: 'main_add_fab',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPropertyScreen()));
                  },
                  backgroundColor: fabColor,
                  child: Icon(Icons.add, color: colorScheme.onPrimary, size: 30),
                  shape: const CircleBorder(),
                ),
              ),
            ),

            bottomNavigationBar: CurvedNavigationBar(
              key: _bottomNavigationKey,
              color: colorScheme.primary,
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: colorScheme.primary,
              height: 75,
              index: _currentIndex,
              items: item,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            )
        ));
  }
}

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
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

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
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: widget.child,
      ),
    );
  }
}