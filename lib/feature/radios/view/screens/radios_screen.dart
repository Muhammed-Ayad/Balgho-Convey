import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/widgets/bottom_animation.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/feature/radios/logic/models/radio.dart';
import 'package:great_quran/feature/radios/view/widgets/radio_item.dart';

class RadiosScreen extends StatelessWidget {
  const RadiosScreen({
    super.key,
    required this.radioDetalis,
    required this.title,
  });

  final List<RadioDetalis> radioDetalis;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
      ),
      body: ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: radioDetalis.length,
        itemBuilder: (BuildContext context, int index) {
          return WidgetAnimator(
            child: RadioItem(
              title: radioDetalis[index].name,
              onTap: () {
                context.push(
                  Routes.audioPageRoute,
                  extra: radioDetalis[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
