import 'package:flutter/material.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class FeelingDisclaimerWidget extends StatelessWidget {
  final String disclaimer;

  const FeelingDisclaimerWidget({
    super.key,
    required this.disclaimer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: D.sizeSmall / 2,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeMedium,
        vertical: D.sizeSmall,
      ),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.health_and_safety_outlined,
            size: 20,
            color: Colors.amber,
          ),
          const SizedBox(width: D.sizeSmall),
          Expanded(
            child: Text(
              disclaimer,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.amber.shade200
                    : Colors.amber.shade900,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
