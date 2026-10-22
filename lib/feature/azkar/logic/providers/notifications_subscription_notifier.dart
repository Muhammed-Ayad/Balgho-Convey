import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:great_quran/core/services/local_notification_service.dart';
import 'package:great_quran/feature/azkar/logic/data/all_azkar.dart';
import 'package:great_quran/feature/notifications/logic/providers/notification_settings_provider.dart';
import 'package:great_quran/feature/notifications/logic/repo/notification_settings_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationsSubscriptionNotifier
    extends StateNotifier<AsyncValue<bool>> {
  static final provider = StateNotifierProvider<
      NotificationsSubscriptionNotifier, AsyncValue<bool>>((ref) {
    return NotificationsSubscriptionNotifier(
      ref.read(LocalNotificationService.provider),
      ref,
    );
  });

  final LocalNotificationService _service;
  final Ref _ref;

  NotificationsSubscriptionNotifier(this._service, this._ref)
      : super(const AsyncValue.loading());

  Future<void> fetchData() async {
    state = const AsyncValue.loading();
    try {
      final settings = await _ref
          .read(NotificationSettingsRepository.provider)
          .getSettings();
      state = AsyncValue.data(
          settings.allNotificationsEnabled && settings.azkarNotificationsEnabled);
    } catch (_) {
      state = const AsyncValue.data(false);
    }
  }

  Future<void> toggle() async {
    final current = state.valueOrNull ?? false;
    final target = !current;
    try {
      await _ref
          .read(NotificationSettingsNotifier.provider.notifier)
          .toggleAzkarCategory(target);
      Fluttertoast.showToast(
          msg: target ? "تم تفعيل تنبيهات الأذكار" : "تم إلغاء تنبيهات الأذكار",
          backgroundColor: target ? Colors.green : Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      state = AsyncValue.data(target);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "حدث خطأ أثناء تعديل التنبيهات",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    }
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
