// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters
// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> ar = {
    "app_name": "بلغوا",
    "title": {
      "app_bar": "بلغوا عني ولو آية",
      "hello": "مرحبا بكم",
      "contant_us": "تواصل معنا",
      "share": "انشر التطبيق وشارك الاجر",
      "kible": "القبلة",
      "quran": "القرآن الكريم",
      "quranGreat": "القرآن العظيم",
      "radio": "إذاعات القرآن",
      "azkar": "الأذكار",
      "nawawi": "الأربعون النووية",
      "azan": "مواقيت الصلاة",
      "close": "اغلاق",
      "play": "اضغط علي زر التشغيل",
      "explanation_the_hadith": "شرح الحديث",
      "copy": "تم النسخ ",
      "review": "تقييم التطبيق "
    },
    "azan": {
      "fajr": "الفجر",
      "sunrise": "الشروق",
      "dhuhr": "الظهر",
      "asr": "العصر",
      "maghrib": "المغرب",
      "isha": "العشاء"
    },
    "body": {},
    "error": {"connect_internet": "برجاء الاتصال بالانترنت", "error": "خطأ"}
  };
  static const Map<String, dynamic> en = {
    "app_name": "بلغوا",
    "title": {
      "app_bar": "",
      "hello": "",
      "contant_us": "",
      "share": "",
      "kible": "",
      "quran": "",
      "quranGreat": "",
      "radio": "",
      "azkar": "",
      "nawawi": "",
      "azan": "",
      "close": "",
      "play": "",
      "explanation_the_hadith": "",
      "copy": "",
      "review": ""
    },
    "azan": {
      "fajr": "",
      "sunrise": "",
      "dhuhr": "",
      "asr": "",
      "maghrib": "",
      "isha": ""
    },
    "body": {},
    "error": {"connect_internet": "", "error": ""}
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "ar": ar,
    "en": en
  };
}
