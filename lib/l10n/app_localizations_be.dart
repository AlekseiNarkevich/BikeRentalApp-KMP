// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Belarusian (`be`).
class AppLocalizationsBe extends AppLocalizations {
  AppLocalizationsBe([String locale = 'be']) : super(locale);

  @override
  String get appTitle => 'Велапракат';

  @override
  String get findStations => 'Знайсці бліжэйшыя станцыі';

  @override
  String bookBike(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count веласіпедаў',
      few: '$count веласіпеды',
      one: '1 веласіпед',
    );
    return 'Забраніраваць $_temp0';
  }

  @override
  String get pay => 'Аплаціць';

  @override
  String get rentalTime => 'Час арэнды';

  @override
  String get available => 'Даступна';

  @override
  String get stationName => 'Назва станцыі';

  @override
  String get noActiveBooking => 'Няма актыўных браніраванняў';

  @override
  String get error => 'Адбылася памылка';

  @override
  String get finishRental => 'Завяршыць арэнду';

  @override
  String get confirmPayment => 'Пацвердзіць аплату';

  @override
  String get cancel => 'Адмена';

  @override
  String get stationCenter => 'Цэнтральная станцыя';

  @override
  String get stationPark => 'Станцыя Парк';

  @override
  String get stationUniversity => 'Універсітэцкая станцыя';

  @override
  String bikesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count веласіпедаў',
      few: '$count веласіпеды',
      one: '1 веласіпед',
    );
    return '$_temp0';
  }

  @override
  String get login => 'Уваход';

  @override
  String get register => 'Рэгістрацыя';

  @override
  String get email => 'Эл. пошта';

  @override
  String get password => 'Пароль';

  @override
  String get logout => 'Выйсці';

  @override
  String get settings => 'Налады';

  @override
  String get theme => 'Тэма';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Цёмная';

  @override
  String get themeSystem => 'Сістэмная';

  @override
  String get clearCache => 'Ачысціць кэш';

  @override
  String get version => 'Версія: 1.0.0';

  @override
  String get stations => 'Станцыі';

  @override
  String get bookings => 'Браніраванні';

  @override
  String totalRents(Object count) {
    return 'Усяго паездак: $count';
  }

  @override
  String welcome(Object name) {
    return 'Сардэчна запрашаем, $name!';
  }

  @override
  String get selectQuantity => 'Выберыце колькасць:';

  @override
  String get userNotFound => 'Карыстальнік не знойдзены';

  @override
  String get wrongPassword => 'Няправільны пароль';

  @override
  String get fillFields => 'Запоўніце ўсе палі';

  @override
  String get passwordShort => 'Пароль занадта кароткі';

  @override
  String get language => 'Мова';

  @override
  String get deleteAccounts => 'Выдаліць усе акаўнты';

  @override
  String get bikeBooked => 'Веласіпед забраніраваны!';

  @override
  String get refresh => 'Абнавіць';
}
