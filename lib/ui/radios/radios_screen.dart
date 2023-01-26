import 'package:flutter/material.dart';
import 'package:great_quran/blocs/models/radios/radio.dart';

import 'package:great_quran/ui/animations/bottom_animation.dart';
import 'package:great_quran/ui/radios/audio_page.dart';
import 'package:great_quran/ui/radios/radio_item.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioPage(
                      radioDetalis: radioDetalis[index],
                    
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
