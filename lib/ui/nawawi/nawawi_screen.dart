import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/providers/nawawi_provider.dart';
import 'package:great_quran/helpers/ui_helpers.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/ui/nawawi/nawawi_item.dart';

final _changePageProvider = StateProvider.autoDispose<int>((ref) => 0);

class NawawiScreen extends ConsumerStatefulWidget {
  const NawawiScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NawawiScreen> createState() => _NawawiScreenState();
}

class _NawawiScreenState extends ConsumerState<NawawiScreen> {
  @override
  void initState() {
    UiHelper.postBuild((_) {
      ref.read(NawawiNotifier.provider.notifier).getNawawi();
    });
    super.initState();
  }

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Consumer(builder: (_, ref, __) {
          final state = ref.watch(NawawiNotifier.provider);
          return state.when(
            data: (data) {
              return Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (ref.read(_changePageProvider) > 0) {
                                _pageController.animateToPage(
                                  --ref
                                      .read(_changePageProvider.notifier)
                                      .state,
                                  duration: const Duration(microseconds: 250),
                                  curve: Curves.bounceInOut,
                                );
                              }
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: AppColors.brown,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _pageController.animateToPage(
                                ++ref.read(_changePageProvider.notifier).state,
                                duration: const Duration(microseconds: 250),
                                curve: Curves.bounceInOut,
                              );
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: AppColors.brown,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return NawawiItem(
                          nawawi: data[index],
                        );
                      },
                      controller: _pageController,
                      onPageChanged: (index) {
                        ref.watch(_changePageProvider.notifier).state = index;
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            error: (_) {
              return const Center(
                child: Text('Error'),
              );
            },
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
