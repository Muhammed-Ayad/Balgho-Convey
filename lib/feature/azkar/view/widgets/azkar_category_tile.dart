import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/helpers/constants.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/favorites/logic/models/favorite_item.dart';
import 'package:great_quran/feature/favorites/logic/providers/favorites_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AzkarCategoryTile extends ConsumerWidget {
  final String title;
  final int index;

  const AzkarCategoryTile({
    super.key,
    required this.title,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = context.colorScheme.primary;
    final categoryId = 'category_${title.trim()}';
    final isFav = ref.watch(isFavoriteProvider(categoryId));

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: 5.0,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeMedium),
        border: Border.all(
          color: primary.withValues(alpha: 0.12),
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
        borderRadius: BorderRadius.circular(D.sizeMedium),
        child: InkWell(
          borderRadius: BorderRadius.circular(D.sizeMedium),
          onTap: () {
            context.push(
              Routes.azkarCategoryRoute,
              extra: title.trim(),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: D.sizeMedium,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: D.sizeMedium),
                Expanded(
                  child: Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFav ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 24,
                    color: isFav ? Colors.amber : Colors.grey.shade400,
                  ),
                  tooltip: isFav ? "إزالة من المفضلة" : "إضافة للمفضلة",
                  onPressed: () async {
                    final added = await ref
                        .read(FavoritesNotifier.provider.notifier)
                        .toggleFavorite(
                          FavoriteItem(
                            id: categoryId,
                            title: title.trim(),
                            content: "أذكار وأدعية: ${title.trim()}",
                            extraData: title.trim(),
                            type: FavoriteType.zekr,
                            createdAt: DateTime.now(),
                          ),
                        );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(
                          milliseconds: Constants.milliseconds,
                        ),
                        content: Text(
                          added
                              ? "تمت إضافة \"$title\" للمفضلة ⭐"
                              : "تمت الإزالة من المفضلة",
                        ),
                      ),
                    );
                  },
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: primary.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
