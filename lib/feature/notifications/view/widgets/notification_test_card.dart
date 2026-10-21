import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class NotificationTestCard extends StatelessWidget {
  final VoidCallback onSendTest;

  const NotificationTestCard({
    super.key,
    required this.onSendTest,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: D.sizeMedium),
      padding: const EdgeInsets.all(D.sizeMedium),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.send_rounded,
            color: primary,
            size: 24,
          ),
          const SizedBox(width: D.sizeSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "تجربة الإشعارات الفورية",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "أرسل إشعاراً تجريبياً لهاتفك للتأكد من وصول التنبيهات",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              onSendTest();
              Fluttertoast.showToast(
                msg: "تم إرسال إشعار تجريبي بنجاح! تفقد شريط التنبيهات",
                backgroundColor: primary,
                textColor: Colors.white,
                toastLength: Toast.LENGTH_SHORT,
              );
            },
            icon: const Icon(Icons.notifications_outlined, size: 16),
            label: const Text(
              "إرسال الآن",
              style: TextStyle(fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
