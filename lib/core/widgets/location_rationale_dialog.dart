import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class LocationRationaleDialog extends StatelessWidget {
  final VoidCallback onAllow;
  final VoidCallback? onCancel;

  const LocationRationaleDialog({
    super.key,
    required this.onAllow,
    this.onCancel,
  });

  static Future<bool?> show(
    BuildContext context, {
    required VoidCallback onAllow,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => LocationRationaleDialog(
        onAllow: () {
          Navigator.of(ctx).pop(true);
          onAllow();
        },
        onCancel: () {
          Navigator.of(ctx).pop(false);
          onCancel?.call();
        },
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
                color: primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: primary,
                size: 38,
              ),
            ),
            const SizedBox(height: D.sizeMedium),
            Text(
              "تحديد الموقع الجغرافي",
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: D.sizeSmall),
            Text(
              "يحتاج تطبيق بلغوا إذن تحديد موقعك الحالي لغرضين أساسيين:",
              style: TextStyle(
                fontSize: 13,
                color: context.colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: D.sizeMedium),
            const LocationFeatureItem(
              icon: Icons.access_time_filled_rounded,
              title: "مواقيت الصلاة الدقيقة",
              subtitle: "لحساب أوقات الأذان الصحيحة لمدينتك بدقة فلكية",
            ),
            const SizedBox(height: 8),
            const LocationFeatureItem(
              icon: Icons.explore_rounded,
              title: "اتجاه القبلة",
              subtitle: "لتوجيه بوصلة القبلة مباشرة نحو الكعبة المشرفة",
            ),
            const SizedBox(height: D.sizeLarge),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: onAllow,
                child: const Text(
                  "السماح بالوصول للموقع",
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
                  "لاحقاً (استخدام الموقع الافتراضي)",
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

class LocationFeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const LocationFeatureItem({
    super.key,
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
