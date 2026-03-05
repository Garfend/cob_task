import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../core/services/cache_service.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final CacheService _cacheService;

  ThemeCubit(this._cacheService) : super(const ThemeState()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedMode = _cacheService.getThemeMode();
    if (savedMode != null) {
      final themeMode = ThemeMode.values[savedMode];
      emit(ThemeState(themeMode: themeMode));
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    emit(ThemeState(themeMode: newMode));
    await _cacheService.saveThemeMode(newMode.index);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(ThemeState(themeMode: mode));
    await _cacheService.saveThemeMode(mode.index);
  }

  Future<void> setLightTheme() => setThemeMode(ThemeMode.light);

  Future<void> setDarkTheme() => setThemeMode(ThemeMode.dark);

  Future<void> setSystemTheme() => setThemeMode(ThemeMode.system);

  bool isDarkMode(BuildContext context) {
    if (state.themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return state.themeMode == ThemeMode.dark;
  }
}
