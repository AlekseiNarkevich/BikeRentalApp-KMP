import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bike_provider.dart';
import '../l10n/app_localizations.dart';
import 'package:intl/intl.dart';

/// @file bookings_screen.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Экран со списком активных бронирований пользователя.

/// @class BookingsScreen
/// @brief Виджет для отображения текущей истории аренд и управления ими.
class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Получение текущего состояния провайдера велосипедов
    final state = ref.watch(bikeProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bookings)),
      body: state.activeBookings.isEmpty
          ? Center(child: Text(l10n.noActiveBooking))
          : ListView.builder(
              itemCount: state.activeBookings.length,
              itemBuilder: (context, index) {
                final booking = state.activeBookings[index];
                // Поиск информации о станции, связанной с бронированием
                final station = state.stations.firstWhere((s) => s.id == booking.stationId);

                return Dismissible(
                  key: Key(booking.startTime.toString()),
                  // [ANDROID/IOS] Фон при смахивании элемента вправо (жест удаления/завершения).
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                  onDismissed: (_) async {
                    // Асинхронное завершение аренды при свайпе
                    await ref.read(bikeProvider.notifier).completeRental(booking);
                  },
                  child: ListTile(
                    title: Text(station.name),
                    subtitle: Text(
                      '${l10n.bikesCount(booking.quantity)} • ${DateFormat.Hm().format(booking.startTime)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.done_all),
                      tooltip: l10n.finishRental,
                      onPressed: () => ref.read(bikeProvider.notifier).completeRental(booking),
                    ),
                  ),
                );
              },
            ),
      /// Панель со сводной статистикой в нижней части экрана.
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: theme.colorScheme.secondaryContainer,
        child: Text(
          l10n.totalRents(state.totalRentsCount),
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
