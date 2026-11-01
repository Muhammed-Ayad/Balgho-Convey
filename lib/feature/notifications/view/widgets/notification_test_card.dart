import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class NotificationTestCard extends StatefulWidget {
  final Future<bool> Function() onSendTest;

  const NotificationTestCard({
    super.key,
    required this.onSendTest,
  });

  @override
  State<NotificationTestCard> createState() => _NotificationTestCardState();
}

class _NotificationTestCardState extends State<NotificationTestCard> {
  bool _isLoading = false;

  Future<void> _handleSend() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await widget.onSendTest();
      if (!mounted) return;

      if (success) {
        Fluttertoast.showToast(
          msg: "تم إرسال إشعار تجريبي بنجاح! تفقد شريط التنبيهات 🔔",
          backgroundColor: const Color(0xFF00695C),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        Fluttertoast.showToast(
          msg:
              "إذن التنبيهات معطل! يرجى السماح بالإشعارات من إعدادات الجهاز ⚙️",
          backgroundColor: Colors.red.shade700,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      if (!mounted) return;
      Fluttertoast.showToast(
        msg: "تعذر إرسال الإشعار: $e",
        backgroundColor: Colors.red.shade700,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
            onPressed: _isLoading ? null : _handleSend,
            icon: _isLoading
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.notifications_outlined, size: 16),
            label: Text(
              _isLoading ? "جارِ الإرسال..." : "إرسال الآن",
              style: const TextStyle(fontSize: 12),
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
