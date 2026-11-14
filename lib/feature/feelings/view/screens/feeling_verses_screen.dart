import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/feature/feelings/logic/models/feeling_item_model.dart';
import 'package:great_quran/feature/feelings/logic/providers/feelings_provider.dart';
import 'package:great_quran/feature/feelings/view/widgets/verse_page_card.dart';
import 'package:great_quran/feature/feelings/view/widgets/verse_progress_indicator_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeelingVersesScreen extends ConsumerStatefulWidget {
  final FeelingItemModel feeling;

  const FeelingVersesScreen({
    super.key,
    required this.feeling,
  });

  @override
  ConsumerState<FeelingVersesScreen> createState() =>
      _FeelingVersesScreenState();
}

class _FeelingVersesScreenState extends ConsumerState<FeelingVersesScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.feeling.title,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: D.sizeMedium),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${_currentPage + 1} / ${widget.feeling.versesCount}",
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: D.sizeMedium),
            VerseProgressIndicatorWidget(
              itemCount: widget.feeling.versesCount,
              currentIndex: _currentPage,
            ),
            const SizedBox(height: D.sizeSmall),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.feeling.versesCount,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  ref
                      .read(feelingAudioNotifierProvider.notifier)
                      .onPageChanged(index);
                },
                itemBuilder: (context, index) {
                  return VersePageCard(
                    verse: widget.feeling.verses[index],
                    index: index,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: D.sizeMedium,
                top: D.sizeSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.swipe_rounded,
                    size: 16,
                    color:
                        context.colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "اسحب يميناً أو يساراً للتنقل بين الآيات",
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          context.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
