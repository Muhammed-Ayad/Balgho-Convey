import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/helpers/ui_helpers.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/nawawi/logic/providers/nawawi_provider.dart';
import 'package:great_quran/feature/nawawi/view/widgets/nawawi_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _changePageProvider = StateProvider.autoDispose<int>((ref) => 0);

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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
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
                              } else if (ref.read(_changePageProvider) == 0) {
                                Navigator.pop(context);
                              }
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: context.colorScheme.primary,
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
                              color: context.colorScheme.primary,
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
            loading: () => const LoadingWidget(),
            error: (err, stack) => CustomErrorWidget(
              errorMsg: err.toString(),
              onRefresh: () {
                UiHelper.postBuild((_) {
                  ref.read(NawawiNotifier.provider.notifier).getNawawi();
                });
              },
            ),
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
