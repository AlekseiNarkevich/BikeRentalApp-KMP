import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/bike_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/station_card.dart';

/// @file main_screen.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Главный экран приложения со списком станций велопроката.

/// @class MainScreen
/// @brief Виджет главного экрана, отображающий станции в виде адаптивной сетки карточек.
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

/// @class _MainScreenState
/// @brief Состояние главного экрана, отвечающее за инициализацию загрузки данных.
class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Инициализация загрузки данных при первом показе экрана
    Future.microtask(() => ref.read(bikeProvider.notifier).loadData());
  }

  @override
  Widget build(BuildContext context) {
    // Подписка на состояние провайдера велосипедов
    final state = ref.watch(bikeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.stations),
        actions: [
          /// Кнопка перехода к экрану карты.
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () => context.push('/map'),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                // [ADAPTIVE] Динамическое определение количества колонок сетки на основе ширины окна.
                final crossAxisCount = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
                
                return Scrollbar(
                  // [WEB/DESKTOP] Принудительное отображение полосы прокрутки для не-мобильных платформ.
                  thumbVisibility: kIsWeb || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.windows,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: state.stations.length,
                    itemBuilder: (context, index) {
                      final station = state.stations[index];
                      return StationCard(
                        station: station,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
