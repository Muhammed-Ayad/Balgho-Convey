import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/quran/logic/models/ayah.dart';
import 'package:great_quran/feature/quran/logic/models/surah.dart';
import 'package:great_quran/feature/quran/logic/providers/quran_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class AyahItemWidget extends ConsumerWidget {
  final Ayah ayah;
  final Surah surah;
  final bool isBookmarked;

  const AyahItemWidget({
    super.key,
    required this.ayah,
    required this.surah,
    this.isBookmarked = false,
  });

  static String toArabicDigits(int number) {
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number.toString().split('').map((c) => digits[int.parse(c)]).join();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize = ref.watch(quranFontSizeProvider);
    final primary = context.colorScheme.primary;
    final cleanedText = ayah.cleanDisplayAyah(surah.number);
    final verseMarker = ' ﴿${toArabicDigits(ayah.numberInSurah)}﴾';

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: 4,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: D.sizeSmall,
      ),
      decoration: BoxDecoration(
        color: isBookmarked
            ? primary.withValues(alpha: 0.08)
            : context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeMedium),
        border: Border.all(
          color: isBookmarked ? primary : primary.withValues(alpha: 0.08),
          width: isBookmarked ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "آية ${ayah.numberInSurah}",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ),
                  if (ayah.hasSajda) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "سجدة تلاوة",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isBookmarked ? primary : Colors.grey,
                      size: 20,
                    ),
                    tooltip: isBookmarked ? "العلامة الحالية" : "حفظ كعلامة",
                    onPressed: () {
                      ref.read(quranBookmarkProvider.notifier).saveBookmark(
                            surahNumber: surah.number,
                            surahName: surah.name,
                            ayahNumber: ayah.numberInSurah,
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "تم حفظ العلامة: ${surah.name} آية ${ayah.numberInSurah}",
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.copy_rounded,
                      color: Colors.grey,
                      size: 18,
                    ),
                    tooltip: "نسخ الآية",
                    onPressed: () {
                      final textToCopy =
                          "$cleanedText $verseMarker\n[${surah.name}: ${ayah.numberInSurah}]";
                      Clipboard.setData(ClipboardData(text: textToCopy));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("تم نسخ الآية بنجاح"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.share_outlined,
                      color: Colors.grey,
                      size: 18,
                    ),
                    tooltip: "مشاركة الآية",
                    onPressed: () {
                      final textToShare =
                          "$cleanedText $verseMarker\n[${surah.name}: ${ayah.numberInSurah}]\nمن تطبيق بلغوا";
                      Share.share(
                        textToShare,
                        subject: surah.name,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          RichText(
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: cleanedText,
                  style: TextStyle(
                    fontFamily: "UthmanicHafs",
                    fontSize: fontSize,
                    height: 2.1,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                TextSpan(
                  text: verseMarker,
                  style: TextStyle(
                    fontFamily: "UthmanicHafs",
                    fontSize: fontSize * 0.9,
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
