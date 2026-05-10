import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';

/// @file adaptive_layout.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Адаптивный макет (оболочка) приложения.

/// @class AdaptiveLayout
/// @brief Виджет, управляющий отображением навигации в зависимости от платформы и размера экрана.
/// 
/// Обеспечивает плавный переход между BottomNavigationBar (мобильные) 
/// и NavigationRail/Drawer (настольные ОС).
class AdaptiveLayout extends StatelessWidget {
  /// Текущий отображаемый контент (экран).
  final Widget child;

  const AdaptiveLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // [WEB] Определение текущего индекса меню на основе URL маршрута.
    final location = GoRouterState.of(context).matchedLocation;

    /// @brief Расчет активного индекса навигации.
    int calculateSelectedIndex() {
      if (location == '/') return 0;
      if (location == '/bookings') return 1;
      if (location == '/settings') return 2;
      return 0;
    }

    /// @brief Обработчик смены вкладки.
    void onDestinationSelected(int index) {
      switch (index) {
        case 0:
          context.go('/');
          break;
        case 1:
          context.go('/bookings');
          break;
        case 2:
          context.go('/settings');
          break;
      }
    }

    /// [ADAPTIVE] Использование AdaptiveScaffold для автоматической подстройки UI.
    return AdaptiveScaffold(
      selectedIndex: calculateSelectedIndex(),
      onSelectedIndexChange: onDestinationSelected,
      
      // Конфигурация пунктов меню
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.directions_bike),
          label: l10n.stations,
        ),
        NavigationDestination(
          icon: const Icon(Icons.history),
          label: l10n.bookings,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings),
          label: l10n.settings,
        ),
      ],
      
      // [ALL] Отрисовка основного контента
      body: (_) => child,
    );
  }
}
