import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/radios/logic/providers/audio_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RadioMiniPlayerWidget extends ConsumerWidget {
  const RadioMiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(AudioNotifier.provider);
    final currentRadio = notifier.currentRadio;

    if (currentRadio == null || (!notifier.isPlaying && !notifier.isLoading)) {
      return const SizedBox.shrink();
    }

    final primary = context.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.all(D.sizeSmall),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primary.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push(
              Routes.audioPageRoute,
              extra: {
                'radioList': notifier.playlist,
                'initialIndex': notifier.currentIndex,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: D.sizeMedium,
              vertical: D.sizeSmall,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    notifier.isPlaying
                        ? Icons.graphic_eq_rounded
                        : Icons.radio_rounded,
                    color: primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: D.sizeSmall),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentRadio.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notifier.isLoading
                                ? "جارِ التحميل..."
                                : "بث حي مباشر",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous_rounded),
                  iconSize: 22,
                  color: primary,
                  tooltip: "المحطة السابقة",
                  onPressed: () {
                    ref.read(AudioNotifier.provider).playPrevious();
                  },
                ),
                IconButton(
                  icon: notifier.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          notifier.isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded,
                        ),
                  iconSize: 34,
                  color: primary,
                  tooltip: notifier.isPlaying ? "إيقاف مؤقت" : "تشغيل",
                  onPressed: () {
                    ref.read(AudioNotifier.provider).togglePlayPause();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded),
                  iconSize: 22,
                  color: primary,
                  tooltip: "المحطة التالية",
                  onPressed: () {
                    ref.read(AudioNotifier.provider).playNext();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
