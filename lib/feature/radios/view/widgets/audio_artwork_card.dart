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
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              isPlaying ? Icons.graphic_eq_rounded : Icons.mic_rounded,
              size: 50,
              color: Colors.white,
            ),
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
                  isPlaying ? "جارٍ التشغيل" : "متوقف مؤقتاً",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
