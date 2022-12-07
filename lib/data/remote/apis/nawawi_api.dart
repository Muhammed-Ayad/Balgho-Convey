import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/models/nawawi/nawawi.dart';
import 'package:great_quran/data/remote/endpoints.dart';
import 'package:great_quran/data/remote/interfaces/i_nawawi_api.dart';

class NawawiApi implements INawawiApi {
  static final provider = Provider<INawawiApi>((ref) => NawawiApi());

  @override
  Future<List<Nawawi>> getNawawi() async {
    try {
      final response = await rootBundle.loadString(AppEndpoints.nawawiApi);

      final List<dynamic> responseBody = jsonDecode(response);
      return responseBody.map((e) => Nawawi.fromJson(e)).toList();
    } catch (e, s) {
      debugPrint('Error Api $e\n$s');
      rethrow;
    }
  }
}
