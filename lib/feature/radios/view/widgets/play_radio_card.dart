import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/radios/logic/providers/audio_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlayRadioCard extends StatelessWidget {
  const PlayRadioCard({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: D.sizeLarge,
      ),
      child: Card(
        elevation: D.sizeXSmall,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(D.sizeXLarge)),
        child: Container(
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withValues(alpha: 0.2),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.primary.withValues(alpha: 0.1),
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(D.sizeXLarge),
            border: Border.all(
              color: context.colorScheme.primary,
              width: D.sizeXXSmall,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(D.sizeSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer(builder: (_, ref, __) {
                  final notifier = ref.watch(AudioNotifier.provider);
                  return IconButton(
                    onPressed: () => notifier.onPressed(url),
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      notifier.isPlaying()
                          ? Icons.stop_circle_outlined
                          : Icons.play_circle_filled,
                      size: context.widthR(0.12),
                      color: context.colorScheme.primary,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
