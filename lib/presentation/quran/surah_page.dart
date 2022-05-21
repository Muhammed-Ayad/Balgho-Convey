import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
import '../widgets/appbar_widget.dart';

import '../../data/models/quran/ayah.dart';
import '../../data/models/quran/surah.dart';

class SurahPage extends StatelessWidget {
  final List<Ayah> ayahList;
  final Surah surah;
  const SurahPage({Key? key, required this.ayahList, required this.surah})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBarWidget(
          surah.name.toString().trim(), Constants.elevationAppBarOne, context),
      backgroundColor: ColorManager.white,
      body: ListView.builder(
        itemCount: ayahList.length,
        itemBuilder: (context, index) =>
            buildAyah(height, index, width, context),
      ),
    );
  }

  Widget buildAyah(double height, int index, double width, context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        width * AppSize.s0_015,
        AppSize.s0,
        AppSize.s0,
        AppSize.s0,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: height * AppSize.s0_013,
          backgroundColor: ColorManager.darkDlue,
          child: CircleAvatar(
              radius: height * AppSize.s0_012,
              backgroundColor: ColorManager.white,
              child: Text(
                ayahList[index].numberInSurah.toString(),
                style: TextStyle(
                  fontSize: height * AppSize.s0_013,
                  color: ColorManager.blue,
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
