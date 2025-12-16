import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../booking/booking_screen.dart';
import '../chats/chats_screen.dart';
import '../favorites/favorites_screen.dart';
import '../home/home_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    const ChatsScreen(),
    const FavoritesScreen(),
    const BookingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // هنا دمجنا الـ Padding لرفع الشريط
      
      bottomNavigationBar: Padding(
  padding: const EdgeInsets.only(bottom: 0), // يرفع الشريط عن الأرض
  child: SizedBox(
    height: 110, // هون بتحدد الارتفاع اللي بدك إياه
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(35),
        topRight: Radius.circular(35),

      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        showUnselectedLabels: true,
        elevation: 5.0,
        items: [
          BottomNavigationBarItem(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _currentIndex == 0
                  ? const Icon(Icons.home, key: ValueKey('home_filled'))
                  : const Icon(Icons.home_outlined, key: ValueKey('home_outlined')),
            ),
            label: tr.home,
          ),

          BottomNavigationBarItem(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _currentIndex == 1
                  ? const Icon(Icons.chat_bubble, key: ValueKey('chat_filled'))
                  : const Icon(Icons.chat_bubble_outline, key: ValueKey('chat_outlined')),
            ),
            label: tr.chats,
          ),
          BottomNavigationBarItem(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _currentIndex == 2
                  ? const Icon(Icons.favorite, key: ValueKey('fav_filled'))
                  : const Icon(Icons.favorite_border, key: ValueKey('fav_outlined')),
            ),
            label: tr.favorites,
          ),
          BottomNavigationBarItem(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _currentIndex == 3
                  ? const Icon(Icons.calendar_today, key: ValueKey('cal_filled'))
                  : const Icon(Icons.calendar_today_outlined, key: ValueKey('cal_outlined')),
            ),
            label: tr.bookings,
          ),
        ],
      ),
    ),
  ),
));
  }}