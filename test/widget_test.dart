import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:lab9_project4_narkevich/widgets/station_card.dart';
import 'package:lab9_project4_narkevich/models/station.dart';
import 'package:lab9_project4_narkevich/l10n/app_localizations.dart';
import 'package:lab9_project4_narkevich/screens/login_screen.dart';
import 'package:lab9_project4_narkevich/screens/settings_screen.dart';
import 'package:lab9_project4_narkevich/screens/bookings_screen.dart';
import 'package:lab9_project4_narkevich/providers/auth_provider.dart';
import 'package:lab9_project4_narkevich/providers/bike_provider.dart';

import 'unit_test.mocks.dart';

/// @file widget_test.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Тесты виджетов (UI-компонентов) приложения.

void main() {
  late MockAuthService mockAuth;
  late MockStorageService mockStorage;

  /// @brief Настройка моков сервисов перед запуском тестов виджетов.
  setUp(() {
    mockAuth = MockAuthService();
    mockStorage = MockStorageService();
    
    // Имитируем наличие зарегистрированных пользователей в системе
    when(mockAuth.hasUsers).thenReturn(true);
    // Имитируем пустые списки данных по умолчанию
    when(mockStorage.getAllStations()).thenReturn([]);
    when(mockStorage.getActiveBookings()).thenReturn([]);
  });

  /// @brief Вспомогательная функция для создания окружения виджета.
  /// Обеспечивает инъекцию моков через ProviderScope и настройку локализации.
  Widget createTestableWidget(Widget child) {
    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuth),
        storageServiceProvider.overrideWithValue(mockStorage),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }

  /// @brief Группа тестов для проверки отрисовки интерфейсных элементов.
  group('Widget Tests:', () {
    testWidgets('1. Отображение StationCard', (tester) async {
      final station = Station(id: 1, name: 'Central', latitude: 0, longitude: 0, totalBikes: 10, availableBikes: 5);
      await tester.pumpWidget(createTestableWidget(Scaffold(body: StationCard(station: station))));
      
      // Проверка наличия названия станции
      expect(find.text('Central'), findsOneWidget);
      // Проверка числовой информации о доступности
      expect(find.textContaining('5 / 10'), findsOneWidget);
    });

    testWidgets('2. Поля ввода на LoginScreen', (tester) async {
      await tester.pumpWidget(createTestableWidget(const LoginScreen()));
      // [ALL] Ожидание завершения первой отрисовки и инициализации провайдеров
      await tester.pump(); 
      
      // Проверка наличия двух текстовых полей (Email и Пароль)
      expect(find.byType(TextField), findsNWidgets(2));
      // Проверка наличия кнопки действия
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('3. Элементы на SettingsScreen', (tester) async {
      await tester.pumpWidget(createTestableWidget(const SettingsScreen()));
      // Проверка наличия иконок темы и языка
      expect(find.byIcon(Icons.palette), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);
    });

    testWidgets('4. Текст пустого состояния в BookingsScreen', (tester) async {
      await tester.pumpWidget(createTestableWidget(const BookingsScreen()));
      // В мок-окружении список бронирований пуст
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('5. Кнопка выхода на экране настроек', (tester) async {
      await tester.pumpWidget(createTestableWidget(const SettingsScreen()));
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });
  });
}
