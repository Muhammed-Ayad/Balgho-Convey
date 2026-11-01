import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class MorningEveningAzkarSectionWidget extends StatelessWidget {
  const MorningEveningAzkarSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: D.sizeMedium),
      child: Row(
        children: [
          Expanded(
            child: MorningAzkarCardWidget(),
          ),
          SizedBox(width: D.sizeMedium),
          Expanded(
            child: EveningAzkarCardWidget(),
          ),
        ],
      ),
    );
  }
}

class MorningAzkarCardWidget extends StatelessWidget {
  const MorningAzkarCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AzkarTimeCard(
      title: "أذكار الصباح",
      subtitle: "ابدأ يومك بذكر الله",
      icon: Icons.wb_sunny_rounded,
      gradientColors: const [
        Color(0xFFF39C12),
        Color(0xFFE67E22),
      ],
      onTap: () {
        context.push(
          Routes.azkarCategoryRoute,
          extra: "أذكار الصباح",
        );
      },
    );
  }
}

class EveningAzkarCardWidget extends StatelessWidget {
  const EveningAzkarCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AzkarTimeCard(
      title: "أذكار المساء",
      subtitle: "حصن ليلتك ويومك",
      icon: Icons.nightlight_round,
      gradientColors: const [
        Color(0xFF2C3E50),
        Color(0xFF1A252F),
      ],
      onTap: () {
        context.push(
          Routes.azkarCategoryRoute,
          extra: "أذكار المساء",
        );
      },
    );
  }
}

class AzkarTimeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const AzkarTimeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(D.sizeLarge),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(D.sizeLarge),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: D.sizeMedium,
              vertical: D.sizeLarge,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: D.sizeMedium),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
