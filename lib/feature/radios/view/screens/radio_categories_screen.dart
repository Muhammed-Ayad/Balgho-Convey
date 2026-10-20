import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/helpers/ui_helpers.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/widgets/bottom_animation.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/radios/logic/providers/radios_provider.dart';
import 'package:great_quran/feature/radios/view/widgets/radio_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RadioCategoriesScreen extends ConsumerStatefulWidget {
  const RadioCategoriesScreen({super.key});

  @override
  ConsumerState<RadioCategoriesScreen> createState() => _RadiosViewState();
}

class _RadiosViewState extends ConsumerState<RadioCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    UiHelper.postBuild((_) {
      ref.read(RadiosNotifier.provider.notifier).getRadios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.titleRadio,
      ),
      body: Consumer(builder: (_, ref, __) {
        final state = ref.watch(RadiosNotifier.provider);
        return state.when(
          data: (data) {
            return ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return WidgetAnimator(
                  child: RadioItem(
                    title: data[index].title,
                    onTap: () {
                      context.push(
                        Routes.radiosScreenRoute,
                        extra: {
                          'radioDetalis': data[index].radio,
                          'title': data[index].title,
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
          loading: () => const LoadingWidget(),
          error: (err, stack) => CustomErrorWidget(
            errorMsg: err.toString(),
            onRefresh: () {
              UiHelper.postBuild((_) {
                ref.read(RadiosNotifier.provider.notifier).getRadios();
              });
            },
          ),
        );
      }),
    );
  }
}
