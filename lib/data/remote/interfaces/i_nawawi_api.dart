import 'package:great_quran/blocs/models/nawawi/nawawi.dart';

abstract class INawawiApi {
  Future<List<Nawawi>> getNawawi();
}
