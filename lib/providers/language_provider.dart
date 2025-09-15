import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', '');

  Locale get currentLocale => _currentLocale;

  void setLocale(Locale locale) {
    _currentLocale = locale;
    notifyListeners();
  }

  bool get isArabic => _currentLocale.languageCode == 'ar';
}
