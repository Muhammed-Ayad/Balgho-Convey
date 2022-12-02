import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/providers/nawawi_provider.dart';
import 'package:great_quran/helpers/constants.dart';
import 'package:great_quran/ui/nawawi/nawawi_item.dart';
import 'package:great_quran/ui/resources/color_manager.dart';
import 'package:great_quran/ui/resources/values_manager.dart';

class NawawiView extends StatelessWidget {
  const NawawiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.white,
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
                  viewportFraction: AppSize.s0_9,
                  initialPage: Constants.initialPage,
                  aspectRatio: AppSize.s2,
                ),
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
      ),
    );
  }
}
