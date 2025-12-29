import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:malaz/presentation/screens/home/home_screen.dart';
import '../booking/booking_screen.dart';
import '../chats/chats_screen.dart';
import '../favorites/favorites_screen.dart';
import '../manage_property/manage_property.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ChatsScreen(),
    const FavoritesScreen(),
    const BookingsScreen(),
    const ManagePropertiesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _BuildModernNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

/// ============================================================================
/// [_BuildModernNavBar]
/// Modified to be Responsive using MediaQuery.
/// ============================================================================
class _BuildModernNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const _BuildModernNavBar({
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 400;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8.0 : 15.0,
              vertical: 8
          ),
          child: GNav(
            rippleColor: theme.colorScheme.primary.withOpacity(0.1),
            hoverColor: theme.colorScheme.primary.withOpacity(0.1),

            gap: isSmallScreen ? 4 : 8,

            activeColor: theme.colorScheme.primary,

            iconSize: isSmallScreen ? 22 : 24,

            padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 10 : 20,
                vertical: 12
            ),

            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            color: Colors.grey,

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            tabs: const [
              GButton(
                icon: Icons.home_rounded,
                text: 'Home',
              ),
              GButton(
                icon: Icons.chat_bubble,
                text: 'Chats',
              ),
              GButton(
                icon: Icons.favorite_border_rounded,
                text: 'Saved',
              ),
              GButton(
                icon: Icons.edit_calendar_sharp,
                text: 'Booking',
              ),
              GButton(
                icon: Icons.paid_outlined,
                text: 'My Properties',
              ),
            ],
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        ),
      ),
    );
  }
}