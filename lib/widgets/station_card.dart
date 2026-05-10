import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../models/station.dart';
import '../l10n/app_localizations.dart';
import '../screens/station_detail_screen.dart';
import '../utils/context_extensions.dart';

/// @file station_card.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Виджет карточки станции с поддержкой анимаций и адаптивности.

/// @class StationCard
/// @brief Класс, представляющий краткую информацию о станции в списке.
/// 
/// Виджет использует библиотеку animations для плавного перехода
/// к детальному экрану и подстраивается под размеры различных устройств.
class StationCard extends StatelessWidget {
  /// Данные станции для отображения в карточке.
  final Station station;

  /// @brief Конструктор виджета карточки.
  /// @param station Объект модели станции.
  const StationCard({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    /// [ADAPTIVE] Расчет размера иконки на основе ширины экрана (от 8%).
    /// Ограничено диапазоном 24-48 пикселей для удобства использования.
    final iconSize = context.percentWidth(0.08).clamp(24.0, 48.0);

    /// [ANIMATION] Использование OpenContainer для эффекта "развертывания" карточки.
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      
      /// @brief Конструктор экрана в открытом состоянии.
      /// @param closeContainer Функция для программного закрытия экрана (возврата).
      openBuilder: (context, closeContainer) => StationDetailScreen(
        stationId: station.id!,
        onClose: closeContainer,
      ),
      
      // Настройка внешнего вида закрытой карточки
      closedElevation: 4,
      closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      closedColor: theme.cardColor,
      
      /// @brief Отрисовка карточки в списке (закрытое состояние).
      /// @param openContainer Функция для открытия карточки.
      closedBuilder: (context, openContainer) => GestureDetector(
        /// [DESKTOP] Поддержка открытия по нажатию правой кнопки мыши (Web/Linux/Windows).
        onSecondaryTap: openContainer, 
        child: InkWell(
          onTap: openContainer,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Название станции с ограничением по строкам для сетки.
                Text(
                  station.name,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Текст "Доступно" из файлов локализации.
                          Text(l10n.available, style: theme.textTheme.bodySmall),
                          
                          /// Динамическое отображение количества велосипедов.
                          /// Используется FittedBox для масштабирования текста на малых экранах.
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${station.availableBikes} / ${station.totalBikes}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                /// Цветовая индикация: зеленый — есть в наличии, красный — пусто.
                                color: station.availableBikes > 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /// Иконка велосипеда с адаптивным размером.
                    Icon(
                      Icons.directions_bike, 
                      size: iconSize, 
                      color: Colors.blue.withValues(alpha: 0.8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
