import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../helpers/constants.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
import 'nawawi_item.dart';

class NawawiView extends StatelessWidget {
  const NawawiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.white,
        body: FutureBuilder(
          future:
              DefaultAssetBundle.of(context).loadString(Constants.nawawiJson),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final List<dynamic> data = json.decode(snapshot.data.toString());
              return CarouselSlider(
                items: data.map((nawawi) {
                  return NawawiItem(
                    hadith: nawawi[Constants.hadith],
                    description: nawawi[Constants.description],
                    title: nawawi[Constants.title],
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
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
