import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/feelings/logic/models/feeling_item_model.dart';

class FeelingGridCard extends StatelessWidget {
  final FeelingItemModel feeling;

  const FeelingGridCard({
    super.key,
    required this.feeling,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeLarge),
        border: Border.all(
          color: primary.withValues(alpha: 0.12),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(D.sizeLarge),
          onTap: () {
            context.push(Routes.feelingVersesRoute, extra: feeling);
          },
          child: Padding(
            padding: const EdgeInsets.all(D.sizeMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(
                    feeling.icon,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.spa_rounded,
                      color: primary,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: D.sizeSmall),
                Text(
                  feeling.title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${feeling.versesCount} آيات",
                    style: TextStyle(
                      color: primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
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
