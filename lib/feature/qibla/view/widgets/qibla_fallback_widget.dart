import 'package:flutter/material.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/qibla/view/widgets/qibla_compass_dial.dart';

class QiblaNoSensorFallbackWidget extends StatelessWidget {
  final double qiblaDirection;

  const QiblaNoSensorFallbackWidget({
    super.key,
    required this.qiblaDirection,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          horizontal: D.sizeLarge, vertical: D.sizeMedium),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(D.sizeMedium),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.cyanAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.cyanAccent,
                  size: 24,
                ),
                const SizedBox(width: D.sizeSmall),
                Expanded(
                  child: Text(
                    "المستشعر المغناطيسي غير متوفر أو يحتاج لمعايرة. تم احتساب زاوية القبلة لموقعك بدقة.",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: D.sizeLarge),
          QiblaCompassDial(
            heading: 0,
            qiblaDirection: qiblaDirection,
            isAligned: false,
          ),
          const SizedBox(height: D.sizeLarge),
          Text(
            "${qiblaDirection.round()}°",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 44,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "الاتجاه التقريبي للقبلة في",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "موقعك الحالي ${qiblaDirection.round()}°",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
