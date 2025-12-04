
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/settings/settings_cubit.dart';

enum ThemeOption { light, dark, system }

/// [SettingsScreen]
/// It's not in work currently the whole code here is nothing but scribble
/// If you are about to fix this screen you can delete everything below
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _BuildAppearanceTitleSection(),
                const SizedBox(height: 16),
                _ThemeSwitcher(currentThemeMode: state.themeMode),
                const SizedBox(height: 32),
                const _BuildLanguageTitleSection(),
                const SizedBox(height: 16),
                _LanguageSelector(currentLocale: state.locale),
              ],
            );
          },
        ),
      ),
    );
  }
}

// --- Widgets Building The Screen ---

class _BuildAppearanceTitleSection extends StatelessWidget {
  const _BuildAppearanceTitleSection();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Appearance',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), // A less prominent color
      ),
    );
  }
}

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
        color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey.shade200,
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
          context.read<SettingsCubit>().updateThemeMode(newThemeMode);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.6),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildLanguageTitleSection extends StatelessWidget {
  const _BuildLanguageTitleSection();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Language',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  const _LanguageSelector({required this.currentLocale});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        leading: Icon(Icons.language_rounded, color: colorScheme.primary),
        title: Text('Language', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentLocale.languageCode.toUpperCase(),
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colorScheme.onSurface.withOpacity(0.6)),
          ],
        ),
        onTap: () {
          final newLocale = currentLocale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
          context.read<SettingsCubit>().updateLanguage(newLocale);
        },
      ),
    );
  }
}
