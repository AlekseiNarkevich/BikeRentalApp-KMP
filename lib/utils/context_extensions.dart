import 'package:flutter/material.dart';

/// @file context_extensions.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Расширения для BuildContext для поддержки адаптивной верстки.

/// @class ResponsiveContext
/// @brief Набор вспомогательных геттеров и методов для работы с размерами экрана.
/// 
/// [ADAPTIVE] Позволяет избегать жестко заданных размеров (пикселей),
/// используя относительные единицы измерения.
extension ResponsiveContext on BuildContext {
  /// @brief Текущая ширина экрана.
  double get screenWidth => MediaQuery.sizeOf(this).width;
  
  /// @brief Текущая высота экрана.
  double get screenHeight => MediaQuery.sizeOf(this).height;
  
  /// @brief Проверка, является ли устройство мобильным.
  bool get isMobile => screenWidth < 600;
  
  /// @brief Проверка, является ли устройство планшетом.
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  
  /// @brief Проверка, является ли устройство настольным ПК.
  bool get isDesktop => screenWidth >= 1200;

  /// @brief Получение ширины в процентах от экрана.
  /// @param percent Доля от 0.0 до 1.0.
  double percentWidth(double percent) => screenWidth * percent;
  
  /// @brief Получение высоты в процентах от экрана.
  /// @param percent Доля от 0.0 до 1.0.
  double percentHeight(double percent) => screenHeight * percent;
}
