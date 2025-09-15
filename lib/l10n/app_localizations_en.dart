// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mini E-commerce';

  @override
  String get welcome => 'Welcome!';

  @override
  String hello(Object name) {
    return 'Hello, $name!';
  }

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get browseProducts => 'Browse Products';

  @override
  String get myOrders => 'My Orders';

  @override
  String get profile => 'Profile';

  @override
  String get nearby => 'Nearby';

  @override
  String get logout => 'Logout';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get selectLanguage => 'Select Language';
}
