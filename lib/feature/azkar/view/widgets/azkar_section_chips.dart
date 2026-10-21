import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/azkar/logic/data/azkar_filter.dart';

class AzkarSectionChips extends StatelessWidget {
  final AzkarSection selectedSection;
  final ValueChanged<AzkarSection> onSelect;

  const AzkarSectionChips({
    super.key,
    required this.selectedSection,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: D.sizeMedium),
      child: Row(
        children: AzkarSection.values.map((section) {
          final isSelected = selectedSection == section;
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: ChoiceChip(
              label: Text(section.title),
              selected: isSelected,
              onSelected: (_) => onSelect(section),
              selectedColor: primary,
              backgroundColor: context.colorScheme.surface,
              labelStyle: TextStyle(
                color:
                    isSelected ? Colors.white : context.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? primary : primary.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}
