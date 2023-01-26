import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/providers/nawawi_provider.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/helpers/ui_helpers.dart';
import 'package:great_quran/ui/nawawi/nawawi_item.dart';
import 'package:great_quran/ui/widgets/error_widget.dart';
import 'package:great_quran/ui/widgets/loading_widget.dart';

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
                              color: context.colorScheme.background,
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
                              color: context.colorScheme.background,
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
            error: (_) => const ErrorWidgetApp(),
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
