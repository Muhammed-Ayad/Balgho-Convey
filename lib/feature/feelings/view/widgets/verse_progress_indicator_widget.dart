import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class VerseProgressIndicatorWidget extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const VerseProgressIndicatorWidget({
    super.key,
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < itemCount; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == currentIndex ? 24 : 8,
            height: 6,
            decoration: BoxDecoration(
              color:
                  i == currentIndex ? primary : primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(D.sizeXXSmall),
            ),
          ),
      ],
    );
  }
}
