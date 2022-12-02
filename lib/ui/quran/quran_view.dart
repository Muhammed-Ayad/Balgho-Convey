import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/providers/quran_provider.dart';
import 'package:great_quran/helpers/constants.dart';
import 'package:great_quran/ui/animations/bottom_animation.dart';
import 'package:great_quran/ui/quran/quran_item.dart';
import 'package:great_quran/ui/resources/strings_manager.dart';
import 'package:great_quran/ui/widgets/appbar_widget.dart';

class QuranScreen extends ConsumerStatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<QuranScreen> createState() => _QuranViewState();
}

class _QuranViewState extends ConsumerState<QuranScreen> {
  @override
  void initState() {
    ref.read(QuranNotifier.provider.notifier).getQuran();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        AppStrings.quranGreat,
        Constants.elevationAppBarOne,
        context,
      ),
      body: Consumer(builder: (_, ref, __) {
        final state = ref.watch(QuranNotifier.provider);
        return state.when(
          data: (data) {
            return ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return WidgetAnimator(
                  child: QuranItem(
                    surah: data[index],
                    index: index,
                  ),
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
