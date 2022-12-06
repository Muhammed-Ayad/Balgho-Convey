import 'package:flutter/material.dart';
import 'package:great_quran/blocs/models/quran/ayah.dart';
import 'package:great_quran/blocs/models/quran/surah.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/ui/widgets/ayah_widget.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';

class SurahPage extends StatelessWidget {
  final List<Ayah> ayahList;
  final Surah surah;
  const SurahPage({
    Key? key,
    required this.ayahList,
    required this.surah,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: surah.name.toString().trim(),
      ),
      backgroundColor: AppColors.white,
      body: ListView.builder(
        itemCount: ayahList.length,
        itemBuilder: (context, index) {
          return AyahWidget(
            ayah: ayahList[index],
          );
        },
      ),
    );
  }
}
