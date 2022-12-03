import 'package:flutter/material.dart';
import 'package:great_quran/blocs/models/quran/surah.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/dimensions.dart';

import 'package:great_quran/ui/quran/surah_page.dart';
import 'package:great_quran/resources/assets_manager.dart';

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
              ayahList: surah.ayahs,
              surah: surah,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: D.sizeXXLarge,
            backgroundImage: const AssetImage(
              ImageAssets.starTwo,
            ),
            backgroundColor: Colors.transparent,
            child: Text(
              surah.number.toString(),
              style: context.textTheme.bodyLarge,
            ),
          ),
          title: Text(
            surah.name,
            style: context.textTheme.displayLarge,
          ),
        ),
      ),
    );
  }
}
