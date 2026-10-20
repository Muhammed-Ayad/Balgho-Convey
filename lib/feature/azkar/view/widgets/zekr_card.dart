import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:great_quran/core/assets/assets_manager.dart';
import 'package:great_quran/core/helpers/constants.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/azkar/logic/models/azkar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

final zekrCounterProvider =
    StateProvider.autoDispose.family<int, String>((ref, key) {
  return 0;
});

class ZekrCard extends StatelessWidget {
  final Azkar azkar;
  const ZekrCard({
    super.key,
    required this.azkar,
  });

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
                color: context.colorScheme.outline,
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
                color: context.colorScheme.outline,
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
                  onPressed: () async {
                    await FlutterClipboard.copy(azkar.zekr);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(
                            milliseconds: Constants.milliseconds),
                        backgroundColor: context.colorScheme.surface,
                        content: Text(
                          context.l10n.titleCopy,
                          style: context.textTheme.headlineSmall!.copyWith(
                            color: context.colorScheme.onSurface,
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

                        if (currentCount + 1 == zekrCount) {
                          HapticFeedback.vibrate();
                        }
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
                          style: context.textTheme.labelLarge
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
