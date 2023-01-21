import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:great_quran/services/local_notification_service.dart';

import '../../data/local/json/all_azkar.dart';
import '../../helpers/enums.dart';
import '../../ui/azkar/azkar_category_screen.dart';
import '../state_mix/_index.dart';

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
        dateTime: DateTime(now.year, now.month, now.day, 7),
        title: "بلغوا",
        body: "نذكرك بقراءة أذكار الصباح",
        payload: AzkarType.morning.name);

    await _service.schedule(
        scheduleReminder: ScheduleReminder.daily,
        dateTime: DateTime(now.year, now.month, now.day, 17, 00),
        title: "بلغوا",
        body: "نذكرك بقراءة أذكار المساء",
        payload: AzkarType.evening.name);
  }

  /// Checks if the app launched via a press on notification
  /// if so calls the navigateOnLaunch function with the given route and
  /// then you should use it to navigate to the corresponding azkar screen
  Future<void> navigateOnNotificationLaunch(
      Function(PageRoute) navigateOnLaunch) async {
    final notificationAtLaunch = await _service.flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    if (notificationAtLaunch?.didNotificationLaunchApp ?? false) {
      navigateOnLaunch(
        MaterialPageRoute(
          builder: (context) => AzkarCategoryScreen(
            azkar: azkarDataList[AzkarType.fromName(
                            notificationAtLaunch?.notificationResponse?.payload)
                        ?.index ??
                    0]
                .toString()
                .trim(),
          ),
        ),
      );
    }
  }
}
