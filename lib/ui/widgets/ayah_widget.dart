import 'package:flutter/material.dart';
import 'package:great_quran/blocs/models/quran/ayah.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/colors.dart';

class AyahWidget extends StatelessWidget {
  const AyahWidget({
    super.key,
    required this.ayah,
  });

  final Ayah ayah;
  @override
  Widget build(BuildContext context) {
    final double height = context.height;
    final double width = context.width;
    return Padding(
      padding: EdgeInsets.fromLTRB(width * 0.015, 0, 0, 0),
      child: ListTile(
        leading: CircleAvatar(
          radius: height * 0.013,
          backgroundColor: AppColors.darkDlue,
          child: CircleAvatar(
              radius: height * 0.012,
              backgroundColor: AppColors.white,
              child: Text(
                ayah.numberInSurah.toString(),
                style: TextStyle(
                  fontSize: height * 0.013,
                  color: AppColors.blue,
                ),
              )),
        ),
        title: SelectableText(
          ayah.text,
          textAlign: TextAlign.right,
          style: context.textTheme.displayLarge,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}
