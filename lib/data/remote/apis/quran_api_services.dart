import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/quran/surah.dart';

class QuranApiServices {
  Future<List<Surah>> getQuran() async {
    try {
      final response = await rootBundle.loadString("assets/json/quran.json");
      List<Surah> surahsList = [];
      final Map<String, dynamic> responseBody = jsonDecode(response);
      var surahsListBody = responseBody['data']['surahs'] as List;
      // print('surahsListBody : $surahsListBody');

      for (var surah in surahsListBody) {
        surahsList.add(Surah.fromJson(surah));
      }
      return surahsList;
    } catch (e) {
      rethrow;
    }
  }
}
