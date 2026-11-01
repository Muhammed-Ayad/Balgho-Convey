import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/helpers/constants.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/favorites/logic/models/favorite_item.dart';
import 'package:great_quran/feature/radios/logic/models/radio.dart';
import 'package:share_plus/share_plus.dart';

class FavoriteItemCard extends StatelessWidget {
  final FavoriteItem item;
  final VoidCallback onRemove;

  const FavoriteItemCard({
    super.key,
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;
    final isZekr = item.type == FavoriteType.zekr;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: 6.0,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeLarge),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(D.sizeLarge),
        child: InkWell(
          borderRadius: BorderRadius.circular(D.sizeLarge),
          onTap: () {
            if (isZekr) {
              if (item.id.startsWith('category_')) {
                context.push(
                  Routes.azkarCategoryRoute,
                  extra: item.title,
                );
              } else if (item.extraData.isNotEmpty &&
                  !item.id.startsWith('daily_')) {
                context.push(
                  Routes.azkarCategoryRoute,
                  extra: item.extraData,
                );
              }
            } else {
              context.push(
                Routes.audioPageRoute,
                extra: RadioDetalis(item.title, item.content),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(D.sizeMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isZekr
                            ? primary.withValues(alpha: 0.1)
                            : Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isZekr
                                ? Icons.menu_book_rounded
                                : Icons.radio_rounded,
                            size: 14,
                            color: isZekr ? primary : Colors.blue.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.id.startsWith('category_')
                                ? "قسم أذكار"
                                : (isZekr ? "ذكر / دعاء" : "إذاعة قرآن"),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isZekr ? primary : Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if (isZekr) ...[
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 18),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            tooltip: "نسخ",
                            onPressed: () async {
                              await FlutterClipboard.copy(item.content);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(
                                      milliseconds: Constants.milliseconds),
                                  content: Text("تم نسخ الذكر"),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.share_rounded, size: 18),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            tooltip: "مشاركة",
                            onPressed: () => Share.share(item.content),
                          ),
                        ],
                        IconButton(
                          icon: const Icon(Icons.star_rounded,
                              size: 22, color: Colors.amber),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          tooltip: "إزالة من المفضلة",
                          onPressed: onRemove,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: D.sizeSmall),
                Text(
                  item.title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (isZekr && item.content.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.content,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      height: 1.6,
                      color: const Color(0xFF37474F),
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
