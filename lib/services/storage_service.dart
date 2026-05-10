import 'package:hive_flutter/hive_flutter.dart';
import '../models/station.dart';
import '../models/booking.dart';

/// @file storage_service.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Сервис для работы с локальным хранилищем данных.

/// @class StorageService
/// @brief Класс, управляющий персистентностью данных станций и бронирований.
/// 
/// Использует Hive для обеспечения кроссплатформенного хранения, 
/// включая поддержку Web и Offline-режима.
class StorageService {
  static const String _stationsBox = 'stations';
  static const String _bookingsBox = 'bookings';

  /// @brief Инициализация хранилищ Hive и наполнение первичными данными.
  /// [OFFLINE] Позволяет приложению работать без доступа к сети.
  Future<void> init() async {
    await Hive.openBox<Station>(_stationsBox);
    await Hive.openBox<Booking>(_bookingsBox);
    
    // Начальное наполнение базы, если она пуста
    if (Hive.box<Station>(_stationsBox).isEmpty) {
      await _seedData();
    }
  }

  /// @brief Приватный метод для генерации начального набора станций.
  Future<void> _seedData() async {
    final box = Hive.box<Station>(_stationsBox);
    final initialStations = [
      Station(id: 1, name: 'Центральная станция', latitude: 53.9006, longitude: 27.5590, totalBikes: 10, availableBikes: 5),
      Station(id: 2, name: 'Парк Победы', latitude: 53.9106, longitude: 27.5690, totalBikes: 8, availableBikes: 3),
      Station(id: 3, name: 'Университетская', latitude: 53.8906, longitude: 27.5490, totalBikes: 15, availableBikes: 12),
      Station(id: 4, name: 'Площадь Якуба Коласа', latitude: 53.9156, longitude: 27.5830, totalBikes: 12, availableBikes: 8),
      Station(id: 5, name: 'Национальная библиотека', latitude: 53.9314, longitude: 27.6461, totalBikes: 20, availableBikes: 18),
      Station(id: 6, name: 'Минск-Арена', latitude: 53.9360, longitude: 27.4815, totalBikes: 10, availableBikes: 4),
      Station(id: 7, name: 'ТЦ Замок', latitude: 53.9260, longitude: 27.5175, totalBikes: 6, availableBikes: 2),
      Station(id: 8, name: 'Вокзал', latitude: 53.8900, longitude: 27.5500, totalBikes: 15, availableBikes: 7),
    ];
    for (var s in initialStations) {
      await box.put(s.id, s);
    }
  }

  /// @brief Получение списка всех станций из локальной БД.
  /// @return Список объектов Station.
  List<Station> getAllStations() => Hive.box<Station>(_stationsBox).values.toList();
  
  /// @brief Получение только активных бронирований пользователя.
  /// @return Список объектов Booking.
  List<Booking> getActiveBookings() => Hive.box<Booking>(_bookingsBox).values.where((b) => b.isActive).toList();

  /// @brief Создание нового бронирования и обновление количества велосипедов на станции.
  /// 
  /// @param booking Модель бронирования для сохранения.
  Future<void> createBooking(Booking booking) async {
    final bookingsBox = Hive.box<Booking>(_bookingsBox);
    final stationsBox = Hive.box<Station>(_stationsBox);
    
    await bookingsBox.add(booking);
    
    final station = stationsBox.get(booking.stationId);
    if (station != null) {
      final newAvailable = station.availableBikes - booking.quantity;
      await stationsBox.put(station.id, Station(
        id: station.id,
        name: station.name,
        latitude: station.latitude,
        longitude: station.longitude,
        totalBikes: station.totalBikes,
        availableBikes: newAvailable < 0 ? 0 : newAvailable,
      ));
    }
  }

  /// @brief Завершение аренды и возврат велосипедов на станцию.
  /// 
  /// Обеспечивает защиту от превышения максимальной вместимости станции.
  /// 
  /// @param booking Объект бронирования, который нужно закрыть.
  Future<void> finishBooking(Booking booking) async {
    final stationsBox = Hive.box<Station>(_stationsBox);
    
    // Удаление записи о бронировании из Hive
    await booking.delete();

    final station = stationsBox.get(booking.stationId);
    if (station != null) {
      var newAvailable = station.availableBikes + booking.quantity;
      // [LOGIC] Защита от превышения вместимости (не более totalBikes)
      if (newAvailable > station.totalBikes) {
        newAvailable = station.totalBikes;
      }
      
      await stationsBox.put(station.id, Station(
        id: station.id,
        name: station.name,
        latitude: station.latitude,
        longitude: station.longitude,
        totalBikes: station.totalBikes,
        availableBikes: newAvailable,
      ));
    }
  }
}
