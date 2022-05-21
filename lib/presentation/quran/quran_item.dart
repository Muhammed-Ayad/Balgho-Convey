import 'package:flutter/material.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';
import 'surah_page.dart';

import '../../data/models/quran/surah.dart';

class QuranItem extends StatelessWidget {
  final Surah surah;
  final int index;
  const QuranItem({
    Key? key,
    required this.surah,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurahPage(
              ayahList: surah.ayah,
              surah: surah,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: AppSize.s24,
            backgroundImage: const AssetImage(
              ImageAssets.startwo,
            ),
            backgroundColor: Colors.transparent,
            child: Text(
              surah.number.toString(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          title: Text(
            surah.name,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      ),
    );
  }
}
