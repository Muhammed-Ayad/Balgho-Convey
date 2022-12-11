import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/providers/radios_provider.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/helpers/ui_helpers.dart';
import 'package:great_quran/ui/animations/bottom_animation.dart';
import 'package:great_quran/ui/radios/radio_item.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';
import 'package:great_quran/ui/widgets/error_widget.dart';
import 'package:great_quran/ui/widgets/loading_widget.dart';

class RadiosScreen extends ConsumerStatefulWidget {
  const RadiosScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RadiosScreen> createState() => _RadiosViewState();
}

class _RadiosViewState extends ConsumerState<RadiosScreen> {
  @override
  void initState() {
    UiHelper.postBuild((_) {
      ref.read(RadiosNotifier.provider.notifier).getRadios();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.title_radio.tr(),
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
                  child: RadioItem(radios: data[index]),
                );
              },
            );
          },
          loading: () => const LoadingWidget(),
          error: (_) => const ErrorWidgetApp(),
        );
      }),
    );
  }
}
