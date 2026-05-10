import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bike_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/weather_service.dart';

/// @file station_detail_screen.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Экран детальной информации о станции велопроката.

/// @class StationDetailScreen
/// @brief Виджет для просмотра данных о станции, погоды и оформления бронирования.
class StationDetailScreen extends ConsumerStatefulWidget {
  /// ID станции для отображения.
  final int stationId;
  
  /// [ANIMATION] Коллбэк для закрытия анимационного контейнера.
  final VoidCallback? onClose;

  const StationDetailScreen({
    super.key, 
    required this.stationId,
    this.onClose,
  });

  @override
  ConsumerState<StationDetailScreen> createState() => _StationDetailScreenState();
}

/// @class _StationDetailScreenState
/// @brief Состояние экрана деталей, управляющее загрузкой погоды и выбором количества велосипедов.
class _StationDetailScreenState extends ConsumerState<StationDetailScreen> {
  /// Выбранное пользователем количество велосипедов для аренды.
  int _selectedQuantity = 1;
  /// [LOGIC] Флаг процесса бронирования для предотвращения повторных нажатий (анти-спам).
  bool _isBooking = false;
  /// Сервис для получения данных о погоде.
  final WeatherService _weatherService = WeatherService();
  /// Объект с результатами запроса погоды.
  WeatherResult? _weather;

  @override
  void initState() {
    super.initState();
    // Запрос данных о погоде при инициализации экрана
    _fetchWeather();
  }

  /// @brief Асинхронное получение данных о погоде по координатам станции.
  Future<void> _fetchWeather() async {
    final station = ref.read(bikeProvider).stations.firstWhere((s) => s.id == widget.stationId);
    final weather = await _weatherService.getWeather(station.latitude, station.longitude);
    if (mounted) {
      setState(() => _weather = weather);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bikeProvider);
    final l10n = AppLocalizations.of(context)!;
    final station = state.stations.firstWhere((s) => s.id == widget.stationId);

    return Scaffold(
      appBar: AppBar(
        title: Text(station.name),
        // [ANIMATION] Если onClose передан, используем его для возврата (актуально для WEB)
        leading: widget.onClose != null 
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onClose,
              ) 
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// [API] Информационный блок с текущей погодой в районе станции.
            if (_weather != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_weather!.icon),
                    const SizedBox(width: 8),
                    Text(_weather!.temp, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Text(l10n.available, style: Theme.of(context).textTheme.titleMedium),
            Text('${station.availableBikes} / ${station.totalBikes}', 
                style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 32),
            
            /// Секция выбора количества велосипедов.
            if (station.availableBikes > 0) ...[
              Text(l10n.selectQuantity, style: Theme.of(context).textTheme.titleSmall),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: (_selectedQuantity > 1 && !_isBooking) ? () => setState(() => _selectedQuantity--) : null,
                  ),
                  Text('$_selectedQuantity', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: (_selectedQuantity < station.availableBikes && !_isBooking) 
                        ? () => setState(() => _selectedQuantity++) : null,
                  ),
                ],
              ),
            ],
            
            const Spacer(),
            /// Кнопка подтверждения бронирования.
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (station.availableBikes > 0 && !_isBooking)
                    ? () async {
                        // Блокируем кнопку для предотвращения спама
                        setState(() => _isBooking = true);
                        
                        // [WEB] Запускаем процесс бронирования асинхронно
                        final bookingFuture = ref.read(bikeProvider.notifier).bookBike(
                          widget.stationId, 
                          _selectedQuantity,
                          l10n.bikeBooked,
                        );

                        // [WEB/ANIMATION] Мгновенно закрываем экран для лучшего UX
                        if (widget.onClose != null) {
                          widget.onClose!();
                        } else if (context.mounted) {
                          Navigator.of(context).pop();
                        }

                        // Ожидаем завершения транзакции в фоне
                        await bookingFuture;
                      }
                    : null,
                child: _isBooking 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(l10n.bookBike(_selectedQuantity)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
