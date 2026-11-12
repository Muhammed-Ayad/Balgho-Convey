import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class VerseContextWidget extends StatelessWidget {
  final String contextText;
  final List<String> tags;

  const VerseContextWidget({
    super.key,
    required this.contextText,
    this.tags = const [],
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: D.sizeSmall,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: primary.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.auto_stories_outlined,
                size: 16,
                color: primary.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  contextText,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        context.colorScheme.onSurface.withValues(alpha: 0.75),
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        fontSize: 11,
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
