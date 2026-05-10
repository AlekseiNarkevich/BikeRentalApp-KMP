import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// @file locale_provider.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Управление локализацией приложения (динамическая смена языков).

/// @class LocaleNotifier
/// @brief Контроллер для смены языка интерфейса.
/// 
/// Обеспечивает мгновенное обновление текстов во всем приложении без перезагрузки.
class LocaleNotifier extends StateNotifier<Locale> {
  /// @brief Инициализация контроллера (по умолчанию русский язык).
  LocaleNotifier() : super(const Locale('ru')) {
    _loadLocale();
  }

  /// @brief Загрузка кода языка из памяти устройства (SharedPreferences).
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }

  /// @brief Смена текущей локали приложения.
  /// @param locale Объект новой локали (например, Locale('en')).
  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }
}

/// @brief Глобальный провайдер локализации.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
