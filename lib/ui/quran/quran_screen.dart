import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/providers/quran_provider.dart';
import 'package:great_quran/helpers/ui_helpers.dart';
import 'package:great_quran/ui/animations/bottom_animation.dart';
import 'package:great_quran/ui/quran/quran_item.dart';
import 'package:great_quran/resources/strings_manager.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';

class QuranScreen extends ConsumerStatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<QuranScreen> createState() => _QuranViewState();
}

class _QuranViewState extends ConsumerState<QuranScreen> {
  @override
  void initState() {
    UiHelper.postBuild((_) {
      ref.read(QuranNotifier.provider.notifier).getQuran();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.quranGreat,
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
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          error: (_) {
            return const Center(
              child: Text('حدث خطأ في البيانات'),
            );
          },
        );
      }),
    );
  }
}
