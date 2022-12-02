import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/providers/radios_provider.dart';
import 'package:great_quran/helpers/constants.dart';
import 'package:great_quran/ui/animations/bottom_animation.dart';
import 'package:great_quran/ui/radios/radio_item.dart';
import 'package:great_quran/ui/resources/strings_manager.dart';
import 'package:great_quran/ui/widgets/appbar_widget.dart';

class RadiosScreen extends ConsumerStatefulWidget {
  const RadiosScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RadiosScreen> createState() => _RadiosViewState();
}

class _RadiosViewState extends ConsumerState<RadiosScreen> {
  @override
  void initState() {
    ref.read(RadiosNotifier.provider.notifier).getRadios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        AppStrings.radio,
        Constants.elevationAppBarOne,
        context,
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
          loading: () => const CircularProgressIndicator.adaptive(),
          error: (_) {
            return const Center(
              child: Text('Error'),
            );
          },
        );
      }),
    );
  }
}
