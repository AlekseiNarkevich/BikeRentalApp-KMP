import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../providers/bike_provider.dart';

/// @file map_screen.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Экран с интерактивной картой станций велопроката.

/// @class MapScreen
/// @brief Виджет карты, отображающий расположение всех доступных станций.
/// 
/// Использует AutomaticKeepAliveClientMixin для предотвращения перезагрузки тайлов при навигации.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

/// @class _MapScreenState
/// @brief Состояние экрана карты с поддержкой сохранения состояния.
class _MapScreenState extends ConsumerState<MapScreen> with AutomaticKeepAliveClientMixin {
  /// @brief Флаг сохранения состояния виджета в памяти.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // Вызов метода базового класса для работы KeepAlive
    super.build(context);
    
    // Получение данных о станциях для расстановки маркеров
    final bikeState = ref.watch(bikeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: FlutterMap(
        options: const MapOptions(
          /// [Minsk] Координаты центра карты по умолчанию.
          initialCenter: LatLng(53.9006, 27.5590),
          initialZoom: 13.0,
          interactionOptions: InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
        ),
        children: [
          /// Слой отрисовки карты (OSM).
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.lab9',
            // [OPT] Стандартный провайдер с поддержкой HTTP-кеширования.
            tileProvider: NetworkTileProvider(),
          ),
          /// Слой маркеров станций.
          MarkerLayer(
            markers: bikeState.stations.map((station) {
              return Marker(
                point: LatLng(station.latitude, station.longitude),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => context.push('/station/${station.id}'),
                  child: Icon(
                    Icons.location_on,
                    /// Визуальная индикация: красный — есть велосипеды, серый — пусто.
                    color: station.availableBikes > 0 ? Colors.red : Colors.grey,
                    size: 40,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
