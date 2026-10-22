import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class NotificationCategoryContainer extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isCategoryEnabled;
  final ValueChanged<bool>? onCategoryToggle;
  final List<Widget> children;

  const NotificationCategoryContainer({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.isCategoryEnabled,
    this.onCategoryToggle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: D.sizeMedium),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primary.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: D.sizeMedium,
              vertical: D.sizeSmall,
            ),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: primary, size: 22),
                ),
                const SizedBox(width: D.sizeSmall),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (onCategoryToggle != null)
                  Switch(
                    value: isCategoryEnabled,
                    onChanged: onCategoryToggle,
                  ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isCategoryEnabled ? 1.0 : 0.45,
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
