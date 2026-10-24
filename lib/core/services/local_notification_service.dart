import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static final provider = Provider<LocalNotificationService>((ref) {
    return LocalNotificationService();
  });

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool get isInitSuccess => _isInitSuccess;
  bool _isInitSuccess = false;

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
    log('Init notification service');

    try {
      initializeTimeZones();

      String currentTimeZone = 'Africa/Cairo';
      try {
        currentTimeZone = await FlutterTimezone.getLocalTimezone();
      } catch (e) {
        "Failed to get local timezone from platform: $e".log();
      }
      currentTimeZone.log();

      try {
        tz.setLocalLocation(tz.getLocation(currentTimeZone));
      } catch (e) {
        "Failed to set timezone $currentTimeZone, fallback to Africa/Cairo: $e"
            .log();
        try {
          tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
        } catch (_) {
          tz.setLocalLocation(tz.local);
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
          "Notification is pressed".log();
          details.payload.log();
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
      }

      return _isInitSuccess = true;
    } catch (e, s) {
      "Local notification service initialization failed due to:\n$e\n$s".log();
      return _isInitSuccess = false;
    }
  }

  Future<bool> areNotificationsEnabled() async {
    try {
      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final enabled = await androidPlugin.areNotificationsEnabled();
        return enabled ?? true;
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  Future<bool> requestPermissions() async {
    try {
      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final granted =
          await androidPlugin?.requestNotificationsPermission() ?? false;

      try {
        await androidPlugin?.requestExactAlarmsPermission();
      } catch (e) {
        "Request exact alarms permission note: $e".log();
      }

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      return granted;
    } catch (e) {
      "Error requesting notification permissions: $e".log();
      return false;
    }
  }

  Future<void> showInstantNotification({
    int id = 999,
    required String title,
    required String body,
    String? payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails,
      payload: payload,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required DateTime dateTime,
    required String title,
    required String body,
    DateTimeComponents? matchDateTimeComponents,
    String? payload,
  }) async {
    await Future.delayed(const Duration(milliseconds: 10));

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
        "Skipping non-recurring notification #$id in the past: $scheduledDate"
            .log();
        return;
      }
    }

    "Scheduled notification #$id at $scheduledDate (match: $matchDateTimeComponents)"
        .log();

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        _notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: matchDateTimeComponents,
        payload: payload,
      );
    } catch (e) {
      "Exact alarm scheduling failed ($e), falling back to inexact...".log();
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
      } catch (e2) {
        "Fallback notification schedule failed: $e2".log();
      }
    }
  }

  Future<void> schedule({
    int? id,
    required ScheduleReminder scheduleReminder,
    required DateTime dateTime,
    required String title,
    required String body,
    String? payload,
  }) async {
    final notificationId = id ?? (dateTime.hour * 100 + dateTime.minute);
    await scheduleNotification(
      id: notificationId,
      dateTime: dateTime,
      title: title,
      body: body,
      matchDateTimeComponents: scheduleReminder.dateTimeComponents,
      payload: payload,
    );
  }

  Future<void> cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async =>
      await flutterLocalNotificationsPlugin.cancelAll();

  Future<bool> checkPendingNotifications() async {
    final pendingRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    "Has Pending Notifications ? ${pendingRequests.isNotEmpty} (count: ${pendingRequests.length})"
        .log();
    return pendingRequests.isNotEmpty;
  }

  Future<int> getPendingNotificationCount() async {
    final pendingRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingRequests.length;
  }
}

enum ScheduleReminder {
  monthly,
  weekly,
  daily;

  DateTimeComponents get dateTimeComponents {
    switch (this) {
      case ScheduleReminder.monthly:
        return DateTimeComponents.dayOfMonthAndTime;
      case ScheduleReminder.weekly:
        return DateTimeComponents.dayOfWeekAndTime;
      case ScheduleReminder.daily:
        return DateTimeComponents.time;
    }
  }
}
