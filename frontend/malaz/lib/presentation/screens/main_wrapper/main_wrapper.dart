import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

// تأكد من صحة هذه المسارات بناءً على بنية ملفاتك
import '../booking/booking_screen.dart';
import '../chats/chats_screen.dart';
import '../favorites/favorites_screen.dart';
import '../home/home_screen.dart';
import '../manage_property/manage_property.dart'; // هذا الملف يجب أن يحتوي على ManagePropertiesScreen
import '../side_drawer/app_drawer.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  // قائمة الصفحات مرتبة حسب الترتيب في شريط التنقل
  final List<Widget> _screens = const [
    HomeScreen(),             // 0
    ChatsScreen(),            // 1
    FavoritesScreen(),        // 2
    BookingsScreen(),         // 3
    ManagePropertiesScreen(), // 4
  ];

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // إعداد ألوان الأيقونات بناءً على الثيم


    return SafeArea(child:
      Scaffold(
      // تم حذف الـ FloatingActionButton من هنا بناءً على طلبك
      drawer: const AppDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _currentIndex,
        height: 45,
        items: <Widget>[
          Icon(Icons.home_outlined,
              size: _currentIndex == 0 ? 30:24,color: colorScheme.surface,),
          Icon(Icons.chat_bubble_outline,
              size: _currentIndex == 1 ? 30:24,color: colorScheme.surface,),
          Icon(Icons.favorite_outline,
              size: _currentIndex == 2 ? 30:24,color: colorScheme.surface,),
          Icon(Icons.calendar_today_outlined,
              size: _currentIndex == 3 ? 30:24,color: colorScheme.surface,),
          Icon(Icons.person_outline,
              size: _currentIndex == 4 ? 30:24,color: colorScheme.surface,),
        ],
        color: colorScheme.secondary,
        buttonBackgroundColor: colorScheme.primary,
        backgroundColor: Colors.transparent,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    ));
  }
}