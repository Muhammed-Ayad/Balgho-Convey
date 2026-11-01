import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/tasbih/logic/models/tasbih_item.dart';
import 'package:great_quran/feature/tasbih/logic/providers/tasbih_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TasbihActiveZekrCardWidget extends StatelessWidget {
  final TasbihItem item;
  final VoidCallback onTap;

  const TasbihActiveZekrCardWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: D.sizeLarge),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(D.sizeLarge),
        border: Border.all(
          color: primary.withValues(alpha: 0.25),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(D.sizeLarge),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(D.sizeLarge),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primary,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: primary,
                      size: 24,
                    ),
                  ],
                ),
                if (item.fadl != null && item.fadl!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.fadl!,
                    style: context.textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
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

class TasbihZekrListModal extends ConsumerWidget {
  final List<TasbihItem> items;
  final int activeIndex;

  const TasbihZekrListModal({
    super.key,
    required this.items,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = context.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: D.sizeLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: D.sizeLarge),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "اختر الذكر والتسبيح",
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = activeIndex == index;

                return ListTile(
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? primary : null,
                    ),
                  ),
                  subtitle: item.fadl != null
                      ? Text(
                          item.fadl!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        )
                      : null,
                  trailing: isSelected
                      ? Icon(Icons.check_circle_rounded, color: primary)
                      : Text(
                          "المجموع: ${item.totalCount}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                  onTap: () {
                    ref.read(tasbihProvider.notifier).selectZekr(index);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
