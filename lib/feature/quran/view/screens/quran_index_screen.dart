import 'package:flutter/material.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/feature/quran/logic/models/surah.dart';
import 'package:great_quran/feature/quran/logic/providers/quran_provider.dart';
import 'package:great_quran/feature/quran/view/widgets/continue_reading_card.dart';
import 'package:great_quran/feature/quran/view/widgets/quran_font_size_controls.dart';
import 'package:great_quran/feature/quran/view/widgets/quran_search_field.dart';
import 'package:great_quran/feature/quran/view/widgets/surah_list_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuranIndexScreen extends ConsumerWidget {
  const QuranIndexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(filteredSurahsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: "القرآن الكريم",
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
        ],
      ),
      body: Column(
        children: [
          const ContinueReadingCard(),
          const QuranSearchField(),
          Expanded(
            child: surahsAsync.when(
              data: (surahs) {
                if (surahs.isEmpty) {
                  return const QuranEmptySearchWidget();
                }
                return QuranSurahListView(surahs: surahs);
              },
              loading: () => const QuranLoadingWidget(),
              error: (err, _) => QuranErrorWidget(
                errorMessage: err.toString(),
                onRetry: () => ref.refresh(surahListProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuranSurahListView extends StatelessWidget {
  final List<Surah> surahs;

  const QuranSurahListView({
    super.key,
    required this.surahs,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        bottom: D.sizeXXLarge,
        top: D.sizeSmall,
      ),
      itemCount: surahs.length,
      itemBuilder: (context, index) {
        return SurahListTile(surah: surahs[index]);
      },
    );
  }
}

class QuranEmptySearchWidget extends StatelessWidget {
  const QuranEmptySearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: D.sizeMedium),
          Text(
            "لا توجد نتائج مطابقة للبحث",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class QuranLoadingWidget extends StatelessWidget {
  const QuranLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class QuranErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const QuranErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: D.sizeMedium),
          const Text("تعذر تحميل سور القرآن الكريم"),
          const SizedBox(height: D.sizeMedium),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text("إعادة المحاولة"),
          ),
        ],
      ),
    );
  }
}
