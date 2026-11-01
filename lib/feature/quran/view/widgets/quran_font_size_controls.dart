import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/quran/logic/providers/quran_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuranFontSizeBottomSheet extends ConsumerWidget {
  const QuranFontSizeBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize = ref.watch(quranFontSizeProvider);
    final primary = context.colorScheme.primary;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + D.sizeLarge,
        left: D.sizeLarge,
        right: D.sizeLarge,
        top: D.sizeMedium,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: D.sizeMedium),
          Text(
            "حجم خط المصحف",
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: D.sizeLarge),
          Container(
            padding: const EdgeInsets.all(D.sizeMedium),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(D.sizeMedium),
              border: Border.all(
                color: primary.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ﴿١﴾",
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: "UthmanicHafs",
                fontSize: fontSize,
                height: 1.8,
              ),
            ),
          ),
          const SizedBox(height: D.sizeLarge),
          Row(
            children: [
              IconButton.filledTonal(
                icon: const Icon(Icons.remove),
                tooltip: "تصغير",
                onPressed: () {
                  ref.read(quranFontSizeProvider.notifier).decrease();
                },
              ),
              Expanded(
                child: Slider(
                  value: fontSize,
                  min: 16.0,
                  max: 40.0,
                  divisions: 12,
                  label: fontSize.toStringAsFixed(0),
                  onChanged: (val) {
                    ref.read(quranFontSizeProvider.notifier).setFontSize(val);
                  },
                ),
              ),
              IconButton.filledTonal(
                icon: const Icon(Icons.add),
                tooltip: "تكبير",
                onPressed: () {
                  ref.read(quranFontSizeProvider.notifier).increase();
                },
              ),
            ],
          ),
          const SizedBox(height: D.sizeSmall),
          TextButton(
            onPressed: () {
              ref.read(quranFontSizeProvider.notifier).setFontSize(24.0);
            },
            child: const Text("استعادة الحجم الافتراضي"),
          ),
        ],
      ),
    );
  }
}
