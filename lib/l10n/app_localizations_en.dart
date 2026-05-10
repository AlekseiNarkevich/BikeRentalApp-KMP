// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bike Sharing';

  @override
  String get findStations => 'Find nearest stations';

  @override
  String bookBike(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bikes',
      one: '1 Bike',
    );
    return 'Book $_temp0';
  }

  @override
  String get pay => 'Pay';

  @override
  String get rentalTime => 'Rental Time';

  @override
  String get available => 'Available';

  @override
  String get stationName => 'Station Name';

  @override
  String get noActiveBooking => 'No active booking';

  @override
  String get error => 'Error occurred';

  @override
  String get finishRental => 'Finish Rental';

  @override
  String get confirmPayment => 'Confirm Payment';

  @override
  String get cancel => 'Cancel';

  @override
  String get stationCenter => 'Station Center';

  @override
  String get stationPark => 'Station Park';

  @override
  String get stationUniversity => 'Station University';

  @override
  String bikesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bikes',
      one: '1 Bike',
    );
    return '$_temp0';
  }

  @override
  String get login => 'Login';

  @override
  String get register => 'Registration';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get version => 'Version: 1.0.0';

  @override
  String get stations => 'Stations';

  @override
  String get bookings => 'Bookings';

  @override
  String totalRents(Object count) {
    return 'Total Rents: $count';
  }

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get selectQuantity => 'Select quantity:';

  @override
  String get userNotFound => 'User not found';

  @override
  String get wrongPassword => 'Wrong password';

  @override
  String get fillFields => 'Please fill all fields';

  @override
  String get passwordShort => 'Password is too short';

  @override
  String get language => 'Language';

  @override
  String get deleteAccounts => 'Delete all accounts';

  @override
  String get bikeBooked => 'Bike booked!';

  @override
  String get refresh => 'Refresh';
}
