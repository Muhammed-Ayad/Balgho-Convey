import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/constants.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/favorites/logic/models/favorite_item.dart';
import 'package:great_quran/feature/favorites/logic/providers/favorites_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RadioItem extends ConsumerWidget {
  final String title;
  final VoidCallback onTap;
  final IconData icon;
  final String? radioUrl;

  const RadioItem({
    super.key,
    required this.title,
    required this.onTap,
    this.icon = Icons.radio_rounded,
    this.radioUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = context.colorScheme.primary;
    final favId = radioUrl != null ? "radio_${radioUrl.hashCode}" : null;
    final isFav = favId != null ? ref.watch(isFavoriteProvider(favId)) : false;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: 6.0,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeLarge),
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
        borderRadius: BorderRadius.circular(D.sizeLarge),
        child: InkWell(
          borderRadius: BorderRadius.circular(D.sizeLarge),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: D.sizeMedium,
              vertical: D.sizeMedium,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    color: primary,
                    size: 22,
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
                if (favId != null && radioUrl != null) ...[
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.star_rounded : Icons.star_border_rounded,
                      color: isFav ? Colors.amber : Colors.grey.shade400,
                      size: 22,
                    ),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    onPressed: () async {
                      final added = await ref
                          .read(FavoritesNotifier.provider.notifier)
                          .toggleFavorite(
                            FavoriteItem(
                              id: favId,
                              title: title,
                              content: radioUrl!,
                              extraData: title,
                              type: FavoriteType.radio,
                              createdAt: DateTime.now(),
                            ),
                          );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(
                              milliseconds: Constants.milliseconds),
                          content: Text(
                            added
                                ? "تمت إضافة الإذاعة للمفضلة ⭐"
                                : "تمت إزالة الإذاعة من المفضلة",
                          ),
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(width: 4),
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
