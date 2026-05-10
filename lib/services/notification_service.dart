import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// @file notification_service.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Сервис для отображения системных уведомлений пользователю.

/// @class NotificationService
/// @brief Класс, инкапсулирующий логику показа всплывающих сообщений (Toast) на разных платформах.
class NotificationService {
  /// @brief Отображение уведомления в зависимости от текущей платформы.
  /// 
  /// @param message Текст уведомления для показа.
  /// 
  /// [ALL] Реализовано разное поведение для разных окружений:
  /// - [TEST]: Вывод в консоль для стабильности тестов.
  /// - [WEB/LINUX]: Использование Fluttertoast.
  /// - [ANDROID/IOS]: Использование Fluttertoast + дублирование в Debug консоль.
  static void showNotification(String message) {
    // [TEST] Проверка окружения для подавления нативных вызовов в тестах
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      debugPrint('TEST NOTIFICATION: $message');
      return;
    }

    if (kIsWeb || defaultTargetPlatform == TargetPlatform.linux) {
      // [WEB/LINUX] Toast-уведомление для настольных систем
      Fluttertoast.showToast(msg: message);
    } else {
      // [MOBILE] Стандартный Toast для Android и iOS
      debugPrint('PUSH NOTIFICATION: $message');
      Fluttertoast.showToast(msg: message);
    }
  }
}
