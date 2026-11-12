import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/feelings/logic/models/feeling_item_model.dart';
import 'package:great_quran/feature/feelings/logic/repo/feelings_repository.dart';

class LocalTestFeelingsRepository extends FeelingsRepository {
  @override
  Future<List<FeelingItemModel>> getFeelings() async {
    final file = File('assets/json/feelings_verses.json');
    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((item) =>
            FeelingItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FeelingsRepository Tests', () {
    late FeelingsRepository repository;

    setUp(() {
      repository = LocalTestFeelingsRepository();
    });

    test('getFeelings returns all 8 feelings parsed correctly', () async {
      final feelings = await repository.getFeelings();
      expect(feelings.length, 8);
      expect(feelings.any((f) => f.id == 'anxiety'), isTrue);
      expect(feelings.any((f) => f.id == 'sadness'), isTrue);
      expect(feelings.any((f) => f.id == 'illness'), isTrue);
    });

    test('getFeelingById returns correct feeling or null if not found',
        () async {
      final feeling = await repository.getFeelingById('anxiety');
      expect(feeling, isNotNull);
      expect(feeling!.id, 'anxiety');
      expect(feeling.title, 'قلق');
      expect(feeling.verses.isNotEmpty, isTrue);

      final nonExistent = await repository.getFeelingById('non_existent_id');
      expect(nonExistent, isNull);
    });
  });
}
