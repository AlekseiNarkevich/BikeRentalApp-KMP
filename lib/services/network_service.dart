import 'package:dio/dio.dart';
import '../models/station.dart';

/// @file network_service.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Сервис для сетевого взаимодействия с API.

/// @class NetworkService
/// @brief Класс, инкапсулирующий логику HTTP-запросов через библиотеку Dio.
class NetworkService {
  /// Экземпляр клиента Dio для выполнения запросов.
  final Dio _dio;

  /// @brief Конструктор сервиса.
  /// @param _dio Переданный экземпляр клиента (инъекция зависимости).
  NetworkService(this._dio);

  /// @brief Получение актуального списка станций с удаленного сервера.
  /// 
  /// [API] Выполняет GET-запрос. В случае неудачи возвращает пустой список,
  /// что позволяет приложению бесшовно переключиться на кешированные данные Hive.
  /// 
  /// @return Список объектов Station, полученных из JSON.
  Future<List<Station>> getStations() async {
    try {
      final response = await _dio.get('https://api.example.com/stations');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Station.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      // Исключение перехватывается для поддержки Offline-режима
      return [];
    }
  }
}
