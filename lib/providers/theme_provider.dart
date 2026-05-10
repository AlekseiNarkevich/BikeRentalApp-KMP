import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// @file theme_provider.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Управление темой оформления приложения (светлая, темная, системная).

/// @class ThemeNotifier
/// @brief Контроллер для переключения цветовых схем приложения.
/// 
/// Сохраняет выбор пользователя в SharedPreferences для восстановления при перезапуске.
class ThemeNotifier extends StateNotifier<ThemeMode> {
  /// @brief Инициализация контроллера и загрузка сохраненных настроек.
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  /// @brief Приватный метод для загрузки индекса темы из памяти устройства.
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('theme_mode');
    if (themeIndex != null) {
      state = ThemeMode.values[themeIndex];
    }
  }

  /// @brief Установка новой темы приложения.
  /// @param mode Режим темы (light, dark или system).
  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
  }
}

/// @brief Глобальный провайдер для управления темой оформления.
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
