
import 'package:great_quran/blocs/models/quran/surah.dart';

abstract class IQuranApi {
  Future<List<Surah>> getQuran();
}
