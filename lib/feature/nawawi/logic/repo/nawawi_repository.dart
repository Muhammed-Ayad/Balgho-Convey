import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:great_quran/core/network/endpoints.dart';
import 'package:great_quran/feature/nawawi/logic/models/nawawi.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class INawawiRepository {
  Future<List<Nawawi>> getNawawi();
}

class NawawiRepository implements INawawiRepository {
  static final provider =
      Provider<INawawiRepository>((ref) => NawawiRepository());

  @override
  Future<List<Nawawi>> getNawawi() async {
    try {
      final response = await rootBundle.loadString(AppEndpoints.nawawiApi);
      final List<dynamic> responseBody = jsonDecode(response);
      return responseBody.map((e) => Nawawi.fromJson(e)).toList();
    } catch (e, s) {
      debugPrint('Error NawawiRepository $e\n$s');
      rethrow;
    }
  }
}
