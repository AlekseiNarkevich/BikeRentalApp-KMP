import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'station.g.dart';

/// @file station.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Модель данных для станции велопроката.

/// @class Station
/// @brief Класс, представляющий информацию о станции велопроката.
/// 
/// Содержит географические координаты, название и информацию о наличии
/// велосипедов на конкретной точке. Поддерживает локальное хранение в Hive.
@JsonSerializable()
@HiveType(typeId: 0)
class Station extends HiveObject {
  /// @brief Уникальный идентификатор станции.
  @HiveField(0)
  final int? id;

  /// @brief Человекочитаемое название станции.
  @HiveField(1)
  final String name;

  /// @brief Широта географического расположения станции.
  @HiveField(2)
  final double latitude;

  /// @brief Долгота географического расположения станции.
  @HiveField(3)
  final double longitude;

  /// @brief Общее количество велосипедов на станции.
  /// Максимальная вместимость парковочных мест станции.
  @HiveField(4)
  @JsonKey(name: 'total_bikes')
  final int totalBikes;

  /// @brief Текущее количество доступных для аренды велосипедов.
  /// Значение меняется динамически при бронировании или возврате.
  @HiveField(5)
  @JsonKey(name: 'available_bikes')
  final int availableBikes;

  /// @brief Конструктор для создания объекта станции.
  /// 
  /// @param id Уникальный ключ.
  /// @param name Название.
  /// @param latitude Широта.
  /// @param longitude Долгота.
  /// @param totalBikes Общий парк.
  /// @param availableBikes Свободные единицы.
  Station({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.totalBikes,
    required this.availableBikes,
  });

  /// @brief Фабричный метод для десериализации объекта из JSON.
  /// 
  /// @param json Карта данных.
  /// @return Экземпляр станции.
  factory Station.fromJson(Map<String, dynamic> json) => _$StationFromJson(json);

  /// @brief Метод для сериализации объекта в JSON.
  /// 
  /// @return Карта данных объекта.
  Map<String, dynamic> toJson() => _$StationToJson(this);
}
