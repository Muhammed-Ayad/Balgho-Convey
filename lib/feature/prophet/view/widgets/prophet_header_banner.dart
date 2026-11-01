import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class ProphetHeaderBanner extends StatelessWidget {
  const ProphetHeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: D.sizeSmall,
      ),
      padding: const EdgeInsets.all(D.sizeLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            primary,
            const Color(0xFF004D40),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.amberAccent,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "سيد ولد آدم وخاتم النبيين",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: D.sizeSmall),
          const Text(
            "مُحَمَّدٌ رَسُولُ اللَّهِ ﷺ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            "سيرة عطرة، شمائل نبوية شريفة، وأخلاق ربانية سامية موثقة بأصح المصادر من القرآن الكريم وصحيحي البخاري ومسلم والشمائل والرحيق المختوم.",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
