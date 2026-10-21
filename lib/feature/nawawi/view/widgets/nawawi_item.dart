import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/constants.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/nawawi/logic/models/nawawi.dart';
import 'package:great_quran/feature/nawawi/view/widgets/nawawi_explanation_sheet.dart';
import 'package:share_plus/share_plus.dart';

class NawawiItem extends StatelessWidget {
  final Nawawi nawawi;
  final int index;
  final int totalCount;

  const NawawiItem({
    super.key,
    required this.nawawi,
    this.index = 0,
    this.totalCount = 42,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: D.sizeSmall,
      ),
      child: Column(
        children: [
          NawawiItemHeaderWidget(
            title: nawawi.title,
            hadithText: nawawi.hadith,
          ),
          const SizedBox(height: D.sizeSmall),
          Expanded(
            child: NawawiHadithCardWidget(
              hadithText: nawawi.hadith,
            ),
          ),
          const SizedBox(height: D.sizeSmall),
          NawawiExplanationButtonWidget(
            title: nawawi.title,
            description: nawawi.description,
          ),
        ],
      ),
    );
  }
}

class NawawiItemHeaderWidget extends StatelessWidget {
  final String title;
  final String hadithText;

  const NawawiItemHeaderWidget({
    super.key,
    required this.title,
    required this.hadithText,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: D.sizeSmall,
      ),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(D.sizeLarge),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 20),
                tooltip: "نسخ الحديث",
                onPressed: () async {
                  await FlutterClipboard.copy("$title\n\n$hadithText");
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(milliseconds: Constants.milliseconds),
                      content: Text("تم نسخ نص الحديث"),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_rounded, size: 20),
                tooltip: "مشاركة الحديث",
                onPressed: () => Share.share("$title\n\n$hadithText"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NawawiHadithCardWidget extends StatelessWidget {
  final String hadithText;

  const NawawiHadithCardWidget({
    super.key,
    required this.hadithText,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeLarge),
        border: Border.all(
          color: primary.withValues(alpha: 0.18),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(D.sizeLarge),
        child: SelectableText(
          hadithText,
          style: context.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            height: 2.0,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2C3E50),
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}

class NawawiExplanationButtonWidget extends StatelessWidget {
  final String title;
  final String description;

  const NawawiExplanationButtonWidget({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(D.sizeLarge),
          ),
          elevation: 2,
        ),
        icon: const Icon(Icons.menu_book_rounded, size: 20),
        label: const Text(
          "شرح الحديث والفوائد المستفادة",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          NawawiExplanationSheet.show(
            context,
            title: title,
            description: description,
          );
        },
      ),
    );
  }
}
