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
      List<Nawawi> nawawiList = [];
      final Map<String, dynamic> responseBody = jsonDecode(response);
      var nawawiListBody = responseBody as List;

      for (var nawawi in nawawiListBody) {
        nawawiList.add(Nawawi.fromJson(nawawi));
      }
      return nawawiList;
    } catch (e, s) {
      debugPrint('Error Api $e\n$s');
      rethrow;
    }
  }
}
