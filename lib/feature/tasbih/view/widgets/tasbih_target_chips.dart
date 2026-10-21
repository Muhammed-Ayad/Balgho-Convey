import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/feature/tasbih/logic/providers/tasbih_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TasbihTargetChipsWidget extends ConsumerWidget {
  final int currentTarget;

  const TasbihTargetChipsWidget({
    super.key,
    required this.currentTarget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const targets = [33, 100, 0];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: targets.map((target) {
        final isSelected = currentTarget == target;
        final label = target == 0 ? "مفتوح" : "$target";

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: ChoiceChip(
            label: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : null,
              ),
            ),
            selected: isSelected,
            selectedColor: context.colorScheme.primary,
            onSelected: (_) {
              ref.read(tasbihProvider.notifier).setTarget(target);
            },
          ),
        );
      }).toList(),
    );
  }
}
