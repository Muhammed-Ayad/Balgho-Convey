import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/radios/logic/models/radio.dart';

class RadioStationListWidget extends StatelessWidget {
  final List<RadioDetalis> stations;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  const RadioStationListWidget({
    super.key,
    required this.stations,
    required this.currentIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: D.sizeLarge,
        vertical: D.sizeMedium,
      ),
      padding: const EdgeInsets.all(D.sizeMedium),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeLarge),
        border: Border.all(
          color: primary.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.playlist_play_rounded, color: primary, size: 22),
              const SizedBox(width: D.sizeSmall),
              Text(
                "قائمة الإذاعات والقراء (${stations.length})",
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: D.sizeSmall),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stations.length,
            itemBuilder: (context, index) {
              final isSelected = index == currentIndex;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 3.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(D.sizeSmall),
                ),
                child: ListTile(
                  dense: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(D.sizeSmall),
                  ),
                  onTap: () => onSelect(index),
                  leading: Icon(
                    isSelected ? Icons.volume_up_rounded : Icons.radio_outlined,
                    color: isSelected ? primary : Colors.grey.shade500,
                    size: 20,
                  ),
                  title: Text(
                    stations[index].name,
                    style: TextStyle(
                      color:
                          isSelected ? primary : context.colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  trailing: isSelected
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "يعمل الآن",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
