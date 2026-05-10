// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Велопрокат';

  @override
  String get findStations => 'Найти ближайшие станции';

  @override
  String bookBike(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count велосипедов',
      few: '$count велосипеда',
      one: '1 велосипед',
    );
    return 'Забронировать $_temp0';
  }

  @override
  String get pay => 'Оплатить';

  @override
  String get rentalTime => 'Время аренды';

  @override
  String get available => 'Доступно';

  @override
  String get stationName => 'Название станции';

  @override
  String get noActiveBooking => 'Нет активных бронирований';

  @override
  String get error => 'Произошла ошибка';

  @override
  String get finishRental => 'Завершить аренду';

  @override
  String get confirmPayment => 'Подтвердить оплату';

  @override
  String get cancel => 'Отмена';

  @override
  String get stationCenter => 'Центральная станция';

  @override
  String get stationPark => 'Станция Парк';

  @override
  String get stationUniversity => 'Университетская станция';

  @override
  String bikesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count велосипедов',
      few: '$count велосипеда',
      one: '1 велосипед',
    );
    return '$_temp0';
  }

  @override
  String get login => 'Вход';

  @override
  String get register => 'Регистрация';

  @override
  String get email => 'Эл. почта';

  @override
  String get password => 'Пароль';

  @override
  String get logout => 'Выйти';

  @override
  String get settings => 'Настройки';

  @override
  String get theme => 'Тема';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Темная';

  @override
  String get themeSystem => 'Системная';

  @override
  String get clearCache => 'Очистить кеш';

  @override
  String get version => 'Версия: 1.0.0';

  @override
  String get stations => 'Станции';

  @override
  String get bookings => 'Бронирования';

  @override
  String totalRents(Object count) {
    return 'Всего поездок: $count';
  }

  @override
  String welcome(Object name) {
    return 'Добро пожаловать, $name!';
  }

  @override
  String get selectQuantity => 'Выберите количество:';

  @override
  String get userNotFound => 'Пользователь не найден';

  @override
  String get wrongPassword => 'Неверный пароль';

  @override
  String get fillFields => 'Заполните все поля';

  @override
  String get passwordShort => 'Пароль слишком короткий';

  @override
  String get language => 'Язык';

  @override
  String get deleteAccounts => 'Удалить все аккаунты';

  @override
  String get bikeBooked => 'Велосипед забронирован!';

  @override
  String get refresh => 'Обновить';
}
