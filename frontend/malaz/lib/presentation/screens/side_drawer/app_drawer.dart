import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/color/app_color.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../../data/datasources/local/auth_local_datasource.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/language/language_cubit.dart';
import '../../cubits/theme/theme_cubit.dart';

enum ThemeOption { light, dark, system }

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tr = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) context.go('/login');
      },
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.82,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        child: Column(
          children: [
            _buildUserHeader(context, tr, colorScheme, isDark),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withOpacity(0.2) : Colors.grey.shade50.withOpacity(0.5),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  children: [
                    _buildDrawerItem(context, Icons.person_outline_rounded, tr.my_profile, () => context.push('/profile')),
                    _buildDrawerItem(context, Icons.palette_outlined, tr.theme, () {
                      Navigator.pop(context);
                      _showThemeBottomSheet(context);
                    }),
                    _buildDrawerItem(context, Icons.language_rounded, tr.language, () {
                      Navigator.pop(context);
                      _showLanguageBottomSheet(context);
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Divider(color: colorScheme.outlineVariant.withOpacity(0.3), thickness: 0.5),
                    ),
                    _buildDrawerItem(context, Icons.apartment_rounded, tr.become_a_renter, () {}),
                    _buildDrawerItem(context, Icons.settings_outlined, tr.settings, () => context.push('/settings')),
                  ],
                ),
              ),
            ),
            _buildLogoutButton(context, colorScheme, tr),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, AppLocalizations tr, ColorScheme colorScheme, bool isDark) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String name = 'Guest User';
        String? img;
        if (state is AuthAuthenticated) {
          name = "${state.user.first_name} ${state.user.last_name}";
          img = state.user.profile_image_url;
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
          decoration: BoxDecoration(
            gradient: AppColors.premiumGoldGradient2,
            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildModernAvatar(img, colorScheme, isDark),
              const SizedBox(height: 20),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              _buildEditButton(context, tr),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernAvatar(String? img, ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: CircleAvatar(
          radius: 42,
          backgroundColor: isDark ? Colors.white10 : Colors.white24,
          child: (img == null || img.isEmpty)
              ? const Icon(Icons.person, size: 45, color: Colors.white)
              : ClipOval(child: UserProfileImage(imageUrl: img, size: 84)),
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context, AppLocalizations tr) {
    return InkWell(
      onTap: () => context.push('/profile'),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.edit_note_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(tr.edit_profile, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: colorScheme.onSurface.withOpacity(0.6), size: 22),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: colorScheme.onSurface, fontSize: 15)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildLogoutButton(BuildContext context, ColorScheme colorScheme, AppLocalizations tr) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListTile(
        leading: Icon(Icons.logout_rounded, color: colorScheme.error.withOpacity(0.7)),
        title: Text(tr.logout, style: TextStyle(color: colorScheme.error.withOpacity(0.7), fontWeight: FontWeight.bold)),
        onTap: () => context.read<AuthCubit>().logout(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: colorScheme.outlineVariant.withOpacity(0.4), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 25),
            Text(tr.select_theme, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            const SizedBox(height: 30),
            _ThemeSwitcher(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: colorScheme.outlineVariant.withOpacity(0.4), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 25),
            Text(tr.select_language, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            const SizedBox(height: 20),
            BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, state) => Column(
                children: [
                  _buildLanguageOption(ctx, 'English', const Locale('en'), state.locale),
                  _buildLanguageOption(ctx, 'العربية', const Locale('ar'), state.locale),
                  _buildLanguageOption(ctx, 'Français', const Locale('fr'), state.locale),
                  _buildLanguageOption(ctx, 'Русский', const Locale('ru'), state.locale),
                  _buildLanguageOption(ctx, 'Türkçe', const Locale('tr'), state.locale),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String title, Locale locale, Locale currentLocale) {
    final isSelected = locale == currentLocale;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _onLanguageChanged(context, locale),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // استخدام لون الثيم الأساسي بشفافية خفيفة جداً بدلاً من البرتقالي
          color: isSelected ? colorScheme.primary.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? colorScheme.primary : colorScheme.onSurface)),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 20),
          ],
        ),
      ),
    );
  }

  void _onLanguageChanged(BuildContext context, Locale? value) {
    if (value != null) {
      context.read<LanguageCubit>().updateLanguage(value);
      Navigator.pop(context);
    }
  }
}

class UserProfileImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  const UserProfileImage({super.key, required this.imageUrl, this.size = 50.0});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: sl<AuthLocalDatasource>().getCachedToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return SizedBox(width: size, height: size);
        final token = snapshot.data;
        return ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: Image.network(
            imageUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
            headers: {'Authorization': 'Bearer ${token?.trim()}', 'Accept': 'application/json'},
            errorBuilder: (context, error, stackTrace) => Icon(Icons.person, color: Colors.grey.shade400, size: size * 0.6),
          ),
        );
      },
    );
  }
}

class _ThemeSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20)
      ),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Row(
            children: [
              _buildThemeToggle(context, 'Light', Icons.wb_sunny_rounded, state.themeMode == ThemeMode.light, ThemeMode.light),
              _buildThemeToggle(context, 'Dark', Icons.nightlight_round, state.themeMode == ThemeMode.dark, ThemeMode.dark),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, String title, IconData icon, bool isSelected, ThemeMode mode) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<ThemeCubit>().changeTheme(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.4), size: 18),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.4))),
            ],
          ),
        ),
      ),
    );
  }
}