import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/azkar/logic/data/all_azkar.dart';
import 'package:great_quran/feature/azkar/logic/data/azkar_filter.dart';

void main() {
  group('AzkarFilterHelper tests', () {
    test('All section returns all items when search is empty', () {
      final results = AzkarFilterHelper.filter(
        section: AzkarSection.all,
        searchQuery: '',
      );

      expect(results.length, azkarDataList.length);
    });

    test('Daily section filters correctly', () {
      final results = AzkarFilterHelper.filter(
        section: AzkarSection.daily,
        searchQuery: '',
      );

      expect(results.contains("أذكار الصباح"), true);
      expect(results.contains("أذكار المساء"), true);
      expect(results.contains("دعاء السفر"), false);
    });

    test('Prayer section filters correctly', () {
      final results = AzkarFilterHelper.filter(
        section: AzkarSection.prayer,
        searchQuery: '',
      );

      expect(results.contains("أذكار الآذان"), true);
      expect(results.contains("دعاء الاستفتاح"), true);
      expect(results.contains("أذكار الصباح"), false);
    });

    test('Search query matches correctly', () {
      final results = AzkarFilterHelper.filter(
        section: AzkarSection.all,
        searchQuery: 'سفر',
      );

      expect(results.length, 1);
      expect(results.first, "دعاء السفر");
    });

    test('Search query combined with section filter works', () {
      final results = AzkarFilterHelper.filter(
        section: AzkarSection.prayer,
        searchQuery: 'ركوع',
      );

      expect(results.length, 2);
      expect(results.contains("دعاء الركوع"), true);
      expect(results.contains("دعاء الرفع من الركوع"), true);
    });
  });
}
