import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:great_quran/feature/notifications/logic/models/notification_diagnostics_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  static final provider = Provider<LocalNotificationService>((ref) {
    return _instance;
  });

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool get isInitSuccess => _isInitSuccess;
  bool _isInitSuccess = false;

  String _detectedTimeZone = 'Africa/Cairo';
  String get detectedTimeZone => _detectedTimeZone;

  static const String mainChannelId = 'convey_main_channel';
  static const String mainChannelName = 'تنبيهات تطبيق بلغوا';
  static const String mainChannelDescription =
      'تنبيهات مواقيت الصلاة والأذكار اليومية والسنن النبوية';

  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      mainChannelId,
      mainChannelName,
      channelDescription: mainChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
      channelShowBadge: true,
      category: AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.public,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  Future<bool> init() async {
    debugPrint("LocalNotificationService: Starting initialization...");

    try {
      initializeTimeZones();

      String currentTimeZone = 'Africa/Cairo';
      try {
        currentTimeZone = await FlutterTimezone.getLocalTimezone();
        debugPrint(
            "LocalNotificationService: FlutterTimezone detected: $currentTimeZone");
      } catch (e, s) {
        debugPrint(
            "LocalNotificationService: Failed to get local timezone from platform: $e\n$s");
      }
      _detectedTimeZone = currentTimeZone;

      try {
        tz.setLocalLocation(tz.getLocation(currentTimeZone));
        debugPrint(
            "LocalNotificationService: tz.local successfully set to: $currentTimeZone");
      } catch (e) {
        debugPrint(
            "LocalNotificationService: Failed to set timezone $currentTimeZone, fallback to Africa/Cairo: $e");
        try {
          tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
          _detectedTimeZone = 'Africa/Cairo';
        } catch (_) {
          tz.setLocalLocation(tz.local);
          _detectedTimeZone = tz.local.name;
        }
      }

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint(
              "LocalNotificationService: Notification tapped with payload: ${details.payload}");
        },
      );

      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        const mainChannel = AndroidNotificationChannel(
          mainChannelId,
          mainChannelName,
          description: mainChannelDescription,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        );
        await androidPlugin.createNotificationChannel(mainChannel);
        debugPrint(
            "LocalNotificationService: Notification channel '$mainChannelId' created.");
      }

      _isInitSuccess = true;
      debugPrint("LocalNotificationService: Initialized successfully ✅");
      return true;
    } catch (e, s) {
      debugPrint("LocalNotificationService: Initialization failed ❌: $e\n$s");
      _isInitSuccess = false;
      return false;
    }
  }

  Future<bool> areNotificationsEnabled() async {
    try {
      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final enabled = await androidPlugin.areNotificationsEnabled();
        debugPrint(
            "LocalNotificationService: areNotificationsEnabled = $enabled");
        return enabled ?? true;
      }
      return true;
    } catch (e, s) {
      debugPrint(
          "LocalNotificationService: areNotificationsEnabled error: $e\n$s");
      return true;
    }
  }

  Future<bool> canScheduleExactNotifications() async {
    try {
      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final canExact = await androidPlugin.canScheduleExactNotifications();
        debugPrint(
            "LocalNotificationService: canScheduleExactNotifications = $canExact");
        return canExact ?? false;
      }
      return true;
    } catch (e, s) {
      debugPrint(
          "LocalNotificationService: canScheduleExactNotifications error: $e\n$s");
      return false;
    }
  }

  Future<void> openExactAlarmSettings() async {
    try {
      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        debugPrint(
            "LocalNotificationService: Requesting exact alarms permission from system...");
        await androidPlugin.requestExactAlarmsPermission();
      }
    } catch (e, s) {
      debugPrint(
          "LocalNotificationService: openExactAlarmSettings error: $e\n$s");
    }
  }

  Future<bool> requestPermissions() async {
    try {
      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final granted =
          await androidPlugin?.requestNotificationsPermission() ?? false;
      debugPrint(
          "LocalNotificationService: requestNotificationsPermission result = $granted");

      final canExact = await canScheduleExactNotifications();
      debugPrint(
          "LocalNotificationService: Initial exact alarm allowed = $canExact");

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      return granted;
    } catch (e, s) {
      debugPrint(
          "LocalNotificationService: Error requesting notification permissions: $e\n$s");
      return false;
    }
  }

  Future<NotificationDiagnosticsModel> getDiagnostics() async {
    final areEnabled = await areNotificationsEnabled();
    final canExact = await canScheduleExactNotifications();
    List<PendingNotificationRequest> pending = [];
    try {
      pending =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    } catch (e, s) {
      debugPrint(
          "LocalNotificationService: Error getting pendingNotificationRequests in getDiagnostics: $e\n$s");
    }

    final summaries = pending
        .map((p) => "#${p.id} [${p.title ?? 'No title'}]: ${p.body ?? ''}")
        .toList();

    debugPrint("=== NOTIFICATION DIAGNOSTICS ===");
    debugPrint("Notifications Enabled: $areEnabled");
    debugPrint("Can Schedule Exact Alarms: $canExact");
    debugPrint(
        "Detected Timezone: $_detectedTimeZone (tz.local: ${tz.local.name})");
    debugPrint("Pending Notifications Count: ${pending.length}");
    for (final s in summaries) {
      debugPrint("  - $s");
    }
    debugPrint("===============================");

    return NotificationDiagnosticsModel(
      areNotificationsEnabled: areEnabled,
      canScheduleExact: canExact,
      timezone: _detectedTimeZone,
      pendingCount: pending.length,
      pendingSummaries: summaries,
    );
  }

  Future<void> showInstantNotification({
    int id = 999,
    required String title,
    required String body,
    String? payload,
  }) async {
    debugPrint("LocalNotificationService: showInstantNotification (#$id)");
    try {
      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        _notificationDetails,
        payload: payload,
      );
      debugPrint("LocalNotificationService: Instant notification displayed.");
    } catch (e, s) {
      debugPrint(
          "LocalNotificationService: showInstantNotification failed: $e\n$s");
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required DateTime dateTime,
    required String title,
    required String body,
    DateTimeComponents? matchDateTimeComponents,
    String? payload,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );

    if (scheduledDate.isBefore(now)) {
      if (matchDateTimeComponents == DateTimeComponents.time) {
        while (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }
      } else if (matchDateTimeComponents ==
          DateTimeComponents.dayOfWeekAndTime) {
        while (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 7));
        }
      } else if (matchDateTimeComponents ==
          DateTimeComponents.dayOfMonthAndTime) {
        while (scheduledDate.isBefore(now)) {
          final nextMonth =
              scheduledDate.month == 12 ? 1 : scheduledDate.month + 1;
          final nextYear = scheduledDate.month == 12
              ? scheduledDate.year + 1
              : scheduledDate.year;
          scheduledDate = tz.TZDateTime(
            tz.local,
            nextYear,
            nextMonth,
            scheduledDate.day,
            scheduledDate.hour,
            scheduledDate.minute,
            scheduledDate.second,
          );
        }
      } else {
        debugPrint(
            "LocalNotificationService: Skipping non-recurring notification #$id in past: $scheduledDate");
        return;
      }
    }

    final canExact = await canScheduleExactNotifications();
    final preferredMode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    debugPrint(
        "LocalNotificationService: Scheduling #$id at $scheduledDate (match: $matchDateTimeComponents, mode: $preferredMode)");

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        _notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: preferredMode,
        matchDateTimeComponents: matchDateTimeComponents,
        payload: payload,
      );
      debugPrint(
          "LocalNotificationService: Successfully scheduled #$id at $scheduledDate (mode: $preferredMode)");
    } catch (e, s) {
      debugPrint(
          "LocalNotificationService: Schedule attempt failed for #$id (mode: $preferredMode): $e\n$s");
      if (preferredMode == AndroidScheduleMode.exactAllowWhileIdle) {
        try {
          await flutterLocalNotificationsPlugin.zonedSchedule(
            id,
            title,
            body,
            scheduledDate,
            _notificationDetails,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: matchDateTimeComponents,
            payload: payload,
          );
          debugPrint(
              "LocalNotificationService: Fallback inexact alarm scheduled for #$id");
        } catch (e2, s2) {
          debugPrint(
              "LocalNotificationService: Fallback inexact schedule also failed: $e2\n$s2");
        }
      }
    }
  }

  Future<bool> scheduleTestNotification({int seconds = 15}) async {
    final canExact = await canScheduleExactNotifications();
    debugPrint(
        "LocalNotificationService: scheduleTestNotification ($seconds s) - canExact = $canExact");

    final scheduledTime = DateTime.now().add(Duration(seconds: seconds));
    await scheduleNotification(
      id: 998,
      dateTime: scheduledTime,
      title: "تنبيه مجدول تجريبي ($seconds ثانية) ⏰",
      body: "الحمد لله.. تم إطلاق التنبيه المجدول بنجاح في موعده المحدد!",
      payload: "test_scheduled_${seconds}s",
    );

    try {
      final pending =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      debugPrint(
          "LocalNotificationService: Pending notification count after test schedule: ${pending.length}");
      for (final req in pending) {
        debugPrint("  -> Pending #id: ${req.id}, title: ${req.title}");
      }
    } catch (e, s) {
      debugPrint(
          "LocalNotificationService: Error retrieving pending notifications in scheduleTestNotification: $e\n$s");
    }
    return canExact;
  }

  Future<void> cancel(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch (e, s) {
      debugPrint("LocalNotificationService: Error cancelling #$id: $e\n$s");
    }
  }

  Future<void> cancelAll() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
      debugPrint("LocalNotificationService: cancelAll() called.");
    } catch (e, s) {
      debugPrint("LocalNotificationService: Error cancelling all: $e\n$s");
    }
  }

  Future<int> getPendingNotificationCount() async {
    try {
      final pendingRequests =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      return pendingRequests.length;
    } catch (e, s) {
      debugPrint(
          "LocalNotificationService: Error getting pending count: $e\n$s");
      return 0;
    }
  }
}
