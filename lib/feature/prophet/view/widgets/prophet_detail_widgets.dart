import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/prophet/logic/models/prophet_topic.dart';

class ProphetDetailHeader extends StatelessWidget {
  final ProphetTopic topic;

  const ProphetDetailHeader({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(D.sizeLarge),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              topic.category,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: D.sizeSmall),
          Text(
            topic.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            topic.subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class ProphetKeyPointsCard extends StatelessWidget {
  final List<String> points;

  const ProphetKeyPointsCard({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();
    final primary = context.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(top: D.sizeMedium),
      padding: const EdgeInsets.all(D.sizeMedium),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline_rounded,
                  color: primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                "أبرز النقاط والمحطات",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: D.sizeSmall),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, left: 8),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(fontSize: 13, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProphetContentSection extends StatelessWidget {
  final String content;

  const ProphetContentSection({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(top: D.sizeMedium),
      padding: const EdgeInsets.all(D.sizeLarge),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_stories_rounded, color: primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                "التفاصيل والشرح الموثق",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class ProphetVersesAndHadithsSection extends StatelessWidget {
  final List<String> verses;
  final List<String> hadiths;

  const ProphetVersesAndHadithsSection({
    super.key,
    required this.verses,
    required this.hadiths,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (verses.isNotEmpty) ...[
          const SizedBox(height: D.sizeMedium),
          Container(
            padding: const EdgeInsets.all(D.sizeMedium),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primary.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_book_rounded, color: primary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "شواهد من القرآن الكريم",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: D.sizeSmall),
                ...verses.map(
                  (v) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      v,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (hadiths.isNotEmpty) ...[
          const SizedBox(height: D.sizeMedium),
          Container(
            padding: const EdgeInsets.all(D.sizeMedium),
            decoration: BoxDecoration(
              color: Colors.indigo.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.format_quote_rounded,
                        color: Colors.indigo.shade700, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "من الأحاديث النبوية الصحيحة",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: D.sizeSmall),
                ...hadiths.map(
                  (h) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      h,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class ProphetSourcesCard extends StatelessWidget {
  final List<String> sources;

  const ProphetSourcesCard({super.key, required this.sources});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: D.sizeMedium),
      padding: const EdgeInsets.all(D.sizeMedium),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade700.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified_rounded,
                  color: Colors.amber.shade800, size: 18),
              const SizedBox(width: 8),
              Text(
                "المصادر والمراجع الإسلامية المعتمدة",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: D.sizeSmall),
          ...sources.map(
            (s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Icon(Icons.bookmark_border_rounded,
                      size: 14, color: Colors.amber.shade800),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      s,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
