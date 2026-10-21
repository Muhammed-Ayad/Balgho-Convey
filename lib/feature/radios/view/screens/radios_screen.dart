import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/feature/radios/logic/models/radio.dart';
import 'package:great_quran/feature/radios/view/widgets/radio_item.dart';
import 'package:great_quran/feature/radios/view/widgets/radio_mini_player_widget.dart';

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
      bottomNavigationBar: const RadioMiniPlayerWidget(),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: D.sizeSmall),
        itemCount: radioDetalis.length,
        itemBuilder: (BuildContext context, int index) {
          return RadioItem(
            title: radioDetalis[index].name,
            icon: Icons.record_voice_over_rounded,
            radioUrl: radioDetalis[index].url,
            onTap: () {
              context.push(
                Routes.audioPageRoute,
                extra: {
                  'radioList': radioDetalis,
                  'initialIndex': index,
                },
              );
            },
          );
        },
      ),
    );
  }
}
