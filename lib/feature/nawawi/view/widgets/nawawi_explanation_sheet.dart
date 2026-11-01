import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/constants.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:share_plus/share_plus.dart';

class NawawiExplanationSheet extends StatelessWidget {
  final String title;
  final String description;

  const NawawiExplanationSheet({
    super.key,
    required this.title,
    required this.description,
  });

  static void show(BuildContext context,
      {required String title, required String description}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NawawiExplanationSheet(
        title: title,
        description: description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      height: context.height * 0.75,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(D.sizeLarge),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: D.sizeLarge,
              vertical: D.sizeSmall,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "شرح: $title",
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 20),
                      tooltip: "نسخ الشرح",
                      onPressed: () async {
                        await FlutterClipboard.copy(description);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration:
                                Duration(milliseconds: Constants.milliseconds),
                            content: Text("تم نسخ شرح الحديث"),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_rounded, size: 20),
                      tooltip: "مشاركة الشرح",
                      onPressed: () =>
                          Share.share("شرح $title:\n\n$description"),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(D.sizeLarge),
              child: SelectableText(
                description,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  height: 1.8,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
