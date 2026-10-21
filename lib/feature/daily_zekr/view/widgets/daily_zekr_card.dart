import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/constants.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/helpers/ui_helpers.dart';
import 'package:great_quran/core/services/home_widget_sync_service.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/daily_zekr/logic/models/daily_zekr.dart';
import 'package:great_quran/feature/daily_zekr/logic/providers/daily_zekr_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class DailyZekrCard extends ConsumerWidget {
  const DailyZekrCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyItem = ref.watch(dailyZekrProvider);
    final primary = context.colorScheme.primary;

    UiHelper.postBuild((_) {
      ref.read(HomeWidgetSyncService.provider).syncDailyZekr(
            zekr: dailyItem.text,
            fadl: dailyItem.fadl ?? '',
          );
    });

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: D.sizeSmall,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeLarge),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(D.sizeLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DailyZekrHeaderWidget(isHadith: dailyItem.isHadith),
            const SizedBox(height: D.sizeMedium),
            SelectableText(
              dailyItem.text,
              style: context.textTheme.headlineSmall?.copyWith(
                fontSize: 18,
                height: 1.8,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: D.sizeMedium),
            DailyZekrFooterWidget(item: dailyItem),
          ],
        ),
      ),
    );
  }
}

class DailyZekrHeaderWidget extends StatelessWidget {
  final bool isHadith;

  const DailyZekrHeaderWidget({super.key, required this.isHadith});

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isHadith ? Icons.menu_book_rounded : Icons.auto_awesome_rounded,
                color: primary,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isHadith ? "حديث اليوم" : "دعاء اليوم",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: primary,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "متجدد يومياً",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class DailyZekrFooterWidget extends StatelessWidget {
  final DailyZekr item;

  const DailyZekrFooterWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.reference,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              if (item.fadl != null)
                Text(
                  item.fadl!,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.copy_rounded, size: 18, color: primary),
              tooltip: "نسخ",
              onPressed: () async {
                await FlutterClipboard.copy(
                    "${item.text}\n[${item.reference}]");
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(
                      milliseconds: Constants.milliseconds,
                    ),
                    content: Text("تم نسخ النص بنجاح"),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.share_rounded, size: 18, color: primary),
              tooltip: "مشاركة الأجر",
              onPressed: () {
                Share.share(
                  "${item.text}\n[${item.reference}]\nعبر تطبيق بلغوا",
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
