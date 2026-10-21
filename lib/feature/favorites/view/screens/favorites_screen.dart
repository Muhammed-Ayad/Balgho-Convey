import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/favorites/logic/models/favorite_item.dart';
import 'package:great_quran/feature/favorites/logic/providers/favorites_provider.dart';
import 'package:great_quran/feature/favorites/view/widgets/favorite_item_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _favoriteTabProvider = StateProvider.autoDispose<int>((ref) => 0);

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(FavoritesNotifier.provider);
    final activeTab = ref.watch(_favoriteTabProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "المفضلة والأذكار المحفوظة",
      ),
      body: Column(
        children: [
          FavoritesFilterBarWidget(
            activeTab: activeTab,
            onSelectTab: (idx) {
              ref.read(_favoriteTabProvider.notifier).state = idx;
            },
          ),
          Expanded(
            child: state.when(
              data: (list) {
                final filtered = _filterItems(list, activeTab);

                if (filtered.isEmpty) {
                  return const FavoritesEmptyWidget();
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: D.sizeLarge),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return FavoriteItemCard(
                      item: item,
                      onRemove: () {
                        ref
                            .read(FavoritesNotifier.provider.notifier)
                            .removeFavorite(item.id);
                      },
                    );
                  },
                );
              },
              loading: () => const LoadingWidget(),
              error: (err, stack) => CustomErrorWidget(
                errorMsg: err.toString(),
                onRefresh: () {
                  ref
                      .read(FavoritesNotifier.provider.notifier)
                      .fetchFavorites();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FavoriteItem> _filterItems(List<FavoriteItem> all, int tabIndex) {
    if (tabIndex == 1) {
      return all.where((it) => it.type == FavoriteType.zekr).toList();
    } else if (tabIndex == 2) {
      return all.where((it) => it.type == FavoriteType.radio).toList();
    }
    return all;
  }
}

class FavoritesFilterBarWidget extends StatelessWidget {
  final int activeTab;
  final ValueChanged<int> onSelectTab;

  const FavoritesFilterBarWidget({
    super.key,
    required this.activeTab,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;
    const tabs = ["الكل", "الأذكار والأدعية", "الإذاعات"];

    return Container(
      margin: const EdgeInsets.all(D.sizeMedium),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = activeTab == index;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => onSelectTab(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : context.colorScheme.onSurface,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class FavoritesEmptyWidget extends StatelessWidget {
  const FavoritesEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(D.sizeLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_outline_rounded,
              size: 72,
              color: Colors.amber.shade300,
            ),
            const SizedBox(height: D.sizeMedium),
            Text(
              "لا توجد عناصر مفضلة بعد",
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: D.sizeSmall),
            Text(
              "اضغط على أيقونة النجمة ⭐ بجانب أي ذكر أو إذاعة لإضافتها هنا والوصول إليها بسرعة",
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
