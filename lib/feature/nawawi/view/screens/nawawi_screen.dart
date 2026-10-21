import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/helpers/ui_helpers.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/nawawi/logic/providers/nawawi_provider.dart';
import 'package:great_quran/feature/nawawi/view/widgets/nawawi_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _currentPageProvider = StateProvider.autoDispose<int>((ref) => 0);

class NawawiScreen extends ConsumerStatefulWidget {
  const NawawiScreen({super.key});

  @override
  ConsumerState<NawawiScreen> createState() => _NawawiScreenState();
}

class _NawawiScreenState extends ConsumerState<NawawiScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    UiHelper.postBuild((_) {
      ref.read(NawawiNotifier.provider.notifier).getNawawi();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousPage() {
    final current = ref.read(_currentPageProvider);
    if (current > 0) {
      _pageController.animateToPage(
        current - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage(int total) {
    final current = ref.read(_currentPageProvider);
    if (current < total - 1) {
      _pageController.animateToPage(
        current + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(NawawiNotifier.provider);
    final currentPage = ref.watch(_currentPageProvider);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: const CustomAppBar(
        title: "الأربعون النووية",
      ),
      body: state.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text("لا توجد أحاديث متاحة"));
          }

          return Column(
            children: [
              NawawiPageNavigatorWidget(
                currentPage: currentPage,
                totalCount: data.length,
                onPrevious: _goToPreviousPage,
                onNext: () => _goToNextPage(data.length),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: data.length,
                  onPageChanged: (index) {
                    ref.read(_currentPageProvider.notifier).state = index;
                  },
                  itemBuilder: (context, index) {
                    return NawawiItem(
                      nawawi: data[index],
                      index: index,
                      totalCount: data.length,
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const LoadingWidget(),
        error: (err, stack) => CustomErrorWidget(
          errorMsg: err.toString(),
          onRefresh: () {
            ref.read(NawawiNotifier.provider.notifier).getNawawi();
          },
        ),
      ),
    );
  }
}

class NawawiPageNavigatorWidget extends StatelessWidget {
  final int currentPage;
  final int totalCount;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const NawawiPageNavigatorWidget({
    super.key,
    required this.currentPage,
    required this.totalCount,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;
    final hasPrevious = currentPage > 0;
    final hasNext = currentPage < totalCount - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: hasPrevious ? onPrevious : null,
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: hasPrevious ? primary : Colors.grey.shade400,
              size: 20,
            ),
            tooltip: "الحديث السابق",
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "الحديث ${currentPage + 1} من $totalCount",
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          IconButton(
            onPressed: hasNext ? onNext : null,
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: hasNext ? primary : Colors.grey.shade400,
              size: 20,
            ),
            tooltip: "الحديث التالي",
          ),
        ],
      ),
    );
  }
}
