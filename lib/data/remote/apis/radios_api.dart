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
    final url = await rootBundle.loadString(AppEndpoints.radiosApi);
    try {
      final response = jsonDecode(url);
      return (response as List)
          .map((e) => Radios.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, s) {
      debugPrint('Radios Api Error   $e\n$s');
      rethrow;
    }
  }
}
