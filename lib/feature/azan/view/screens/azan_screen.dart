import 'package:flutter/material.dart';
import 'package:great_quran/core/assets/assets_manager.dart';
import 'package:great_quran/core/helpers/ui_helpers.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/azan/logic/providers/azan_provider.dart';
import 'package:great_quran/feature/azan/view/widgets/azan_item.dart';
import 'package:great_quran/feature/azan/view/widgets/header_azan.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AzanScreen extends ConsumerStatefulWidget {
  const AzanScreen({super.key});

  @override
  ConsumerState<AzanScreen> createState() => _AzanScreenState();
}

class _AzanScreenState extends ConsumerState<AzanScreen> {
  @override
  void initState() {
    super.initState();
    UiHelper.postBuild((_) {
      ref.read(AzanTimeNotifier.provider.notifier).getAzan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(builder: (_, ref, __) {
          final state = ref.watch(AzanTimeNotifier.provider);
          return state.when(
            data: (data) {
              return Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(D.size3XLarge),
                              bottomLeft: Radius.circular(D.size3XLarge),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(ImageAssets.azanTwo),
                            ),
                          ),
                        ),
                        HeaderAzan(data),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: AzanItem(
                      data: data,
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
                  ref.read(AzanTimeNotifier.provider.notifier).getAzan();
                });
              },
            ),
          );
        }),
      ),
    );
  }
}
