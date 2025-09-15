// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'متجر إلكتروني صغير';

  @override
  String get welcome => 'مرحباً!';

  @override
  String hello(Object name) {
    return 'مرحباً، $name!';
  }

  @override
  String get quickActions => 'الإجراءات السريعة';

  @override
  String get browseProducts => 'تصفح المنتجات';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get nearby => 'القريب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get selectLanguage => 'اختر اللغة';
}
