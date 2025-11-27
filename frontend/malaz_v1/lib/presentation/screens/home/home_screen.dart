// file: lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../../../core/config/theme/theme_config.dart';
import '../../../data/source/apartments/apartments_source.dart';
import '../../global widgets/apartment_card.dart';
import '../Drawer/app_drawer.dart';
import '../details/details_screen.dart';

class HomeScreen extends StatelessWidget {
  // 2. نحتاج هذا المفتاح للتحكم في الـ Scaffold وفتح الـ Drawer برمجياً
  // لأننا لا نستخدم AppBar قياسي
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // 3. ربط المفتاح بالـ Scaffold
      backgroundColor: AppColors.background,

      // 4. إضافة الـ Drawer هنا
      drawer: const AppDrawer(),

      body: SafeArea(
        child: Column(
          children: [
            // Header & Search Area
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // 5. تفعيل زر القائمة لفتح الـ Drawer
                  _buildIconBtn(Icons.menu, () {
                    _scaffoldKey.currentState?.openDrawer();
                  }),
                  const SizedBox(width: 12),

                  // Search Box
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8),
                          Text('Search apartments...', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Filter Button
                  _buildIconBtn(Icons.tune, () {
                    // Show Filter Logic
                  }, color: AppColors.primary, iconColor: Colors.white),
                ],
              ),
            ),

            // Filter Chips (Horizontal Scroll)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildFilterChip('All', true),
                  _buildFilterChip('Near Me', false),
                  _buildFilterChip('High Rated', false),
                  _buildFilterChip('Newest', false),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Apartment List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                // نستخدم البيانات الوهمية التي عرفناها سابقاً
                itemCount: mockApartments.length,
                itemBuilder: (context, index) {
                  return ApartmentCard(
                    apartment: mockApartments[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(apartment: mockApartments[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets (Refactored for cleaner code)

  Widget _buildIconBtn(IconData icon, VoidCallback onTap, {Color color = Colors.white, Color iconColor = Colors.grey}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100)
        ),
        child: Icon(icon, color: iconColor),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}