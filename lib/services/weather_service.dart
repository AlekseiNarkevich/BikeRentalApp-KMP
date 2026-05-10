import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// @file weather_service.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Сервис для получения актуальной погоды через внешнее API.

/// @class WeatherResult
/// @brief Простой контейнер для хранения данных о погоде (температура и иконка).
class WeatherResult {
  /// @brief Температура в формате строки (например, "21.5°C").
  final String temp;

  /// @brief Иконка Material Design, соответствующая состоянию неба.
  final IconData icon;

  WeatherResult({required this.temp, required this.icon});
}

/// @class WeatherService
/// @brief Класс для взаимодействия с OpenWeatherMap API.
class WeatherService {
  /// Экземпляр Dio для совершения HTTP-звонков.
  final Dio _dio = Dio();
  /// Уникальный ключ доступа к API OpenWeatherMap.
  static const String _apiKey = 'c1175509d3e979fd3cfc6bd953ec5bdb';
  /// Базовый URL для получения текущей погоды.
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  /// @brief Получение данных о погоде для заданных географических координат.
  /// 
  /// [API] Выполняет GET-запрос. В случае ошибок сети или API возвращает 
  /// объект по умолчанию со значениями "--°C".
  /// 
  /// @param lat Широта местности.
  /// @param lon Долгота местности.
  /// @return [Future] с результатом [WeatherResult] - асинхронный результат запроса.
  Future<WeatherResult> getWeather(double lat, double lon) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': _apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final temp = '${data['main']['temp'].toStringAsFixed(1)}°C';
        final condition = data['weather'][0]['main'].toString().toLowerCase();
        
        return WeatherResult(
          temp: temp,
          icon: _mapConditionToIcon(condition),
        );
      }
    } catch (e) {
      debugPrint('Ошибка при получении погоды: $e');
    }
    return WeatherResult(temp: '--°C', icon: Icons.cloud_off);
  }

  /// @brief Приватный вспомогательный метод для выбора подходящей иконки.
  /// 
  /// @param condition Строковое описание погоды от сервера.
  /// @return Объект IconData для отображения в UI.
  IconData _mapConditionToIcon(String condition) {
    if (condition.contains('cloud')) return Icons.cloud_outlined;
    if (condition.contains('rain')) return Icons.umbrella_outlined;
    if (condition.contains('snow')) return Icons.ac_unit_outlined;
    if (condition.contains('clear')) return Icons.wb_sunny_outlined;
    if (condition.contains('thunder')) return Icons.thunderstorm_outlined;
    return Icons.wb_cloudy_outlined;
  }
}
