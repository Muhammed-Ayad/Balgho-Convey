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

  final NotificationDetails _platformChannelSpecificsNotificationDetails =
      const NotificationDetails(
          android: AndroidNotificationDetails("Enigma", "Local Notification"),
          iOS: DarwinNotificationDetails());

  Future<bool> init() async {
    log('Init notification service');

    try {
      initializeTimeZones();

      final currentTimeZone = await FlutterTimezone.getLocalTimezone();
      currentTimeZone.log();

      tz.setLocalLocation(tz.getLocation(currentTimeZone));

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');

      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings();

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

      return _isInitSuccess = true;
    } catch (e, s) {
      "Local notification service initialization failed due to:\n$e\n$s";
      return _isInitSuccess = false;
    }
  }

  Future<void> schedule(
      {required ScheduleReminder scheduleReminder,
      required DateTime dateTime,
      required String title,
      required String body,
      String? payload}) async {
    "Schedule notification on $dateTime on a $scheduleReminder".log();

    await Future.delayed(const Duration(milliseconds: 50));
    flutterLocalNotificationsPlugin.zonedSchedule(
      DateTime.now().millisecond,
      title,
      body,
      tz.TZDateTime(
        tz.local,
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
      ),
      _platformChannelSpecificsNotificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: scheduleReminder.dateTimeComponents,
      payload: payload,
    );
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
