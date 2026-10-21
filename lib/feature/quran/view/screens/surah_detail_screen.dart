import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/feature/quran/logic/models/ayah.dart';
import 'package:great_quran/feature/quran/logic/models/surah.dart';
import 'package:great_quran/feature/quran/logic/providers/quran_provider.dart';
import 'package:great_quran/feature/quran/view/widgets/ayah_item_widget.dart';
import 'package:great_quran/feature/quran/view/widgets/bismillah_widget.dart';
import 'package:great_quran/feature/quran/view/widgets/quran_font_size_controls.dart';
import 'package:great_quran/feature/quran/view/widgets/surah_header_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SurahDetailScreen extends ConsumerStatefulWidget {
  final int surahNumber;
  final int? initialAyahNumber;

  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    this.initialAyahNumber,
  });

  @override
  ConsumerState<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends ConsumerState<SurahDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surahsAsync = ref.watch(surahListProvider);
    final bookmarkAsync = ref.watch(quranBookmarkProvider);

    return surahsAsync.when(
      data: (surahs) {
        final surah = surahs.firstWhere(
          (s) => s.number == widget.surahNumber,
          orElse: () => surahs.first,
        );

        final currentBookmark = bookmarkAsync.asData?.value;
        final isSurahBookmarked = currentBookmark != null &&
            currentBookmark.surahNumber == surah.number;
        final bookmarkedAyah =
            isSurahBookmarked ? currentBookmark.ayahNumber : null;

        return Scaffold(
          appBar: CustomAppBar(
            title: surah.name,
            actions: [
              IconButton(
                icon: const Icon(Icons.format_size_rounded),
                tooltip: "حجم الخط",
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(D.sizeLarge),
                      ),
                    ),
                    builder: (_) => const QuranFontSizeBottomSheet(),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  isSurahBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: isSurahBookmarked ? context.colorScheme.primary : null,
                ),
                tooltip: "حفظ علامة القراءة",
                onPressed: () {
                  ref.read(quranBookmarkProvider.notifier).saveBookmark(
                        surahNumber: surah.number,
                        surahName: surah.name,
                        ayahNumber: 1,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("تم حفظ علامة القراءة: ${surah.name}"),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SurahContentListView(
            scrollController: _scrollController,
            surah: surah,
            bookmarkedAyah: bookmarkedAyah,
          ),
        );
      },
      loading: () => const Scaffold(
        appBar: CustomAppBar(title: "القرآن الكريم"),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: const CustomAppBar(title: "خطأ"),
        body: Center(child: Text("خطأ في التحميل: $err")),
      ),
    );
  }
}

class SurahContentListView extends StatelessWidget {
  final ScrollController scrollController;
  final Surah surah;
  final int? bookmarkedAyah;

  const SurahContentListView({
    super.key,
    required this.scrollController,
    required this.surah,
    this.bookmarkedAyah,
  });

  @override
  Widget build(BuildContext context) {
    final showBismillah = surah.number != 1 && surah.number != 9;
    final int headerCount = 1 + (showBismillah ? 1 : 0);
    final int totalCount = headerCount + surah.ayahs.length;

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.only(bottom: D.sizeXXLarge),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurahHeaderWidget(surah: surah);
        }
        if (showBismillah && index == 1) {
          return const BismillahWidget();
        }

        final ayahIndex = index - headerCount;
        final Ayah ayah = surah.ayahs[ayahIndex];
        final isAyahBookmarked = bookmarkedAyah == ayah.numberInSurah;

        return AyahItemWidget(
          ayah: ayah,
          surah: surah,
          isBookmarked: isAyahBookmarked,
        );
      },
    );
  }
}
