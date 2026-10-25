import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class ExactAlarmWarningBanner extends StatelessWidget {
  final VoidCallback onEnableExact;

  const ExactAlarmWarningBanner({
    super.key,
    required this.onEnableExact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: D.sizeMedium),
      padding: const EdgeInsets.all(D.sizeMedium),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber.shade300,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.shade100.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.schedule_rounded,
                  color: Colors.amber.shade900,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "تنبيه: دقة مواقيت الإشعارات محدودة",
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "لم يتم منح إذن 'المنبهات والتذكيرات'. قد تتأخر تنبيهات الصلاة والأذكار بسبب قيود توفير الطاقة في أندرويد. للحصول على الإشعارات في وقتها تماماً:",
            style: TextStyle(
              fontSize: 12.5,
              height: 1.45,
              color: Colors.brown.shade800,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade800,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onPressed: onEnableExact,
              icon: const Icon(Icons.alarm_on_rounded, size: 18),
              label: const Text(
                "تفعيل إذن المنبهات الدقيقة الآن",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
