


import 'diozz_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get global_error => 'An error occurred, please check the internet first or review the application administration !';

  @override
  String get no_internet_error => 'Please Connect to Internet !';

  @override
  String get weak_internet_error => 'Internet signal weak !';

  @override
  String get server_error => 'There is a problem with the server, please check the application management';

  @override
  String get lost_page => 'Error : you left the page';
}
