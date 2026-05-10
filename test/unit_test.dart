import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab9_project4_narkevich/providers/bike_provider.dart';
import 'package:lab9_project4_narkevich/services/storage_service.dart';
import 'package:lab9_project4_narkevich/models/station.dart';
import 'package:lab9_project4_narkevich/models/booking.dart';
import 'package:lab9_project4_narkevich/models/user.dart';
import 'package:lab9_project4_narkevich/services/auth_service.dart';

/// @file unit_test.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Модульные тесты для проверки бизнес-логики и моделей данных.

@GenerateMocks([StorageService, AuthService])
import 'unit_test.mocks.dart';

/// @brief Точка входа для запуска модульных тестов.
void main() {
  /// [ALL] Инициализация тестового окружения для поддержки плагинов (SharedPrefs).
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late MockStorageService mockStorage;
  late BikeNotifier bikeNotifier;

  /// @brief Настройка окружения перед каждым тестом.
  setUp(() {
    // Сброс мока настроек в чистое состояние
    SharedPreferences.setMockInitialValues({});
    mockStorage = MockStorageService();
    bikeNotifier = BikeNotifier(mockStorage);
  });

  /// @brief Группа тестов для контроллера BikeNotifier.
  group('Логика BikeNotifier:', () {
    test('1. Начальное состояние пустое', () {
      expect(bikeNotifier.state.stations, isEmpty);
      expect(bikeNotifier.state.isLoading, isFalse);
    });

    test('2. Загрузка станций обновляет состояние', () async {
      final stations = [
        Station(id: 1, name: 'S1', latitude: 0, longitude: 0, totalBikes: 10, availableBikes: 5)
      ];
      // Настройка поведения мока хранилища
      when(mockStorage.getAllStations()).thenReturn(stations);
      when(mockStorage.getActiveBookings()).thenReturn([]);

      await bikeNotifier.loadData();

      expect(bikeNotifier.state.stations.length, 1);
      expect(bikeNotifier.state.stations[0].name, 'S1');
    });

    test('3. Бронирование вызывает метод в StorageService', () async {
      await bikeNotifier.bookBike(1, 1, 'Success');
      // Проверка, что метод сервиса был вызван ровно один раз
      verify(mockStorage.createBooking(any)).called(1);
    });

    test('4. Завершение аренды вызывает finishBooking', () async {
      final booking = Booking(id: 1, stationId: 1, startTime: DateTime.now());
      await bikeNotifier.completeRental(booking);
      // Проверка взаимодействия с сервисом при закрытии аренды
      verify(mockStorage.finishBooking(booking)).called(1);
    });
  });

  /// @brief Группа тестов для проверки корректности работы моделей данных.
  group('Тесты моделей данных:', () {
    test('5. Сериализация Station в JSON и обратно', () {
      final station = Station(id: 1, name: 'Park', latitude: 53.9, longitude: 27.5, totalBikes: 8, availableBikes: 3);
      final json = station.toJson();
      expect(json['name'], 'Park');
      
      final fromJson = Station.fromJson(json);
      expect(fromJson.name, 'Park');
    });

    test('6. Поля модели User', () {
      final user = User(email: 'test@mail.ru', token: 'xyz');
      expect(user.email, 'test@mail.ru');
    });

    test('7. Корректность создания Booking', () {
      final time = DateTime.now();
      final booking = Booking(stationId: 1, startTime: time, quantity: 5);
      expect(booking.quantity, 5);
      expect(booking.startTime, time);
    });
  });
}
