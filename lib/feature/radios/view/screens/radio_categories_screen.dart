import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/helpers/ui_helpers.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/radios/logic/providers/radios_provider.dart';
import 'package:great_quran/feature/radios/view/widgets/radio_item.dart';
import 'package:great_quran/feature/radios/view/widgets/radio_mini_player_widget.dart';
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
      bottomNavigationBar: const RadioMiniPlayerWidget(),
      body: Consumer(builder: (_, ref, __) {
        final state = ref.watch(RadiosNotifier.provider);
        return state.when(
          data: (data) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: D.sizeSmall),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioItem(
                  title: data[index].title,
                  icon: Icons.podcasts_rounded,
                  onTap: () {
                    context.push(
                      Routes.radiosScreenRoute,
                      extra: {
                        'radioDetalis': data[index].radio,
                        'title': data[index].title,
                      },
                    );
                  },
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
