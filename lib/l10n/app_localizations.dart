import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'بلغوا'**
  String get appName;

  /// No description provided for @titleAppBar.
  ///
  /// In ar, this message translates to:
  /// **'بلغوا عني ولو آية'**
  String get titleAppBar;

  /// No description provided for @titleHello.
  ///
  /// In ar, this message translates to:
  /// **'مرحبا بكم'**
  String get titleHello;

  /// No description provided for @titleContactUs.
  ///
  /// In ar, this message translates to:
  /// **'تواصل معنا'**
  String get titleContactUs;

  /// No description provided for @titleShare.
  ///
  /// In ar, this message translates to:
  /// **'انشر التطبيق وشارك الاجر'**
  String get titleShare;

  /// No description provided for @titleQibla.
  ///
  /// In ar, this message translates to:
  /// **'القبلة'**
  String get titleQibla;

  /// No description provided for @titleQuran.
  ///
  /// In ar, this message translates to:
  /// **'القرآن الكريم'**
  String get titleQuran;

  /// No description provided for @titleQuranGreat.
  ///
  /// In ar, this message translates to:
  /// **'القرآن العظيم'**
  String get titleQuranGreat;

  /// No description provided for @titleRadio.
  ///
  /// In ar, this message translates to:
  /// **'إذاعات القرآن'**
  String get titleRadio;

  /// No description provided for @titleAzkar.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار'**
  String get titleAzkar;

  /// No description provided for @titleNawawi.
  ///
  /// In ar, this message translates to:
  /// **'الأربعون النووية'**
  String get titleNawawi;

  /// No description provided for @titleAzan.
  ///
  /// In ar, this message translates to:
  /// **'مواقيت الصلاة'**
  String get titleAzan;

  /// No description provided for @titleClose.
  ///
  /// In ar, this message translates to:
  /// **'اغلاق'**
  String get titleClose;

  /// No description provided for @titlePlay.
  ///
  /// In ar, this message translates to:
  /// **'اضغط علي زر التشغيل'**
  String get titlePlay;

  /// No description provided for @titleExplanationTheHadith.
  ///
  /// In ar, this message translates to:
  /// **'شرح الحديث'**
  String get titleExplanationTheHadith;

  /// No description provided for @titleCopy.
  ///
  /// In ar, this message translates to:
  /// **'تم النسخ '**
  String get titleCopy;

  /// No description provided for @titleReview.
  ///
  /// In ar, this message translates to:
  /// **'تقييم التطبيق '**
  String get titleReview;

  /// No description provided for @azanFajr.
  ///
  /// In ar, this message translates to:
  /// **'الفجر'**
  String get azanFajr;

  /// No description provided for @azanSunrise.
  ///
  /// In ar, this message translates to:
  /// **'الشروق'**
  String get azanSunrise;

  /// No description provided for @azanDhuhr.
  ///
  /// In ar, this message translates to:
  /// **'الظهر'**
  String get azanDhuhr;

  /// No description provided for @azanAsr.
  ///
  /// In ar, this message translates to:
  /// **'العصر'**
  String get azanAsr;

  /// No description provided for @azanMaghrib.
  ///
  /// In ar, this message translates to:
  /// **'المغرب'**
  String get azanMaghrib;

  /// No description provided for @azanIsha.
  ///
  /// In ar, this message translates to:
  /// **'العشاء'**
  String get azanIsha;

  /// No description provided for @errorConnectInternet.
  ///
  /// In ar, this message translates to:
  /// **'برجاء الاتصال بالانترنت'**
  String get errorConnectInternet;

  /// No description provided for @errorError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ'**
  String get errorError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
