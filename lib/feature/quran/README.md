# Quran Feature Package

## Overview
Provides full offline reading of the Noble Quran rendered in the authentic Uthmanic Hafs script. Features an index of all 114 Surahs, normalized Arabic search, last-read bookmarking, font size controls, and Ayah-level sharing.

## Interface
- `[lib/feature/quran/logic/models/surah.dart:Surah]` - Model representing a Quranic chapter with number, name, english name, revelation type, and ayah list.
- `[lib/feature/quran/logic/models/ayah.dart:Ayah]` - Model representing a single verse with ayah number, text, and page references.
- `[lib/feature/quran/logic/models/quran_bookmark.dart:QuranBookmark]` - Model saving last read surah, ayah, and timestamp.
- `[lib/feature/quran/logic/repo/quran_repository.dart:QuranRepository]` - Repository reading `assets/json/quran.json` and managing bookmark persistence.
- `[lib/feature/quran/logic/providers/quran_provider.dart:quranRepositoryProvider]` - Riverpod provider exposing `QuranRepository`.
- `[lib/feature/quran/logic/providers/quran_provider.dart:surahListProvider]` - FutureProvider caching the complete list of 114 Surahs.
- `[lib/feature/quran/logic/providers/quran_provider.dart:filteredSurahsProvider]` - Provider computing Surahs matching number or text query.
- `[lib/feature/quran/logic/providers/quran_provider.dart:QuranBookmarkNotifier]` - StateNotifier persisting and retrieving the user's reading position.
- `[lib/feature/quran/logic/providers/quran_provider.dart:quranFontSizeProvider]` - StateProvider controlling reading typography font size.
- `[lib/feature/quran/view/screens/quran_index_screen.dart:QuranIndexScreen]` - Index screen listing Surahs with search and resume card.
- `[lib/feature/quran/view/screens/surah_detail_screen.dart:SurahDetailScreen]` - Reader screen rendering verses, bismillah header, and font sizing controls.
- `[lib/feature/quran/view/widgets/ayah_item_widget.dart:AyahItemWidget]` - Verse widget with ayah bookmarking and action sheet.
- `[lib/feature/quran/view/widgets/continue_reading_card.dart:ContinueReadingCard]` - Quick card navigating directly to saved reading position.
- `[lib/feature/quran/view/widgets/quran_font_size_controls.dart:QuranFontSizeControls]` - Slider / buttons modifying Arabic font size.

## Invariants
- `[lib/feature/quran/logic/repo/quran_repository.dart:QuranRepository.normalizeArabic]` strips diacritics (tashkeel), hamzas, and tatweel to ensure reliable substring matching.
- Quran text is completely bundled offline; zero internet access is required.

## Side Effects
- Reads and writes bookmark JSON in `SharedPreferences` key `quran_last_read_bookmark`.
- Dispatches native share dialogs and clipboard copies for individual ayahs.

## Verification
- Run: `flutter test test/quran_test.dart`
