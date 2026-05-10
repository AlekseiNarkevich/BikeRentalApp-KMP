import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking.g.dart';

/// @file booking.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Модель данных для бронирования велосипеда.

/// @class Booking
/// @brief Класс, представляющий информацию о бронировании.
/// 
/// Данный класс используется как для хранения в локальной базе данных Hive,
/// так и для передачи через сетевые запросы в формате JSON.
@JsonSerializable()
@HiveType(typeId: 1)
class Booking extends HiveObject {
  /// @brief Уникальный идентификатор бронирования.
  @HiveField(0)
  final int? id;

  /// @brief Идентификатор станции.
  /// Связывает бронирование с конкретной станцией велопроката.
  @HiveField(1)
  @JsonKey(name: 'station_id')
  final int stationId;

  /// @brief Время начала бронирования.
  /// Используется для отслеживания длительности аренды.
  @HiveField(2)
  @JsonKey(name: 'start_time')
  final DateTime startTime;

  /// @brief Статус бронирования.
  /// true - если аренда активна, false - если завершена.
  @HiveField(3)
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// @brief Количество забронированных велосипедов.
  /// Позволяет арендовать несколько единиц за один раз.
  @HiveField(4)
  final int quantity;

  /// @brief Конструктор для создания объекта бронирования.
  /// 
  /// @param id Уникальный идентификатор (может быть null для новых записей).
  /// @param stationId ID станции проката.
  /// @param startTime Метка времени начала аренды.
  /// @param isActive Текущее состояние аренды (по умолчанию true).
  /// @param quantity Число велосипедов (по умолчанию 1).
  Booking({
    this.id,
    required this.stationId,
    required this.startTime,
    this.isActive = true,
    this.quantity = 1,
  });

  /// @brief Фабричный метод для создания объекта из JSON-карты.
  /// 
  /// @param json Карта данных, полученная от API или из локального хранилища.
  /// @return Новый экземпляр класса Booking.
  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

  /// @brief Метод для преобразования объекта в JSON-карту.
  /// 
  /// @return Карта данных объекта для сериализации.
  Map<String, dynamic> toJson() => _$BookingToJson(this);
}
