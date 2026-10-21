import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:great_quran/feature/quran/logic/models/quran_bookmark.dart';
import 'package:great_quran/feature/quran/logic/models/surah.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranRepository {
  static const String _bookmarkKey = 'quran_last_bookmark';
  static const String _fontSizeKey = 'quran_font_size';

  List<Surah>? _cachedSurahs;

  Future<List<Surah>> getAllSurahs() async {
    if (_cachedSurahs != null) {
      return _cachedSurahs!;
    }

    final jsonString = await rootBundle.loadString('assets/json/quran.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final List<dynamic> surahsJson = data['data']['surahs'] as List<dynamic>;

    _cachedSurahs = surahsJson
        .map((s) => Surah.fromJson(s as Map<String, dynamic>))
        .toList();

    return _cachedSurahs!;
  }

  Future<Surah?> getSurahByNumber(int number) async {
    final surahs = await getAllSurahs();
    try {
      return surahs.firstWhere((s) => s.number == number);
    } catch (_) {
      return null;
    }
  }

  Future<QuranBookmark?> getBookmark() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_bookmarkKey);
      if (raw == null || raw.isEmpty) return null;
      return QuranBookmark.fromJson(json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveBookmark(QuranBookmark bookmark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_bookmarkKey, json.encode(bookmark.toJson()));
    } catch (_) {}
  }

  Future<double> getFontSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_fontSizeKey) ?? 24.0;
    } catch (_) {
      return 24.0;
    }
  }

  Future<void> saveFontSize(double size) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_fontSizeKey, size);
    } catch (_) {}
  }

  static String normalizeArabic(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u0652\u0670\u06D6-\u06ED]'), '')
        .replaceAll('ٱ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .trim();
  }
}
