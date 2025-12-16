import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ===========================
/// ----------[states]---------
/// ===========================

/// [SettingsCubit] & [SettingsState]
/// not in work currently the whole code here is nothing but scribble
/// If you are about to fix this screen you can delete everything below
class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('en'),
  });

  @override
  List<Object> get props => [themeMode, locale];

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

/// ===========================
/// ----------[cubit]----------
/// ===========================

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _prefs;

  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language_code';

  SettingsCubit(this._prefs) : super(const SettingsState()) {
    loadSettings();
  }

  void loadSettings() {
    final themeModeString = _prefs.getString(_themeKey);
    ThemeMode themeMode;
    if (themeModeString == 'light') {
      themeMode = ThemeMode.light;
    } else if (themeModeString == 'dark') {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.system;
    }

    final languageCode = _prefs.getString(_languageKey) ?? 'ar';

    emit(SettingsState(themeMode: themeMode, locale: Locale(languageCode)));
  }

  void updateThemeMode(ThemeMode newThemeMode) {
    _prefs.setString(_themeKey, newThemeMode.name);

    emit(state.copyWith(themeMode: newThemeMode));
  }

  void updateLanguage(Locale newLocale) {
    _prefs.setString(_languageKey, newLocale.languageCode);

    emit(state.copyWith(locale: newLocale));
  }
}
