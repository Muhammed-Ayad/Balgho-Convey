import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/quran/logic/models/ayah.dart';
import 'package:great_quran/feature/quran/logic/models/quran_bookmark.dart';
import 'package:great_quran/feature/quran/logic/models/surah.dart';
import 'package:great_quran/feature/quran/logic/providers/quran_provider.dart';
import 'package:great_quran/feature/quran/logic/repo/quran_repository.dart';
import 'package:great_quran/feature/quran/view/widgets/bismillah_widget.dart';
import 'package:great_quran/feature/quran/view/widgets/continue_reading_card.dart';
import 'package:great_quran/feature/quran/view/widgets/surah_list_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MockQuranBookmarkNotifier extends QuranBookmarkNotifier {
  MockQuranBookmarkNotifier(super.repo, QuranBookmark? initial) {
    state = AsyncValue.data(initial);
  }
}

class LocalTestQuranRepository extends QuranRepository {
  double _fontSize = 24.0;
  QuranBookmark? _bookmark;

  @override
  Future<List<Surah>> getAllSurahs() async {
    final file = File('assets/json/quran.json');
    final jsonString = await file.readAsString();
    final Map<String, dynamic> data = json.decode(jsonString);
    final List<dynamic> surahsJson = data['data']['surahs'] as List<dynamic>;

    return surahsJson
        .map((s) => Surah.fromJson(s as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<double> getFontSize() async => _fontSize;

  @override
  Future<void> saveFontSize(double size) async {
    _fontSize = size;
  }

  @override
  Future<QuranBookmark?> getBookmark() async => _bookmark;

  @override
  Future<void> saveBookmark(QuranBookmark bookmark) async {
    _bookmark = bookmark;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Quran Model & Logic Tests', () {
    test('Ayah cleanDisplayAyah handles Bismillah correctly', () {
      // Surah 1 (Al-Fatiha): Ayah 1 keeps Bismillah
      const fatihaAyah1 = Ayah(
        number: 1,
        text: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        numberInSurah: 1,
        juz: 1,
        manzil: 1,
        page: 1,
        ruku: 1,
        hizbQuarter: 1,
        sajda: false,
      );
      expect(
        fatihaAyah1.cleanDisplayAyah(1),
        'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
      );

      // Surah 2 (Al-Baqarah): Ayah 1 strips Bismillah prefix
      const baqarahAyah1 = Ayah(
        number: 8,
        text: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ الٓمٓ',
        numberInSurah: 1,
        juz: 1,
        manzil: 1,
        page: 2,
        ruku: 1,
        hizbQuarter: 1,
        sajda: false,
      );
      expect(baqarahAyah1.cleanDisplayAyah(2), 'الٓمٓ');

      // Surah 9 (At-Tawbah): Does not strip anything
      const tawbahAyah1 = Ayah(
        number: 1235,
        text: 'بَرَاءَةٌ مِّنَ اللَّهِ وَرَسُولِهِ',
        numberInSurah: 1,
        juz: 10,
        manzil: 2,
        page: 187,
        ruku: 1,
        hizbQuarter: 37,
        sajda: false,
      );
      expect(
        tawbahAyah1.cleanDisplayAyah(9),
        'بَرَاءَةٌ مِّنَ اللَّهِ وَرَسُولِهِ',
      );
    });

    test('QuranBookmark JSON serialization and deserialization', () {
      final bookmark = QuranBookmark(
        surahNumber: 18,
        surahName: 'سورة الكهف',
        ayahNumber: 10,
        updatedAt: DateTime(2026, 10, 21),
      );

      final jsonMap = bookmark.toJson();
      expect(jsonMap['surahNumber'], 18);
      expect(jsonMap['surahName'], 'سورة الكهف');
      expect(jsonMap['ayahNumber'], 10);

      final restored = QuranBookmark.fromJson(jsonMap);
      expect(restored.surahNumber, 18);
      expect(restored.surahName, 'سورة الكهف');
      expect(restored.ayahNumber, 10);
    });

    test(
        'QuranRepository.normalizeArabic removes diacritics and unifies letters',
        () {
      const accented = 'سُورَةُ ٱلْفَاتِحَةِ';
      final normalized = QuranRepository.normalizeArabic(accented);
      expect(normalized, 'سوره الفاتحه');
    });

    test('Loads all 114 Surahs from quran.json accurately', () async {
      final repo = LocalTestQuranRepository();
      final surahs = await repo.getAllSurahs();

      expect(surahs.length, 114);
      expect(surahs.first.number, 1);
      expect(surahs.first.name, 'سُورَةُ ٱلْفَاتِحَةِ');
      expect(surahs.first.ayahCount, 7);
      expect(surahs.first.isMeccan, true);

      expect(surahs.last.number, 114);
      expect(surahs.last.name, 'سُورَةُ النَّاسِ');
      expect(surahs.last.ayahCount, 6);
    });

    test('Search filter matches surahs by name, english name, and number',
        () async {
      final repo = LocalTestQuranRepository();
      final allSurahs = await repo.getAllSurahs();

      final container = ProviderContainer(
        overrides: [
          quranRepositoryProvider.overrideWithValue(repo),
          surahListProvider.overrideWith((ref) => Future.value(allSurahs)),
        ],
      );
      addTearDown(container.dispose);

      await container.read(surahListProvider.future);

      // Search by Surah number "114"
      container.read(quranSearchQueryProvider.notifier).state = '114';
      var filtered = container.read(filteredSurahsProvider).value!;
      expect(filtered.length, 1);
      expect(filtered.first.englishName, 'An-Naas');

      // Search by Arabic name "الكهف"
      container.read(quranSearchQueryProvider.notifier).state = 'الكهف';
      filtered = container.read(filteredSurahsProvider).value!;
      expect(filtered.length, 1);
      expect(filtered.first.number, 18);

      // Search by English name "Yaseen"
      container.read(quranSearchQueryProvider.notifier).state = 'Yaseen';
      filtered = container.read(filteredSurahsProvider).value!;
      expect(filtered.length, 1);
      expect(filtered.first.number, 36);
    });

    test('Font size notifier increases and decreases within bounds', () async {
      final repo = LocalTestQuranRepository();
      final container = ProviderContainer(
        overrides: [
          quranRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(quranFontSizeProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      await notifier.setFontSize(24.0);
      expect(container.read(quranFontSizeProvider), 24.0);

      await notifier.increase();
      expect(container.read(quranFontSizeProvider), 26.0);

      await notifier.decrease();
      expect(container.read(quranFontSizeProvider), 24.0);

      // Clamping test
      await notifier.setFontSize(100.0);
      expect(container.read(quranFontSizeProvider), 42.0);

      await notifier.setFontSize(5.0);
      expect(container.read(quranFontSizeProvider), 16.0);
    });
  });

  group('Quran Widget Tests', () {
    testWidgets('BismillahWidget renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BismillahWidget(),
          ),
        ),
      );

      expect(
          find.text('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ'), findsOneWidget);
    });

    testWidgets('SurahListTile renders surah details', (tester) async {
      const testSurah = Surah(
        number: 1,
        name: 'سُورَةُ ٱلْفَاتِحَةِ',
        englishName: 'Al-Faatiha',
        englishNameTranslation: 'The Opening',
        revelationType: 'Meccan',
        ayahs: [
          Ayah(
            number: 1,
            text: 'test',
            numberInSurah: 1,
            juz: 1,
            manzil: 1,
            page: 1,
            ruku: 1,
            hizbQuarter: 1,
            sajda: false,
          ),
        ],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SurahListTile(surah: testSurah),
          ),
        ),
      );

      expect(find.text('سُورَةُ ٱلْفَاتِحَةِ'), findsOneWidget);
      expect(find.text('Al-Faatiha'), findsOneWidget);
      expect(find.text('مكية'), findsOneWidget);
      expect(find.text('1 آيات'), findsOneWidget);
    });

    testWidgets('ContinueReadingCard renders bookmark if present',
        (tester) async {
      final bookmark = QuranBookmark(
        surahNumber: 2,
        surahName: 'سورة البقرة',
        ayahNumber: 255,
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            quranBookmarkProvider.overrideWith(
              (ref) => MockQuranBookmarkNotifier(QuranRepository(), bookmark),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ContinueReadingCard(),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('آخر قراءة محفوظـة'), findsOneWidget);
      expect(find.text('سورة البقرة • آية 255'), findsOneWidget);
    });
  });
}
