import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class AudioArtworkCard extends StatelessWidget {
  final String title;
  final bool isPlaying;

  const AudioArtworkCard({
    super.key,
    required this.title,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: D.sizeLarge,
        vertical: D.sizeMedium,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: D.size3XLarge,
        horizontal: D.sizeLarge,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(D.sizeXLarge),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            primary,
            const Color(0xFF0D5C4E),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
              border: Border.all(
                color: isPlaying
                    ? Colors.greenAccent.withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.3),
                width: 2.5,
              ),
              boxShadow: [
                if (isPlaying)
                  BoxShadow(
                    color: Colors.greenAccent.withValues(alpha: 0.2),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: RadioSoundwaveVisualizerWidget(isPlaying: isPlaying),
          ),
          const SizedBox(height: D.sizeLarge),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: D.sizeSmall),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isPlaying ? Colors.greenAccent : Colors.white70,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isPlaying ? "جارٍ البث المباشر" : "متوقف مؤقتاً",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RadioSoundwaveVisualizerWidget extends StatefulWidget {
  final bool isPlaying;

  const RadioSoundwaveVisualizerWidget({
    super.key,
    required this.isPlaying,
  });

  @override
  State<RadioSoundwaveVisualizerWidget> createState() =>
      _RadioSoundwaveVisualizerWidgetState();
}

class _RadioSoundwaveVisualizerWidgetState
    extends State<RadioSoundwaveVisualizerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant RadioSoundwaveVisualizerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPlaying) {
      return const Center(
        child: Icon(
          Icons.mic_rounded,
          size: 48,
          color: Colors.white,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value * 2 * math.pi;

        final heights = [
          14.0 + 16.0 * math.sin(t).abs(),
          24.0 + 22.0 * math.sin(t + 1.2).abs(),
          36.0 + 18.0 * math.sin(t + 2.4).abs(),
          24.0 + 22.0 * math.sin(t + 3.6).abs(),
          14.0 + 16.0 * math.sin(t + 4.8).abs(),
        ];

        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: heights.map((h) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 4.5,
                height: h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withValues(alpha: 0.7),
                      blurRadius: 6,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
