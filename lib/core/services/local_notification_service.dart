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

      final currentTimeZone = await FlutterTimezone.getLocalTimezone();
      currentTimeZone.log();

      try {
        tz.setLocalLocation(tz.getLocation(currentTimeZone));
      } catch (e) {
        "Failed to set timezone $currentTimeZone, fallback to Africa/Cairo: $e"
            .log();
        tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
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

      // Create Android Notification Channels explicitly
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

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime(
          tz.local,
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
        ),
        _notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: matchDateTimeComponents,
        payload: payload,
      );
    } catch (e) {
      // Fallback to inexact if exact alarm permission failed
      try {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime(
            tz.local,
            dateTime.year,
            dateTime.month,
            dateTime.day,
            dateTime.hour,
            dateTime.minute,
            dateTime.second,
          ),
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
    required ScheduleReminder scheduleReminder,
    required DateTime dateTime,
    required String title,
    required String body,
    String? payload,
  }) async {
    "Schedule notification on $dateTime on a $scheduleReminder".log();

    await Future.delayed(const Duration(milliseconds: 50));
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        DateTime.now().millisecond,
        title,
        body,
        tz.TZDateTime(
          tz.local,
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
        ),
        _notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: scheduleReminder.dateTimeComponents,
        payload: payload,
      );
    } catch (_) {
      try {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          DateTime.now().millisecond,
          title,
          body,
          tz.TZDateTime(
            tz.local,
            dateTime.year,
            dateTime.month,
            dateTime.day,
            dateTime.hour,
            dateTime.minute,
          ),
          _notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: scheduleReminder.dateTimeComponents,
          payload: payload,
        );
      } catch (e2) {
        "Fallback schedule failed: $e2".log();
      }
    }
  }

  Future<void> cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async =>
      await flutterLocalNotificationsPlugin.cancelAll();

  Future<bool> checkPendingNotifications() async {
    final pendingRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    "Has Pending Notifications ? ${pendingRequests.isNotEmpty}".log();
    return pendingRequests.isNotEmpty;
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
