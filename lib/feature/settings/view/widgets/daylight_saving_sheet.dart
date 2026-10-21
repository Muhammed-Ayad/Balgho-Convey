import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/settings/logic/models/azan_sound_option.dart';
import 'package:great_quran/feature/settings/logic/providers/azan_settings_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DaylightSavingBottomSheet extends ConsumerWidget {
  final DaylightSavingMode selectedMode;

  const DaylightSavingBottomSheet({
    super.key,
    required this.selectedMode,
  });

  static Future<void> show(
      BuildContext context, DaylightSavingMode currentMode) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DaylightSavingBottomSheet(selectedMode: currentMode),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(D.sizeLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.access_time_rounded,
                  color: context.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ضبط التوقيت الصيفي والشتوي",
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "يُطبق التعديل فوراً على مواقيت الصلاة والأذان",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: D.sizeMedium),
          DaylightSavingOptionTile(
            mode: DaylightSavingMode.auto,
            isSelected: selectedMode == DaylightSavingMode.auto,
          ),
          DaylightSavingOptionTile(
            mode: DaylightSavingMode.winter,
            isSelected: selectedMode == DaylightSavingMode.winter,
          ),
          DaylightSavingOptionTile(
            mode: DaylightSavingMode.summer,
            isSelected: selectedMode == DaylightSavingMode.summer,
          ),
          const SizedBox(height: D.sizeSmall),
        ],
      ),
    );
  }
}

class DaylightSavingOptionTile extends ConsumerWidget {
  final DaylightSavingMode mode;
  final bool isSelected;

  const DaylightSavingOptionTile({
    super.key,
    required this.mode,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = context.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color:
            isSelected ? primary.withValues(alpha: 0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(D.sizeMedium),
        border: Border.all(
          color: isSelected ? primary : Colors.grey.withValues(alpha: 0.2),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: ListTile(
        leading: Icon(
          mode == DaylightSavingMode.summer
              ? Icons.wb_sunny_rounded
              : mode == DaylightSavingMode.winter
                  ? Icons.ac_unit_rounded
                  : Icons.brightness_auto_rounded,
          color: isSelected ? primary : Colors.grey.shade500,
        ),
        title: Text(
          mode.title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? primary : null,
          ),
        ),
        subtitle: Text(
          mode.description,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle_rounded, color: primary)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(D.sizeMedium),
        ),
        onTap: () {
          ref
              .read(AzanSettingsNotifier.provider.notifier)
              .setDaylightSavingMode(mode);
          Navigator.pop(context);
        },
      ),
    );
  }
}
