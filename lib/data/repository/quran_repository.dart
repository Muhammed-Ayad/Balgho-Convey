import 'dart:async';
import '../data_provider/remote/quran_api_services.dart';
import '../models/custom_error.dart';

import '../models/quran/surah.dart';

class QuranRepository {
  final QuranApiServices quranApiServices;
  QuranRepository({
    required this.quranApiServices,
  });

  Future<List<Surah>> fetchQuran() async {
    try {
      final List<Surah> surahsList = await quranApiServices.getQuran();
      return surahsList;
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
