import 'dart:async';

import '../remote/apis/radios_api_services.dart';
import '../models/custom_error.dart';
import '../models/radios/radios.dart';

class RadiosRepository {
  final RadiosApiServices radiosApiServices;
  RadiosRepository({
    required this.radiosApiServices,
  });

  Future<List<Radios>> fetchRadios() async {
    try {
      final List<Radios> radiosList = await radiosApiServices.getRadios();
      return radiosList;
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
