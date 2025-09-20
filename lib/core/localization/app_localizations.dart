import 'package:flutter/material.dart';

class AppLocalizations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'User Manager',
      'users': 'Users',
      'profile': 'Profile',
      'sign_in_with_google': 'Sign in With Google',
      'sign_out': 'Sign Out',
      'create_user': 'Create User',
      'update_user': 'Update User',
      'delete': 'Delete',
      'edit': 'Edit',
      'name': 'Name',
      'job': 'Job',
      'email': 'Email',
      'user_id': 'User ID',
      'save': 'Save',
      'update': 'Update',
      'retry': 'Retry',
      'no_internet_connection': 'No Internet Connection',
      'check_internet_message':
          'Please check your internet connection and try again.',
      'sign_in_failed': 'Sign-In Failed',
      'sign_out_failed': 'Sign out failed',
      'error': 'Error',
      'no_data': 'No data',
      'unknown_user': 'Unknown User',
      'no_email': 'No email',
      'not_provided': 'Not provided',
      'loading': 'Loading...',
    },
    'hi': {
      'app_title': 'उपयोगकर्ता प्रबंधक',
      'users': 'उपयोगकर्ता',
      'profile': 'प्रोफ़ाइल',
      'sign_in_with_google': 'Google के साथ साइन इन करें',
      'sign_out': 'साइन आउट',
      'create_user': 'उपयोगकर्ता बनाएं',
      'update_user': 'उपयोगकर्ता अपडेट करें',
      'delete': 'हटाएं',
      'edit': 'संपादित करें',
      'name': 'नाम',
      'job': 'नौकरी',
      'email': 'ईमेल',
      'user_id': 'उपयोगकर्ता आईडी',
      'save': 'सहेजें',
      'update': 'अपडेट करें',
      'retry': 'पुनः प्रयास करें',
      'no_internet_connection': 'कोई इंटरनेट कनेक्शन नहीं',
      'check_internet_message':
          'कृपया अपना इंटरनेट कनेक्शन जांचें और पुनः प्रयास करें।',
      'sign_in_failed': 'साइन इन असफल',
      'sign_out_failed': 'साइन आउट असफल',
      'error': 'त्रुटि',
      'no_data': 'कोई डेटा नहीं',
      'unknown_user': 'अज्ञात उपयोगकर्ता',
      'no_email': 'कोई ईमेल नहीं',
      'not_provided': 'प्रदान नहीं किया गया',
      'loading': 'लोड हो रहा है...',
    },
  };

  final Locale locale;

  AppLocalizations(this.locale);

  static List<String> get supportedLocales => ['en', 'hi'];

  static String getLocalizedString(String key, String locale) {
    return _localizedValues[locale]?[key] ?? _localizedValues['en']![key]!;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String getString(String key) {
    return AppLocalizations.getLocalizedString(key, locale.languageCode);
  }

  // Convenience getters
  String get appTitle => getString('app_title');
  String get users => getString('users');
  String get profile => getString('profile');
  String get signInWithGoogle => getString('sign_in_with_google');
  String get signOut => getString('sign_out');
  String get createUser => getString('create_user');
  String get updateUser => getString('update_user');
  String get delete => getString('delete');
  String get edit => getString('edit');
  String get name => getString('name');
  String get job => getString('job');
  String get email => getString('email');
  String get userId => getString('user_id');
  String get save => getString('save');
  String get update => getString('update');
  String get retry => getString('retry');
  String get noInternetConnection => getString('no_internet_connection');
  String get checkInternetMessage => getString('check_internet_message');
  String get signInFailed => getString('sign_in_failed');
  String get signOutFailed => getString('sign_out_failed');
  String get error => getString('error');
  String get noData => getString('no_data');
  String get unknownUser => getString('unknown_user');
  String get noEmail => getString('no_email');
  String get notProvided => getString('not_provided');
  String get loading => getString('loading');
}

class LocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const LocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(LocalizationDelegate old) => false;
}
