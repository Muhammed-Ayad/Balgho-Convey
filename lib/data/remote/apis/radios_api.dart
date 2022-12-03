import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/models/radios/radios.dart';
import 'package:great_quran/data/remote/endpoints.dart';
import 'package:great_quran/data/remote/interfaces/i_radios_api.dart';

class RadiosApi implements IRadiosApi {
  static final provider = Provider<IRadiosApi>((ref) => RadiosApi());

  @override
  Future<List<Radios>> getRadios() async {
    try {
      final response = await rootBundle.loadString(AppEndpoints.radiosApi);
      List<Radios> radiosList = [];
      final Map<String, dynamic> responseBody = jsonDecode(response);
      var radiosListBody = responseBody['Radios'] as List;

      for (var radio in radiosListBody) {
        radiosList.add(Radios.fromJson(radio));
      }
      return radiosList;
    } catch (e, s) {
      debugPrint('Error Api $e\n$s');
      rethrow;
    }
  }
}
