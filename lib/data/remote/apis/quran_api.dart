import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/models/quran/surah.dart';
import 'package:great_quran/data/remote/endpoints.dart';

import 'package:great_quran/data/remote/interfaces/i_quran_api.dart';

class QuranApi implements IQuranApi {
  static final provider = Provider<IQuranApi>((ref) => QuranApi());

  @override
  Future<List<Surah>> getQuran() async {
    try {
      final response = await rootBundle.loadString(AppEndpoints.quranApi);
      List<Surah> surahsList = [];
      final Map<String, dynamic> responseBody = jsonDecode(response);
      var surahsListBody = responseBody['data']['surahs'] as List;

      for (var surah in surahsListBody) {
        surahsList.add(Surah.fromJson(surah));
      }
      return surahsList;
    } catch (e, s) {
      debugPrint('Error Api $e\n$s');
      rethrow;
    }
  }
}
