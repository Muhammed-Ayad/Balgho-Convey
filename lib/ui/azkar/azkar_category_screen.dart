import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:great_quran/data/local/json/azkar_by_category.dart';
import 'package:clipboard/clipboard.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'package:great_quran/helpers/constants.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';
import 'package:share_plus/share_plus.dart';

import '../../blocs/models/azkar/azkar.dart';

class AzkarCategoryScreen extends StatefulWidget {
  const AzkarCategoryScreen({Key? key, required this.azkar}) : super(key: key);
  final String azkar;

  @override
  State<AzkarCategoryScreen> createState() => _AzkarCategoryScreenState();
}

class _AzkarCategoryScreenState extends State<AzkarCategoryScreen> {
  AzkarByCategory azkarByCategory = AzkarByCategory();

  @override
  void initState() {
    azkarByCategory.getAzkarByCategory(widget.azkar);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.azkar,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: azkarByCategory.azkarList.map((azkar) {
            return ZekrCard(
              azkar: azkar,
            );
          }).toList(),
        ),
      ),
    );
  }
}

//

final zekrCounterProvider = StateProvider.family<int, String>((ref, key) {
  return 0;
});

class ZekrCard extends StatelessWidget {
  final Azkar azkar;
  const ZekrCard({
    Key? key,
    required this.azkar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(D.sizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                opacity: 0.6,
                fit: BoxFit.fill,
                image: AssetImage(
                  ImageAssets.test1,
                ),
              ),
              borderRadius: BorderRadius.circular(D.sizeMedium),
              border: Border.all(
                color: context.colorScheme.onBackground,
                width: D.sizeXXSmall,
              ),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(D.sizeSmall),
              child: SelectableText(
                azkar.zekr,
                style: context.textTheme.headlineMedium!
                    .copyWith(color: Colors.black),
              ),
            ),
          ),
          Text(
            "عدد مرات التكرار : ${azkar.count}",
            style: TextStyle(color: context.colorScheme.primary, fontSize: 17),
          ),
          Container(
            decoration: BoxDecoration(
              color: context.colorScheme.shadow,
              borderRadius: BorderRadius.circular(
                D.sizeSmall,
              ),
              border: Border.all(
                color: context.colorScheme.onBackground,
                width: D.sizeXXSmall,
              ),
            ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Share.share(azkar.zekr);
                  },
                  icon: Icon(
                    Icons.share,
                    color: context.colorScheme.primary,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    FlutterClipboard.copy(azkar.zekr).then(
                      (value) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration:
                              Duration(milliseconds: Constants.milliseconds),
                          backgroundColor: context.colorScheme.background,
                          content: Text(
                            LocaleKeys.title_copy.tr(),
                            style: context.textTheme.headlineSmall!.copyWith(
                              color: context.colorScheme.surface,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.copy,
                    color: context.colorScheme.primary,
                  ),
                ),
                Consumer(builder: (context, ref, _) {
                  return InkWell(
                    onTap: () {
                      final currentCount =
                          ref.read(zekrCounterProvider(azkar.zekr));
                      final zekrCount = int.tryParse(azkar.count) ?? 0;
                      if (currentCount < zekrCount) {
                        ref
                            .read(zekrCounterProvider(azkar.zekr).notifier)
                            .state++;
                      } else {
                        // Vibrate to alert using with the completion
                        Vibrate.vibrate();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.colorScheme.primary,
                          border: Border.all(color: Colors.white),
                          boxShadow: const [BoxShadow(offset: Offset(0, 0.3))]),
                      width: 50,
                      height: 30,
                      child: Consumer(builder: (context, ref, _) {
                        final count =
                            ref.watch(zekrCounterProvider(azkar.zekr));
                        return Text(
                          count.toString(),
                          textAlign: TextAlign.center,
                          style: context.textTheme.button
                              ?.copyWith(color: Colors.white),
                        );
                      }),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
