import 'package:great_quran/feature/quran/logic/models/quran_bookmark.dart';
import 'package:great_quran/feature/quran/logic/models/surah.dart';
import 'package:great_quran/feature/quran/logic/repo/quran_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  return QuranRepository();
});

final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getAllSurahs();
});

final quranSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredSurahsProvider = Provider<AsyncValue<List<Surah>>>((ref) {
  final surahsAsync = ref.watch(surahListProvider);
  final query = ref.watch(quranSearchQueryProvider).trim();

  return surahsAsync.whenData((surahs) {
    if (query.isEmpty) return surahs;

    final normalizedQuery =
        QuranRepository.normalizeArabic(query).toLowerCase();
    final queryNumber = int.tryParse(query);

    return surahs.where((surah) {
      if (queryNumber != null && surah.number == queryNumber) {
        return true;
      }
      final normalizedSurahName = QuranRepository.normalizeArabic(surah.name);
      final englishMatch =
          surah.englishName.toLowerCase().contains(normalizedQuery);
      return normalizedSurahName.contains(normalizedQuery) || englishMatch;
    }).toList();
  });
});

class QuranBookmarkNotifier extends StateNotifier<AsyncValue<QuranBookmark?>> {
  final QuranRepository _repo;

  QuranBookmarkNotifier(this._repo) : super(const AsyncValue.loading()) {
    loadBookmark();
  }

  Future<void> loadBookmark() async {
    try {
      final bookmark = await _repo.getBookmark();
      state = AsyncValue.data(bookmark);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveBookmark({
    required int surahNumber,
    required String surahName,
    required int ayahNumber,
  }) async {
    final bookmark = QuranBookmark(
      surahNumber: surahNumber,
      surahName: surahName,
      ayahNumber: ayahNumber,
      updatedAt: DateTime.now(),
    );
    await _repo.saveBookmark(bookmark);
    state = AsyncValue.data(bookmark);
  }
}

final quranBookmarkProvider =
    StateNotifierProvider<QuranBookmarkNotifier, AsyncValue<QuranBookmark?>>(
        (ref) {
  final repo = ref.watch(quranRepositoryProvider);
  return QuranBookmarkNotifier(repo);
});

class QuranFontSizeNotifier extends StateNotifier<double> {
  final QuranRepository _repo;

  QuranFontSizeNotifier(this._repo) : super(24.0) {
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    final size = await _repo.getFontSize();
    state = size;
  }

  Future<void> setFontSize(double size) async {
    final clamped = size.clamp(16.0, 42.0);
    state = clamped;
    await _repo.saveFontSize(clamped);
  }

  Future<void> increase() async {
    await setFontSize(state + 2.0);
  }

  Future<void> decrease() async {
    await setFontSize(state - 2.0);
  }
}

final quranFontSizeProvider =
    StateNotifierProvider<QuranFontSizeNotifier, double>((ref) {
  final repo = ref.watch(quranRepositoryProvider);
  return QuranFontSizeNotifier(repo);
});
