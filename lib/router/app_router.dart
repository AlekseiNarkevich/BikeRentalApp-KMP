import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';
import '../screens/station_detail_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/bookings_screen.dart';
import '../screens/map_screen.dart';
import '../widgets/adaptive_layout.dart';

/// @file app_router.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Конфигурация маршрутизации приложения на базе GoRouter.

/// @brief Провайдер маршрутизатора приложения.
/// 
/// Содержит описание всех путей, логику перенаправления (Guard) для защиты
/// маршрутов от неавторизованных пользователей и ShellRoute для адаптивного макета.
final routerProvider = Provider<GoRouter>((ref) {
  // Наблюдаем за состоянием авторизации для динамического редиректа
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    
    /// @brief Глобальная логика перенаправления.
    /// [WEB] Обеспечивает корректное отображение URL в адресной строке браузера.
    redirect: (context, state) {
      final isLoggedIn = authState != null;
      final isLoggingIn = state.matchedLocation == '/login';

      // Если пользователь не вошел и не на экране входа — отправляем на /login
      if (!isLoggedIn && !isLoggingIn) return '/login';
      // Если пользователь уже вошел, но пытается попасть на /login — отправляем на главную
      if (isLoggedIn && isLoggingIn) return '/';
      
      return null;
    },

    routes: [
      /// @brief Маршрут экрана входа/регистрации (вне ShellRoute, без навигации).
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      /// @brief Маршрут оболочки для вкладок приложения.
      /// Использует AdaptiveLayout для переключения между BottomNavigationBar и NavigationRail.
      ShellRoute(
        builder: (context, state, child) {
          return AdaptiveLayout(child: child);
        },
        routes: [
          /// @brief Главный экран со списком станций.
          GoRoute(
            path: '/',
            builder: (context, state) => const MainScreen(),
            routes: [
              /// @brief Подмаршрут деталей станции.
              /// @param id Уникальный идентификатор станции из URL.
              GoRoute(
                path: 'station/:id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return StationDetailScreen(stationId: id);
                },
              ),
            ],
          ),

          /// @brief Маршрут экрана активных бронирований.
          GoRoute(
            path: '/bookings',
            builder: (context, state) => const BookingsScreen(),
          ),

          /// @brief Маршрут экрана настроек.
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),

          /// @brief Маршрут экрана карты станций.
          GoRoute(
            path: '/map',
            builder: (context, state) => const MapScreen(),
          ),
        ],
      ),
    ],
  );
});
