import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/feelings/logic/models/feeling_verse_model.dart';
import 'package:great_quran/feature/feelings/logic/providers/feelings_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VerseAudioPlayerBar extends ConsumerWidget {
  final FeelingVerseModel verse;
  final int index;

  const VerseAudioPlayerBar({
    super.key,
    required this.verse,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(feelingAudioNotifierProvider);
    final primary = context.colorScheme.primary;

    final isCurrentVerse = audioState.activeAyahIndex == index;
    final status =
        isCurrentVerse ? audioState.status : VerseAudioStatus.initial;

    final isPlaying = status == VerseAudioStatus.playing;
    final isLoading = status == VerseAudioStatus.loading;
    final isError = status == VerseAudioStatus.error;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: D.sizeSmall,
      ),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(D.sizeLarge),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: isPlaying ? primary : primary.withValues(alpha: 0.12),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () async {
                final notifier =
                    ref.read(feelingAudioNotifierProvider.notifier);
                if (isPlaying) {
                  await notifier.pauseVerse();
                } else {
                  await notifier.playVerse(index, verse.audioUrl);
                  if (ref.read(feelingAudioNotifierProvider).status ==
                      VerseAudioStatus.error) {
                    Fluttertoast.showToast(
                      msg: "تعذر تشغيل التلاوة، يرجى التحقق من اتصال الإنترنت",
                      backgroundColor: Colors.red.shade700,
                      textColor: Colors.white,
                    );
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: isLoading
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(primary),
                        ),
                      )
                    : Icon(
                        isError
                            ? Icons.refresh_rounded
                            : isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                        color: isPlaying ? Colors.white : primary,
                        size: 22,
                      ),
              ),
            ),
          ),
          const SizedBox(width: D.sizeSmall),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isError
                    ? "إعادة المحاولة"
                    : isPlaying
                        ? "تلاوة جارية..."
                        : isLoading
                            ? "جاري التحميل..."
                            : "استمع للتلاوة",
                style: TextStyle(
                  color: isError ? context.colorScheme.error : primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                "بصوت الشيخ محمود خليل الحصري",
                style: TextStyle(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.65),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
