import 'package:great_quran/blocs/models/azan/azan.dart';

abstract class IAzanTimeApi {
  Future<Azan> getAzan();
}
