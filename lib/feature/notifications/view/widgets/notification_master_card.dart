import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class NotificationMasterCard extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const NotificationMasterCard({
    super.key,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: D.sizeMedium),
      padding: const EdgeInsets.all(D.sizeMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEnabled
              ? [
                  primary.withValues(alpha: 0.12),
                  primary.withValues(alpha: 0.05),
                ]
              : [
                  Colors.grey.withValues(alpha: 0.08),
                  Colors.grey.withValues(alpha: 0.03),
                ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEnabled
              ? primary.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isEnabled ? primary : Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isEnabled
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_off_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: D.sizeMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "تفعيل كافة الإشعارات",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isEnabled
                      ? "التنبيهات مفعلة لجميع الصلوات والأذكار والسنن"
                      : "تم إيقاف كافة التنبيهات في التطبيق",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
