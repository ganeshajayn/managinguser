import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  void changeLanguage(String languageCode) {
    if (_currentLocale.languageCode != languageCode) {
      _currentLocale = Locale(languageCode);
      notifyListeners();
    }
  }

  bool get isEnglish => _currentLocale.languageCode == 'en';
  bool get isHindi => _currentLocale.languageCode == 'hi';
}
