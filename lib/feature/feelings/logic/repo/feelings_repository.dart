import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:great_quran/core/network/endpoints.dart';
import 'package:great_quran/feature/feelings/logic/models/feeling_item_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class IFeelingsRepository {
  Future<List<FeelingItemModel>> getFeelings();
  Future<FeelingItemModel?> getFeelingById(String id);
}

class FeelingsRepository implements IFeelingsRepository {
  static final provider =
      Provider<IFeelingsRepository>((ref) => FeelingsRepository());

  List<FeelingItemModel>? _cachedFeelings;

  @override
  Future<List<FeelingItemModel>> getFeelings() async {
    if (_cachedFeelings != null) {
      return _cachedFeelings!;
    }

    try {
      final jsonString =
          await rootBundle.loadString(AppEndpoints.feelingsVersesApi);
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      _cachedFeelings = jsonList
          .map(
              (item) => FeelingItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return _cachedFeelings!;
    } catch (e, stack) {
      debugPrint('Error in FeelingsRepository.getFeelings: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<FeelingItemModel?> getFeelingById(String id) async {
    final feelings = await getFeelings();
    try {
      return feelings.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }
}
