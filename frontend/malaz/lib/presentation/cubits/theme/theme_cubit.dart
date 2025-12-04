import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState {
  final ThemeMode themeMode;
  ThemeState(this.themeMode);
}

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences prefs;

  static const String _themeKey = 'theme_mode';

  ThemeCubit(this.prefs) : super(ThemeState(ThemeMode.system)) {
    _loadTheme();
  }

  void _loadTheme() {
    final savedTheme = prefs.getString(_themeKey);
    if (savedTheme == 'dark') {
      emit(ThemeState(ThemeMode.dark));
    } else if (savedTheme == 'light') {
      emit(ThemeState(ThemeMode.light));
    } else {
      emit(ThemeState(ThemeMode.system));
    }
  }

  Future<void> changeTheme(ThemeMode mode) async {
    emit(ThemeState(mode));

    String modeStr = 'system';
    if (mode == ThemeMode.dark) modeStr = 'dark';
    if (mode == ThemeMode.light) modeStr = 'light';

    await prefs.setString(_themeKey, modeStr);
  }
}