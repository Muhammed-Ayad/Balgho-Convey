import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:great_quran/blocs/models/radios/radios.dart';
import 'package:great_quran/data/remote/endpoints.dart';
import 'package:great_quran/data/remote/interfaces/i_radios_api.dart';
import 'package:great_quran/helpers/type_def.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'radios_api.g.dart';

@riverpod
RadiosApi radiosApi(RadiosApiRef ref) {
  return RadiosApi();
}

class RadiosApi implements IRadiosApi {
  @override
  Future<List<Radios>> getRadios() async {
    final url = await rootBundle.loadString(AppEndpoints.radiosApi);
    try {
      final response = jsonDecode(url);
      return (response as List).map((e) => Radios.fromJson(e as JSON)).toList();
    } catch (e, s) {
      debugPrint('Radios Api Error   $e\n$s');
      rethrow;
    }
  }
}
