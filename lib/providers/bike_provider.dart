import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/station.dart';
import '../models/booking.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

/// @file bike_provider.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Управление состоянием станций и процессами бронирования.

/// @class BikeState
/// @brief Неизменяемый объект состояния для BikeNotifier.
/// 
/// Содержит списки станций, активных бронирований и статистическую информацию.
class BikeState {
  /// @brief Список всех доступных станций велопроката.
  final List<Station> stations;
  /// @brief Список активных на текущий момент аренд.
  final List<Booking> activeBookings;
  /// @brief Флаг процесса загрузки данных.
  final bool isLoading;
  /// @brief Общее количество совершенных аренд за все время (хранится в SharedPreferences).
  final int totalRentsCount;

  BikeState({
    this.stations = const [],
    this.activeBookings = const [],
    this.isLoading = false,
    this.totalRentsCount = 0,
  });

  /// @brief Метод для создания копии состояния с измененными полями.
  BikeState copyWith({
    List<Station>? stations,
    List<Booking>? activeBookings,
    bool? isLoading,
    int? totalRentsCount,
  }) {
    return BikeState(
      stations: stations ?? this.stations,
      activeBookings: activeBookings ?? this.activeBookings,
      isLoading: isLoading ?? this.isLoading,
      totalRentsCount: totalRentsCount ?? this.totalRentsCount,
    );
  }
}

/// @class BikeNotifier
/// @brief Контроллер для работы с бизнес-логикой велопроката.
/// 
/// Обрабатывает загрузку данных, создание бронирований и их завершение.
class BikeNotifier extends StateNotifier<BikeState> {
  final StorageService _storageService;

  /// @brief Конструктор контроллера.
  /// @param _storageService Сервис локального хранилища данных.
  BikeNotifier(this._storageService) : super(BikeState());

  /// @brief Загрузка актуальных данных из хранилища и настроек.
  /// Обновляет списки станций и количество поездок.
  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final stations = _storageService.getAllStations();
      final bookings = _storageService.getActiveBookings();
      
      final prefs = await SharedPreferences.getInstance();
      final count = prefs.getInt('total_rents_count') ?? 0;

      state = state.copyWith(
        stations: stations,
        activeBookings: bookings,
        totalRentsCount: count,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// @brief Создание нового бронирования.
  /// 
  /// [WEB] Использует оптимистичное обновление состояния для мгновенной реакции UI,
  /// не дожидаясь завершения асинхронных операций в IndexedDB.
  /// 
  /// @param stationId ID выбранной станции.
  /// @param quantity Количество бронируемых велосипедов.
  /// @param message Текст уведомления для отображения.
  Future<void> bookBike(int stationId, int quantity, String message) async {
    final newBooking = Booking(
      stationId: stationId,
      startTime: DateTime.now(),
      quantity: quantity,
    );

    // 1. Асинхронное сохранение в локальную БД Hive
    await _storageService.createBooking(newBooking);
    
    // 2. Обновление общего счетчика поездок в настройках
    final prefs = await SharedPreferences.getInstance();
    final newTotalCount = state.totalRentsCount + quantity;
    await prefs.setInt('total_rents_count', newTotalCount);

    // 3. [OPT] Оптимистичное обновление памяти приложения для исключения задержек в UI
    final updatedStations = state.stations.map((s) {
      if (s.id == stationId) {
        return Station(
          id: s.id,
          name: s.name,
          latitude: s.latitude,
          longitude: s.longitude,
          totalBikes: s.totalBikes,
          availableBikes: s.availableBikes - quantity,
        );
      }
      return s;
    }).toList();

    state = state.copyWith(
      stations: updatedStations,
      activeBookings: [...state.activeBookings, newBooking],
      totalRentsCount: newTotalCount,
    );

    // 4. Показ системного уведомления
    NotificationService.showNotification(message);
    
    // Фоновая синхронизация данных с базой
    Future.microtask(() => loadData());
  }

  /// @brief Завершение активной аренды.
  /// @param booking Объект бронирования для закрытия.
  Future<void> completeRental(Booking booking) async {
    await _storageService.finishBooking(booking);
    await loadData();
  }
}

/// @brief Провайдер доступа к сервису хранилища.
final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

/// @brief Глобальный провайдер состояния бизнес-логики приложения.
final bikeProvider = StateNotifierProvider<BikeNotifier, BikeState>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return BikeNotifier(storage);
});
