import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:great_quran/core/network/endpoints.dart';
import 'package:great_quran/feature/radios/logic/models/radios.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class IRadiosRepository {
  Future<List<Radios>> getRadios();
}

class RadiosRepository implements IRadiosRepository {
  static final provider =
      Provider<IRadiosRepository>((ref) => RadiosRepository());

  @override
  Future<List<Radios>> getRadios() async {
    final url = await rootBundle.loadString(AppEndpoints.radiosApi);
    try {
      final response = jsonDecode(url);
      return (response as List)
          .map((e) => Radios.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, s) {
      debugPrint('RadiosRepository Error $e\n$s');
      rethrow;
    }
  }
}
