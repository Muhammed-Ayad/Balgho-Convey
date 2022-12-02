import 'package:great_quran/blocs/models/radios/radios.dart';

abstract class IRadiosApi {
  Future<List<Radios>> getRadios();
}
