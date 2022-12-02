import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/providers/nawawi_provider.dart';
import 'package:great_quran/helpers/constants.dart';
import 'package:great_quran/helpers/ui_helpers.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/ui/nawawi/nawawi_item.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Consumer(builder: (_, ref, __) {
          final state = ref.watch(NawawiNotifier.provider);
          return state.when(
            data: (data) {
              return CarouselSlider(
                items: data.map((nawawi) {
                  return NawawiItem(
                    nawawi: nawawi,
                  );
                }).toList(),
                options: CarouselOptions(
                  scrollPhysics: const ScrollPhysics(),
                  height: double.infinity,
                  autoPlay: false,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  initialPage: Constants.initialPage,
                  aspectRatio: D.sizeXXSmall,
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            error: (_) {
              return const Center(
                child: Text('Error'),
              );
            },
          );
        }),
      ),
    );
  }
}