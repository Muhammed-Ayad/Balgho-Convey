import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:great_quran/core/services/local_notification_service.dart';
import 'package:great_quran/feature/azkar/logic/data/all_azkar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationsSubscriptionNotifier
    extends StateNotifier<AsyncValue<bool>> {
  static final provider = StateNotifierProvider<
      NotificationsSubscriptionNotifier, AsyncValue<bool>>((ref) {
    return NotificationsSubscriptionNotifier(
      ref.read(LocalNotificationService.provider),
    );
  });

  final LocalNotificationService _service;
  NotificationsSubscriptionNotifier(this._service)
      : super(const AsyncValue.loading());

  Future<void> fetchData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _service.checkPendingNotifications());
  }

  Future<void> toggle() async {
    final current = state.valueOrNull;
    if (current != null) {
      if (current) {
        await _service.cancelAll();
        Fluttertoast.showToast(
            msg: "تم إلغاء الإشعارات",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT);
      } else {
        await registerAzkarNotifications();
        Fluttertoast.showToast(
            msg: "تم الاشتراك في الإشعارات",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT);
      }
      state = AsyncValue.data(!current);
    }
  }

  Future<void> registerAzkarNotifications() async {
    final now = DateTime.now();

    await _service.schedule(
        scheduleReminder: ScheduleReminder.daily,
        dateTime: DateTime(now.year, now.month, now.day, 7, 0),
        title: "بلغوا",
        body: "نذكرك بقراءة أذكار الصباح",
        payload: "0");

    await _service.schedule(
        scheduleReminder: ScheduleReminder.daily,
        dateTime: DateTime(now.year, now.month, now.day, 17, 0),
        title: "بلغوا",
        body: "نذكرك بقراءة أذكار المساء",
        payload: "1");
  }

  Future<void> navigateOnNotificationLaunch(
      void Function(String category) onCategory) async {
    final notificationAtLaunch = await _service.flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    final didLaunchApp =
        notificationAtLaunch?.didNotificationLaunchApp ?? false;
    final payload = notificationAtLaunch?.notificationResponse?.payload;
    if (didLaunchApp && payload != null) {
      final category =
          azkarDataList[int.tryParse(payload) ?? 0].toString().trim();
      onCategory(category);
    }
  }
}
