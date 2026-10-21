import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/prophet/logic/providers/prophet_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProphetSearchField extends ConsumerWidget {
  const ProphetSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = context.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: D.sizeMedium),
      child: TextField(
        onChanged: (val) {
          ref.read(ProphetFilterNotifier.provider.notifier).updateSearch(val);
        },
        decoration: InputDecoration(
          hintText: "ابحث في سيرة وشمائل النبي ﷺ...",
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
          ),
          prefixIcon: Icon(Icons.search_rounded, color: primary),
          filled: true,
          fillColor: context.colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: D.sizeMedium,
            vertical: D.sizeSmall,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: primary.withValues(alpha: 0.2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: primary.withValues(alpha: 0.15),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class ProphetCategoryChips extends ConsumerWidget {
  const ProphetCategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(prophetCategoriesProvider);
    final selected = ref.watch(ProphetFilterNotifier.provider).selectedCategory;
    final primary = context.colorScheme.primary;

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: D.sizeMedium),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == selected;

          return FilterChip(
            selected: isSelected,
            label: Text(
              cat,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : primary,
              ),
            ),
            selectedColor: primary,
            backgroundColor: primary.withValues(alpha: 0.06),
            checkmarkColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? primary : primary.withValues(alpha: 0.15),
              ),
            ),
            onSelected: (_) {
              ref
                  .read(ProphetFilterNotifier.provider.notifier)
                  .selectCategory(cat);
            },
          );
        },
      ),
    );
  }
}
