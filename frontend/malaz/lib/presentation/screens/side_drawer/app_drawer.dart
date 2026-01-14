import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/color/app_color.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/language/language_cubit.dart';
import '../../cubits/location/location_cubit.dart';
import '../../cubits/theme/theme_cubit.dart';
import '../../global_widgets/glowing_key/build_glowing_key.dart';
import '../../global_widgets/user_profile_image/user_profile_image.dart';

enum ThemeOption { light, dark, system }

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    super.initState();

    context.read<LocationCubit>().loadSavedLocation();
  }

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
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
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
                      _buildDrawerItem(context, Icons.settings_outlined, tr.settings,(){}),
                    ],
                  ),
                ),
              ),
              _buildLogoutButton(context, colorScheme, tr),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, AppLocalizations tr, ColorScheme colorScheme, bool isDark) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String name = 'Guest User';
        String firstName = '';
        String lastName = '';
        String? img;
        int? userId;
        if (state is !AuthAuthenticated) {
          return const SizedBox(height: 100);
        }

        name = "${state.user.first_name} ${state.user.last_name}";
        img = state.user.profile_image_url;
        userId = state.user.id;
        firstName = state.user.first_name;
        lastName = state.user.last_name;

        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.premiumGoldGradient2,
            borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(50)),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))
            ],
          ),
          child: Stack(
            children: [
              PositionedDirectional(
                end: -40,
                top: 0,
                child: BuildGlowingKey(size: 180,opacity:  0.15,rotation: -0.3),
              ),

              PositionedDirectional(
                top: -30,
                start: -20,
                child: BuildGlowingKey(size: 110,opacity:  0.12,rotation:  0.5),
              ),

              PositionedDirectional(
                bottom: 0,
                end: 50,
                child: BuildGlowingKey(size: 90,opacity:  0.1,rotation:  0.8),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 70, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildModernAvatar(userId, colorScheme, isDark, firstName, lastName),
                    const SizedBox(height: 25),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 4))],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDrawerLocation(context, colorScheme, tr),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerLocation(BuildContext context, ColorScheme colorScheme, AppLocalizations tr) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        String address = tr.unknown_location;
        bool isLoading = state is LocationLoading;

        if (state is LocationLoading) {
          address = '...';
        }

        if (state is LocationLoaded) {
          address = state.location.address;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              else
                PulsingLocationIcon(color: Colors.white),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernAvatar(int? userId, ColorScheme colorScheme, bool isDark, String firstName, String lastName) {
    return UserProfileImage(
              userId: userId ?? 0,
              firstName: firstName,
              lastName: lastName,
              radius: 42,
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
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.error.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: colorScheme.error.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(Icons.logout_rounded, color: colorScheme.error, size: 20),
        ),
        title: Text(
          tr.logout,
          style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.w800, fontSize: 15),
        ),
        onTap: () async {
          Navigator.pop(context);

          await Future.delayed(const Duration(milliseconds: 210));

          if (context.mounted) {
            context.read<LocationCubit>().clearLocation();
            context.read<AuthCubit>().logout();
          }
        },
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
          color: Theme.of(ctx).scaffoldBackgroundColor,
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
          color: isSelected ? colorScheme.primary.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? colorScheme.primary : colorScheme.onSurface)),
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

class PulsingLocationIcon extends StatefulWidget {
  final Color color;
  const PulsingLocationIcon({super.key, required this.color});

  @override
  State<PulsingLocationIcon> createState() => _PulsingLocationIconState();
}

class _PulsingLocationIconState extends State<PulsingLocationIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Icon(Icons.location_on_rounded, color: widget.color, size: 14),
    );
  }
}