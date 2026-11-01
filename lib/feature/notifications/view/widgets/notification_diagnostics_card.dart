import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/feature/notifications/logic/models/notification_diagnostics_model.dart';
import 'package:great_quran/feature/notifications/logic/providers/notification_settings_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationDiagnosticsCard extends ConsumerStatefulWidget {
  const NotificationDiagnosticsCard({super.key});

  @override
  ConsumerState<NotificationDiagnosticsCard> createState() =>
      _NotificationDiagnosticsCardState();
}

class _NotificationDiagnosticsCardState
    extends ConsumerState<NotificationDiagnosticsCard> {
  bool _isSendingInstant = false;
  bool _isSchedulingTest = false;

  Future<void> _handleInstantTest() async {
    if (_isSendingInstant) return;
    setState(() => _isSendingInstant = true);
    try {
      final notifier = ref.read(NotificationSettingsNotifier.provider.notifier);
      final success = await notifier.sendInstantTestNotification();
      if (!mounted) return;

      if (success) {
        Fluttertoast.showToast(
          msg: "تم إرسال الإشعار الفوري بنجاح! تفقد شريط الإشعارات 🔔",
          backgroundColor: const Color(0xFF00695C),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        Fluttertoast.showToast(
          msg:
              "إذن الإشعارات معطل! يرجى السماح بالإشعارات من إعدادات النظام ⚙️",
          backgroundColor: Colors.red.shade700,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      }
      ref.invalidate(notificationDiagnosticsProvider);
    } catch (e) {
      if (!mounted) return;
      Fluttertoast.showToast(
        msg: "تعذر إرسال الإشعار الفوري: $e",
        backgroundColor: Colors.red.shade700,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _isSendingInstant = false);
    }
  }

  Future<void> _handleScheduled15sTest() async {
    if (_isSchedulingTest) return;
    setState(() => _isSchedulingTest = true);
    try {
      final notifier = ref.read(NotificationSettingsNotifier.provider.notifier);
      final canExact = await notifier.scheduleTestNotification(seconds: 15);
      if (!mounted) return;

      if (canExact) {
        Fluttertoast.showToast(
          msg:
              "تمت جدولة إشعار بعد 15 ثانية بنجاح! انتظر 15 ثانية لتصلك الرسالة ⏰",
          backgroundColor: const Color(0xFF00695C),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        Fluttertoast.showToast(
          msg:
              "تنبيه: إذن المنبهات الدقيقة غير مفعل! تم التوجيه لإعدادات النظام ⚙️",
          backgroundColor: Colors.orange.shade800,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      }
      ref.invalidate(notificationDiagnosticsProvider);
    } catch (e) {
      if (!mounted) return;
      Fluttertoast.showToast(
        msg: "تعذر جدولة الإشعار التجريبي: $e",
        backgroundColor: Colors.red.shade700,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _isSchedulingTest = false);
    }
  }

  Future<void> _handleOpenExactSettings() async {
    final notifier = ref.read(NotificationSettingsNotifier.provider.notifier);
    await notifier.openExactAlarmSettings();
    Fluttertoast.showToast(
      msg: "فعّل خيار 'السماح بتعيين المنبهات والتذكيرات' ثم ارجع للتطبيق.",
      backgroundColor: Colors.blueGrey.shade800,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;
    final diagAsync = ref.watch(notificationDiagnosticsProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: D.sizeMedium),
      padding: const EdgeInsets.all(D.sizeMedium),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primary.withValues(alpha: 0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.analytics_rounded, color: primary, size: 22),
              ),
              const SizedBox(width: D.sizeSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "لوحة التشخيص المباشر للإشعارات",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "بيانات حية ومباشرة من نظام التشغيل",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: "إعادة الفحص المباشر",
                icon: const Icon(Icons.refresh_rounded, size: 20),
                onPressed: () {
                  ref.invalidate(notificationDiagnosticsProvider);
                },
              ),
            ],
          ),
          const SizedBox(height: D.sizeSmall),
          const Divider(height: 1),
          const SizedBox(height: D.sizeSmall),
          diagAsync.when(
            data: (diag) => _DiagnosticsContentWidget(
              diag: diag,
              onOpenExactSettings: _handleOpenExactSettings,
              onInstantTest: _handleInstantTest,
              onScheduled15sTest: _handleScheduled15sTest,
              isSendingInstant: _isSendingInstant,
              isSchedulingTest: _isSchedulingTest,
            ),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
            error: (err, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                "تعذر جلب بيانات التشخيص: $err",
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagnosticsContentWidget extends StatelessWidget {
  final NotificationDiagnosticsModel diag;
  final VoidCallback onOpenExactSettings;
  final VoidCallback onInstantTest;
  final VoidCallback onScheduled15sTest;
  final bool isSendingInstant;
  final bool isSchedulingTest;

  const _DiagnosticsContentWidget({
    required this.diag,
    required this.onOpenExactSettings,
    required this.onInstantTest,
    required this.onScheduled15sTest,
    required this.isSendingInstant,
    required this.isSchedulingTest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DiagnosticsRowItem(
          label: "إذن الإشعارات (Notifications Enabled)",
          value: diag.areNotificationsEnabled
              ? "مُفعّل (Granted) ✅"
              : "معطّل (Denied) ❌",
          isOk: diag.areNotificationsEnabled,
        ),
        const SizedBox(height: 6),
        _DiagnosticsRowItem(
          label: "إذن المنبهات الدقيقة (Exact Alarms)",
          value: diag.canScheduleExact
              ? "مسموح (Allowed) ✅"
              : "غير مسموح (Denied) ❌",
          isOk: diag.canScheduleExact,
        ),
        const SizedBox(height: 6),
        _DiagnosticsRowItem(
          label: "المنطقة الزمنية المكتشفة (Timezone)",
          value: "${diag.timezone} 🌍",
          isOk: true,
        ),
        const SizedBox(height: 6),
        _DiagnosticsRowItem(
          label: "التنبيهات المجدولة في النظام (Pending)",
          value: "${diag.pendingCount} تنبيه مجدول 📋",
          isOk: diag.pendingCount > 0,
        ),
        if (!diag.canScheduleExact) ...[
          const SizedBox(height: D.sizeSmall),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber.shade700, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.amber.shade900, size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "تنبيه هام لنظام Android 14 (Samsung / Oppo)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "النظام يمنع المنبهات الدقيقة افتراضياً. لتصلك تنبيهات الصلوات والأذكار في مواعيدها بالضبط، يلزم تفعيل إذن 'المنبهات والتذكيرات' لهذا التطبيق.",
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: onOpenExactSettings,
                  icon: const Icon(Icons.settings_outlined, size: 16),
                  label: const Text(
                    "تفعيل إذن المنبهات الدقيقة (Alarms & Reminders)",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade800,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: D.sizeMedium),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isSendingInstant ? null : onInstantTest,
                icon: isSendingInstant
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.notifications_active_outlined, size: 16),
                label: const Text(
                  "إشعار فوري",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            const SizedBox(width: D.sizeSmall),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isSchedulingTest ? null : onScheduled15sTest,
                icon: isSchedulingTest
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.timer_outlined, size: 16),
                label: const Text(
                  "مجدول (15 ثانية)",
                  style: TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DiagnosticsRowItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isOk;

  const _DiagnosticsRowItem({
    required this.label,
    required this.value,
    required this.isOk,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isOk
            ? Colors.green.withValues(alpha: 0.05)
            : Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isOk ? Colors.green.shade800 : Colors.red.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
