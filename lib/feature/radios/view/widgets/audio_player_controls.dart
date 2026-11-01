import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/radios/logic/providers/audio_notifier.dart';

class AudioPlayerControls extends StatelessWidget {
  final AudioNotifier notifier;

  const AudioPlayerControls({
    super.key,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;
    final totalCount = notifier.totalCount;
    final currentIndex = notifier.currentIndex;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: D.sizeLarge),
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeLarge,
        vertical: D.sizeLarge,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeXLarge),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (totalCount > 1) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "إذاعة ${currentIndex + 1} من $totalCount",
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: D.sizeMedium),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RadioNavigationButton(
                icon: Icons.skip_previous_rounded,
                tooltip: "الإذاعة السابقة",
                isEnabled: notifier.hasPrevious,
                onPressed: notifier.hasPrevious ? notifier.playPrevious : null,
              ),
              RadioPlayPauseButton(
                isPlaying: notifier.isPlaying,
                isLoading: notifier.isLoading,
                onPressed: notifier.togglePlayPause,
              ),
              RadioNavigationButton(
                icon: Icons.skip_next_rounded,
                tooltip: "الإذاعة التالية",
                isEnabled: notifier.hasNext,
                onPressed: notifier.hasNext ? notifier.playNext : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RadioNavigationButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const RadioNavigationButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isEnabled
            ? primary.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
      ),
      child: IconButton(
        icon: Icon(icon),
        iconSize: 34,
        color: isEnabled ? primary : Colors.grey.shade400,
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}

class RadioPlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onPressed;

  const RadioPlayPauseButton({
    super.key,
    required this.isPlaying,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primary,
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.4),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: IconButton(
        iconSize: 38,
        color: Colors.white,
        tooltip: isPlaying ? "إيقاف البث" : "تشغيل البث",
        icon: isLoading
            ? const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2.8,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(
                isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
              ),
        onPressed: onPressed,
      ),
    );
  }
}
