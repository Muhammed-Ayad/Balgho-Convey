import 'dart:convert';

import 'package:flutter/services.dart';
import '../../models/radios/radios.dart';

class RadiosApiServices {
  Future<List<Radios>> getRadios() async {
    try {
      final response = await rootBundle.loadString("assets/json/radios.json");
      List<Radios> radiosList = [];
      final Map<String, dynamic> responseBody = jsonDecode(response);
      var radiosListBody = responseBody['Radios'] as List;

      for (var radio in radiosListBody) {
        radiosList.add(Radios.fromJson(radio));
      }
      return radiosList;
    } catch (e) {
      rethrow;
    }
  }
}
