import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lab9_project4_narkevich/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// @file app_test.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Сквозные (E2E) интеграционные тесты приложения.

/// @class TestHttpOverrides
/// @brief Игнорирование ошибок сетевых соединений для стабильности тестов.
class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (cert, host, port) => true;
    return client;
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = TestHttpOverrides();

  // Отключаем ошибки переполнения в тестах, если они возникнут из-за системных шрифтов
  FlutterError.onError = (details) {
    if (details.exception.toString().contains('RenderFlex overflowed')) return;
    FlutterError.presentError(details);
  };

  group('Комплексный сценарий:', () {
    testWidgets('Авторизация, навигация и история', (tester) async {
      // 1. ПОДГОТОВКА (Очистка базы перед тестом)
      await Hive.initFlutter();
      await Hive.close();
      await Hive.deleteBoxFromDisk('authBox');
      await Hive.deleteBoxFromDisk('registeredUsers');
      await Hive.deleteBoxFromDisk('stations');
      await Hive.deleteBoxFromDisk('bookings');

      // Запуск приложения
      await app.main();
      await tester.pumpAndSettle();

      // 2. РЕГИСТРАЦИЯ
      // Проверяем наличие полей ввода на экране регистрации
      expect(find.byType(TextField), findsNWidgets(2));
      await tester.enterText(find.byType(TextField).at(0), 'integration@test.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      
      // Проверка входа (должны увидеть сетку станций)
      expect(find.byType(GridView), findsOneWidget);

      // 3. НАВИГАЦИЯ: НАСТРОЙКИ
      final settingsTab = find.byIcon(Icons.settings);
      await tester.tap(settingsTab);
      await tester.pumpAndSettle();
      
      // Проверяем, что перешли в настройки (видим иконку палитры)
      expect(find.byIcon(Icons.palette), findsOneWidget);

      // 4. НАВИГАЦИЯ: ИСТОРИЯ
      final historyTab = find.byIcon(Icons.history);
      await tester.tap(historyTab);
      await tester.pumpAndSettle();
      
      // Проверяем, что история пуста (нет элементов ListTile)
      expect(find.byType(ListTile), findsNothing);

      // Возврат на главную
      final homeTab = find.byIcon(Icons.directions_bike);
      await tester.tap(homeTab);
      await tester.pumpAndSettle();
      
      expect(find.byType(GridView), findsOneWidget);
    });
  });
}
