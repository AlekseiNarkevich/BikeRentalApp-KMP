import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'l10n/app_localizations.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'router/app_router.dart';
import 'models/station.dart';
import 'models/booking.dart';
import 'models/user.dart';
import 'services/auth_service.dart';
import 'services/storage_service.dart';
import 'providers/bike_provider.dart';
import 'providers/auth_provider.dart';

/// @file main.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Точка входа в кроссплатформенное приложение "Велопрокат".

/// @class LogoutIntent
/// @brief Действие для выхода из приложения.
/// [DESKTOP] Используется в системе Shortcuts для обработки горячих клавиш.
class LogoutIntent extends Intent {
  const LogoutIntent();
}

///
/// @brief Главная функция запуска приложения.
///
/// Выполняет асинхронную инициализацию всех систем:
/// 1. Инициализация Flutter Binding.
/// 2. Настройка базы данных Hive и регистрация адаптеров.
/// 3. Инициализация сервисов авторизации и хранилища.
/// 4. Прогрев сетевого кеша карты.
///
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Hive и адаптеров моделей
  await Hive.initFlutter();
  _registerHiveAdapters();

  // Инициализация сервисов
  final authService = AuthService();
  await authService.init();
  
  final storageService = StorageService();
  await storageService.init();

  // [OPT] Предварительная загрузка тайлов карты (прогрев кеша)
  _precacheMapTiles();

  runApp(
    ProviderScope(
      overrides: [
        // Инъекция инициализированных экземпляров сервисов
        authServiceProvider.overrideWithValue(authService),
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const MyApp(),
    ),
  );
}

/// @brief Регистрация адаптеров Hive с проверкой.
/// Предотвращает ошибки повторной регистрации при горячем перезапуске или в тестах.
void _registerHiveAdapters() {
  try {
    Hive.registerAdapter(StationAdapter());
    Hive.registerAdapter(BookingAdapter());
    Hive.registerAdapter(UserAdapter());
  } catch (_) {
    // Адаптеры уже были зарегистрированы ранее
  }
}

/// @brief Метод для фонового прогрева кеша изображений карты.
/// Загружает центральный тайл Минска в сетевой кеш.
void _precacheMapTiles() {
  const String urlBase = 'https://tile.openstreetmap.org/13/4722/2822.png';
  final ImageProvider tileImage = NetworkImage(urlBase);
  tileImage.evict();
}

/// @class MyApp
/// @brief Корневой виджет приложения.
/// 
/// Настраивает:
/// - Систему навигации (GoRouter).
/// - Локализацию (localeProvider).
/// - Темы оформления (themeProvider).
/// - [DESKTOP] Горячие клавиши (Shortcuts).
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Подписка на глобальные состояния оформления и языка
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final router = ref.watch(routerProvider);

    /// [DESKTOP] Обертка для поддержки клавиатурных сокращений.
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyQ): const LogoutIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          LogoutIntent: CallbackAction<LogoutIntent>(
            onInvoke: (LogoutIntent intent) => ref.read(authProvider.notifier).logout(),
          ),
        },
        child: MaterialApp.router(
          title: 'Bike Sharing',
          debugShowCheckedModeBanner: false,
          
          // Конфигурация локализации
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          
          // Конфигурация темы
          themeMode: themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          
          // Подключение маршрутизатора
          routerConfig: router,
        ),
      ),
    );
  }
}
