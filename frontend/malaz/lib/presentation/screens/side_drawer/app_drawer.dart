import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/color/app_color.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/language/language_cubit.dart';
import '../../cubits/theme/theme_cubit.dart';

enum ThemeOption { light, dark, system }

/// [AppDrawer]
/// a huge mass here it needs to be cleaned up :(
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final tr = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/login');
        }
      },
      child: Drawer(
            backgroundColor: theme.scaffoldBackgroundColor,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: AppColors.realGoldGradient
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: const CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&fit=crop'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'John Doe',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'john.doe@email.com',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8), fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: [
                      _buildDrawerItem(context, Icons.person_outline, tr.my_profile, () {
                        //Navigator.pop(context);
                        context.push('/profile');
                      }),
                      _buildDrawerItem(context, Icons.palette_outlined, tr.theme, () {
                        Navigator.pop(context);
                        _showThemeBottomSheet(context);
                      }),
                      _buildDrawerItem(context, Icons.language, tr.language, () {
                        Navigator.pop(context);
                        _showLanguageBottomSheet(context);
                      }),
                      const Divider(),
                      _buildDrawerItem(context, Icons.apartment, tr.become_a_renter,
                              () {}), // ?
                      _buildDrawerItem(context, Icons.settings_outlined, tr.settings,
                              () {
                            context.push('/settings');
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.logout, color: colorScheme.error),
                      title: Text(tr.logout,
                          style: TextStyle(
                              color: colorScheme.error, fontWeight: FontWeight.bold)),
                      onTap: () {
                        context.read<AuthCubit>().logout();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr.select_theme,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  _ThemeSwitcher(currentThemeMode: state.themeMode),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(tr.select_language,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        RadioListTile<Locale>(
                          title: const Text('English'),
                          value: const Locale('en'),
                          groupValue: state.locale,
                          onChanged: (value) => _onLanguageChanged(ctx, value),
                        ),
                        RadioListTile<Locale>(
                          title: const Text('العربية'),
                          value: const Locale('ar'),
                          groupValue: state.locale,
                          onChanged: (value) => _onLanguageChanged(ctx, value),
                        ),
                        RadioListTile<Locale>(
                          title: const Text('Français'),
                          value: const Locale('fr'),
                          groupValue: state.locale,
                          onChanged: (value) => _onLanguageChanged(ctx, value),
                        ),
                        RadioListTile<Locale>(
                          title: const Text('Русский'),
                          value: const Locale('ru'),
                          groupValue: state.locale,
                          onChanged: (value) => _onLanguageChanged(ctx, value),
                        ),
                        RadioListTile<Locale>(
                          title: const Text('Türkçe'),
                          value: const Locale('tr'),
                          groupValue: state.locale,
                          onChanged: (value) => _onLanguageChanged(ctx, value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onLanguageChanged(BuildContext context, Locale? value) {
    if (value != null) {
      context.read<LanguageCubit>().updateLanguage(value);
      Navigator.pop(context);
    }
  }
}

// ... (theme switcher widgets remain the same)
class _ThemeSwitcher extends StatelessWidget {
  final ThemeMode currentThemeMode;
  const _ThemeSwitcher({required this.currentThemeMode});

  ThemeOption _getOptionForThemeMode(ThemeMode mode) {
    if (mode == ThemeMode.light) return ThemeOption.light;
    if (mode == ThemeMode.dark) return ThemeOption.dark;
    return ThemeOption.system;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color:
            isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _ThemeOption(
            option: ThemeOption.light,
            currentOption: _getOptionForThemeMode(currentThemeMode),
            title: 'Light',
            icon: Icons.wb_sunny_rounded,
          ),
          const SizedBox(width: 4),
          _ThemeOption(
            option: ThemeOption.dark,
            currentOption: _getOptionForThemeMode(currentThemeMode),
            title: 'Dark',
            icon: Icons.nightlight_round,
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final ThemeOption option;
  final ThemeOption currentOption;
  final String title;
  final IconData icon;

  const _ThemeOption({
    required this.option,
    required this.currentOption,
    required this.title,
    required this.icon,
  });

  ThemeMode _getThemeModeForOption(ThemeOption option) {
    if (option == ThemeOption.light) return ThemeMode.light;
    if (option == ThemeOption.dark) return ThemeMode.dark;
    return ThemeMode.system;
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = option == currentOption;
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          final newThemeMode = _getThemeModeForOption(option);
          context.read<ThemeCubit>().changeTheme(newThemeMode);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.6),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? colorScheme.onSurface
                      : colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
