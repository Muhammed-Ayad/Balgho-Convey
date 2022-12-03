import 'package:flutter/material.dart';
import 'package:great_quran/blocs/models/quran/ayah.dart';
import 'package:great_quran/blocs/models/quran/surah.dart';
import 'package:great_quran/helpers/constants.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/ui/widgets/appbar_widget.dart';

class SurahPage extends StatelessWidget {
  final List<Ayah> ayahList;
  final Surah surah;
  const SurahPage({Key? key, required this.ayahList, required this.surah})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
          surah.name.toString().trim(), Constants.elevationAppBarOne, context),
      backgroundColor: AppColors.white,
      body: ListView.builder(
        itemCount: ayahList.length,
        itemBuilder: (context, index) => buildAyah(
          context.height,
          index,
          context.width,
          context,
        ),
      ),
    );
  }

  Widget buildAyah(double height, int index, double width, context) {
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
                ayahList[index].numberInSurah.toString(),
                style: TextStyle(
                  fontSize: height * 0.013,
                  color: AppColors.blue,
                ),
              )),
        ),
        title: SelectableText(
          ayahList[index].text,
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
