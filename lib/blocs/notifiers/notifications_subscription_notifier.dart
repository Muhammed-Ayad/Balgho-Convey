import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:great_quran/services/local_notification_service.dart';

import '../../data/local/json/all_azkar.dart';
import '../../ui/azkar/azkar_category_screen.dart';
import '../state_mix/state_mix.dart';

class NotificationsSubscriptionNotifier
    extends StateNotifier<GenericState<bool>> with DataFetcherForStateNotifier {
  static final provider = StateNotifierProvider<
      NotificationsSubscriptionNotifier, GenericState<bool>>((ref) {
    return NotificationsSubscriptionNotifier(
      ref.read(LocalNotificationService.provider),
    );
  });

  final LocalNotificationService _service;
  NotificationsSubscriptionNotifier(this._service)
      : super(GenericState.initial());

  @override
  AsyncFetchFunction<bool> get dataFetcher =>
      () => _service.checkPendingNotifications();

  Future<void> toggle() async {
    if (state.isSuccess) {
      if (state.getData()!) {
        await _service.cancelAll();
        Fluttertoast.showToast(
            msg: "تم إلغاء الإشعارات",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
      } else {
        await registerAzkarNotifications();
        Fluttertoast.showToast(
            msg: "تم الاشتراك في الإشعارات",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
      }
      state = GenericState.success(!state.getData()!);
    }
  }

  /// Registers scheduled notifications for Azkar
  /// currently we only add for morning and evening azkar
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

  /// Checks if the app launched via a press on notification
  /// if so calls the navigateOnLaunch function with the given route and
  /// then you should use it to navigate to the corresponding azkar screen
  Future<void> navigateOnNotificationLaunch(
      Function(PageRoute) navigateOnLaunch) async {
    final notificationAtLaunch = await _service.flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    final didLaunchApp =
        notificationAtLaunch?.didNotificationLaunchApp ?? false;
    final payload = notificationAtLaunch?.notificationResponse?.payload;
    if (didLaunchApp && payload != null) {
      navigateOnLaunch(
        MaterialPageRoute(
          builder: (context) => AzkarCategoryScreen(
            azkar: azkarDataList[int.parse(payload)],
          ),
        ),
      );
    }
  }
}
