import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class ExactAlarmRationaleDialog extends StatelessWidget {
  final VoidCallback onAllow;
  final VoidCallback onCancel;

  const ExactAlarmRationaleDialog({
    super.key,
    required this.onAllow,
    required this.onCancel,
  });

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => ExactAlarmRationaleDialog(
        onAllow: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 6,
      backgroundColor: context.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(D.sizeLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.alarm_on_rounded,
                color: Colors.amber,
                size: 38,
              ),
            ),
            const SizedBox(height: D.sizeMedium),
            Text(
              "تفعيل التنبيهات الدقيقة في موعدها",
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: D.sizeSmall),
            Text(
              "في نظام أندرويد الحديث، يحتاج التطبيق إلى إذن 'المنبهات والتذكيرات' (Alarms & Reminders) حتى تعمل تنبيهات مواقيت الصلاة والأذكار في موعدها بدقة متناهية ودون تأخير من نظام توفير الطاقة.",
              style: TextStyle(
                fontSize: 13,
                color: context.colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: D.sizeMedium),
            const _RationalePointItem(
              icon: Icons.mosque_rounded,
              title: "أذان ومواقيت الصلوات الخمس",
              subtitle: "التنبيه فور دخول وقت الصلاة بدقة بالثانية",
            ),
            const SizedBox(height: 8),
            const _RationalePointItem(
              icon: Icons.wb_sunny_rounded,
              title: "أذكار الصباح والمساء والسنن",
              subtitle: "التذكير بأوراد اليوم والليلة في أوقاتها المحددة",
            ),
            const SizedBox(height: D.sizeLarge),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: onAllow,
                icon: const Icon(Icons.settings_outlined, size: 18),
                label: const Text(
                  "تفعيل الآن (فتح إعدادات الهاتف)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: TextButton(
                onPressed: onCancel,
                child: Text(
                  "لاحقاً (الوضع العادي)",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RationalePointItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _RationalePointItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
