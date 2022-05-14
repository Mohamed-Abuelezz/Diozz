


import 'diozz_localizations.dart';

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get global_error => '! حدث خطأ يرجي التأكد من الانترنت اولا او مراجعه اداره التطبيق';

  @override
  String get no_internet_error => 'برجاء الإتصال بالإنترنت !';

  @override
  String get weak_internet_error => 'إشارة الإنترنت ضعيفة !';

  @override
  String get server_error => 'يوجد مشكلة فى السيرفر برجاء مراجعة إدارة التطبيق';

  @override
  String get lost_page => 'حدث خطأ: تركت الصفحة';
}
