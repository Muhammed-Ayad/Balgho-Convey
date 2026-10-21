import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/quran/logic/models/surah.dart';

class SurahHeaderWidget extends StatelessWidget {
  final Surah surah;

  const SurahHeaderWidget({
    super.key,
    required this.surah,
  });

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
          colors: [
            primary,
            primary.withValues(alpha: 0.85),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(D.sizeLarge),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            surah.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "UthmanicHafs",
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            surah.englishNameTranslation,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: D.sizeMedium),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: D.sizeMedium,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SurahBadgeItemWidget(
                  label: surah.isMeccan ? "مكية" : "مدنية",
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(width: D.sizeMedium),
                SurahBadgeItemWidget(
                  label: "${surah.ayahCount} آيات",
                  icon: Icons.format_list_numbered_rounded,
                ),
                const SizedBox(width: D.sizeMedium),
                SurahBadgeItemWidget(
                  label: "الجزء ${surah.startingJuz}",
                  icon: Icons.menu_book_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SurahBadgeItemWidget extends StatelessWidget {
  final String label;
  final IconData icon;

  const SurahBadgeItemWidget({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.white,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
