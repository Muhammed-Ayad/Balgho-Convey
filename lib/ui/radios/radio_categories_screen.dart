import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/providers/radios_provider.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/helpers/ui_helpers.dart';
import 'package:great_quran/ui/animations/bottom_animation.dart';
import 'package:great_quran/ui/radios/radio_item.dart';
import 'package:great_quran/ui/radios/radios_screen.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';
import 'package:great_quran/ui/widgets/error_widget.dart';
import 'package:great_quran/ui/widgets/loading_widget.dart';

class RadioCategoriesScreen extends ConsumerStatefulWidget {
  const RadioCategoriesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RadioCategoriesScreen> createState() => _RadiosViewState();
}

class _RadiosViewState extends ConsumerState<RadioCategoriesScreen> {
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
                  child: RadioItem(
                    title: data[index].title,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RadiosScreen(
                              radioDetalis: data[index].radio,
                              title: data[index].title),
                        ),
                      );
                    },
                  ),
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
