import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Quranic Text Integrity and Authenticity Tests', () {
    late Map<int, Map<String, dynamic>> surahMap;
    late List<dynamic> feelingsJson;

    setUpAll(() async {
      // 1. Load authenticated quran.json directly from disk
      final quranFile = File('assets/json/quran.json');
      expect(quranFile.existsSync(), isTrue,
          reason: 'assets/json/quran.json must exist');
      final quranRaw = await quranFile.readAsString();
      final Map<String, dynamic> quranData = json.decode(quranRaw);
      final List<dynamic> surahsList = quranData['data']['surahs'];

      surahMap = {
        for (var s in surahsList) s['number'] as int: s as Map<String, dynamic>
      };

      // 2. Load feelings_verses.json
      final feelingsFile = File('assets/json/feelings_verses.json');
      expect(feelingsFile.existsSync(), isTrue,
          reason: 'assets/json/feelings_verses.json must exist');
      final feelingsRaw = await feelingsFile.readAsString();
      feelingsJson = json.decode(feelingsRaw) as List<dynamic>;
    });

    test('Contains exactly the 9 approved feelings with correct titles', () {
      final feelingIds = feelingsJson.map((e) => e['id'] as String).toList();
      const expectedIds = [
        'anxiety',
        'sadness',
        'shortcoming',
        'gratitude',
        'joy',
        'indecision',
        'illness',
        'loneliness',
        'distress',
      ];
      expect(feelingIds, expectedIds);

      final feelingTitles =
          feelingsJson.map((e) => e['title'] as String).toList();
      const expectedTitles = [
        'قلق',
        'حزن',
        'تقصير',
        'شكر',
        'فرح',
        'حيرة وقرار',
        'مرض',
        'وحدة',
        'ضيق وكرب',
      ];
      expect(feelingTitles, expectedTitles);
    });

    test('Each feeling has between 5 and 6 curated verses', () {
      for (final feeling in feelingsJson) {
        final verses = feeling['verses'] as List<dynamic>;
        expect(
          verses.length,
          greaterThanOrEqualTo(5),
          reason: 'Feeling ${feeling['id']} must have at least 5 verses',
        );
        expect(
          verses.length,
          lessThanOrEqualTo(6),
          reason: 'Feeling ${feeling['id']} must have at most 6 verses',
        );
      }
    });

    test('All 9 feeling icons exist on disk in assets/images/feelings/', () {
      for (final feeling in feelingsJson) {
        final iconPath = feeling['icon'] as String;
        final iconFile = File(iconPath);
        expect(
          iconFile.existsSync(),
          isTrue,
          reason: 'Icon file $iconPath must exist on disk',
        );
        expect(
          iconFile.lengthSync(),
          isPositive,
          reason: 'Icon file $iconPath must not be empty',
        );
      }
    });

    String cleanQuranText(String text) {
      return text
          .replaceAll('\ufeff', '')
          .replaceAll(RegExp(r'\u06DE\s*'), '')
          .replaceAll(RegExp(r'\s*[\u06D6-\u06DA\u06DC\u06DD]\s*'), ' ')
          .replaceAll(RegExp(r'[\u06DF\u06E0]'), '')
          .replaceAll(RegExp(r'[\u06E2\u06ED]'), '')
          .replaceAll('\u0625\u0650', '\u0625')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
    }

    test(
        'Every verse in feelings_verses.json 100% matches authenticated text in quran.json',
        () {
      for (final feeling in feelingsJson) {
        final verses = feeling['verses'] as List<dynamic>;
        for (final verse in verses) {
          final surahNum = verse['surahNumber'] as int;
          final ayahNum = verse['ayahNumber'] as int;
          final ayahText = verse['ayahText'] as String;

          expect(surahMap.containsKey(surahNum), isTrue,
              reason: 'Surah $surahNum must exist in quran.json');
          final surah = surahMap[surahNum]!;
          final ayahs = surah['ayahs'] as List<dynamic>;

          final matchingAyah = ayahs.firstWhere(
            (a) => a['numberInSurah'] == ayahNum,
            orElse: () => null,
          );

          expect(matchingAyah, isNotNull,
              reason:
                  'Ayah $ayahNum in Surah $surahNum not found in quran.json');

          var authenticText =
              (matchingAyah['text'] as String).replaceAll('\ufeff', '');
          if (surahNum != 1 && ayahNum == 1) {
            const bismillah = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';
            if (authenticText.startsWith(bismillah)) {
              authenticText = authenticText.substring(bismillah.length).trim();
            }
          }

          expect(
            ayahText,
            equals(cleanQuranText(authenticText)),
            reason:
                'Text discrepancy in feeling: ${feeling['id']}, Surah $surahNum, Ayah $ayahNum',
          );
        }
      }
    });

    test(
        'Every verse has a non-empty comfort message, context, tags and valid id',
        () {
      final allIds = <String>{};
      for (final feeling in feelingsJson) {
        final feelingId = feeling['id'] as String;
        final verses = feeling['verses'] as List<dynamic>;
        if (feelingId == 'illness') {
          expect(feeling['disclaimer'], isNotNull);
          expect((feeling['disclaimer'] as String).trim(), isNotEmpty);
        }
        for (final verse in verses) {
          final id = verse['id'] as String;
          expect(allIds.contains(id), isFalse, reason: 'Duplicate ID $id');
          allIds.add(id);
          expect(id.startsWith('$feelingId-'), isTrue);
          expect((verse['surahName'] as String).trim(), isNotEmpty);
          expect((verse['comfortMessage'] as String).trim(), isNotEmpty);
          expect((verse['context'] as String).trim(), isNotEmpty);
          expect(verse['tags'], isA<List>());
          expect((verse['tags'] as List).isNotEmpty, isTrue);
          expect(verse['surahNumber'], isPositive);
          expect(verse['ayahNumber'], isPositive);
        }
      }
    });
  });
}
