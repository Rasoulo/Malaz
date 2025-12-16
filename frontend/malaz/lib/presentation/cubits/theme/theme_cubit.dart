import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';

/// ===========================
/// ----------[states]---------
/// ===========================

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

/// ===========================
/// ----------[cubit]----------
/// ===========================

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(const ThemeState(ThemeMode.system)) {
    _loadTheme();
  }

  void _loadTheme() {
    final savedTheme = _prefs.getString(AppConstants.themeKey);

    if (savedTheme == 'dark') {
      emit(const ThemeState(ThemeMode.dark));
    } else if (savedTheme == 'light') {
      emit(const ThemeState(ThemeMode.light));
    } else {
      emit(const ThemeState(ThemeMode.system));
    }
  }

  Future<void> changeTheme(ThemeMode mode) async {
    if (state.themeMode == mode) return;

    String modeStr = 'system';
    if (mode == ThemeMode.dark) modeStr = 'dark';
    if (mode == ThemeMode.light) modeStr = 'light';

    await _prefs.setString(AppConstants.themeKey, modeStr);
    emit(ThemeState(mode));
  }
}