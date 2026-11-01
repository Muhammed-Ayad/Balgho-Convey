import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
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
      if (target) {
        await _ref
            .read(NotificationSettingsNotifier.provider.notifier)
            .requestPermissionsAndSync();
        final settingsRepo = _ref.read(NotificationSettingsRepository.provider);
        final currentSettings = await settingsRepo.getSettings();
        if (!currentSettings.allNotificationsEnabled) {
          await _ref
              .read(NotificationSettingsNotifier.provider.notifier)
              .toggleAllNotifications(true);
        }
      }
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
    void Function(String category) onCategory, {
    void Function(String route)? onRoute,
  }) async {
    final notificationAtLaunch = await _service.flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    final didLaunchApp =
        notificationAtLaunch?.didNotificationLaunchApp ?? false;
    final payload = notificationAtLaunch?.notificationResponse?.payload;
    if (didLaunchApp && payload != null) {
      if (payload == "0") {
        onCategory("أذكار الصباح");
      } else if (payload == "1") {
        onCategory("أذكار المساء");
      } else if (payload == "sleep") {
        onCategory("أذكار النوم");
      } else if (payload == "wakeup") {
        onCategory("أذكار الاستيقاظ من النوم");
      } else if (payload.startsWith("prayer_") ||
          payload.startsWith("pre_prayer_") ||
          payload == "duha" ||
          payload == "qiyam" ||
          payload.startsWith("fasting_")) {
        if (onRoute != null) {
          onRoute(Routes.azanRoute);
        }
      } else if (payload == "friday_kahf") {
        if (onRoute != null) {
          onRoute(Routes.quranRoute);
        }
      } else if (payload == "daily_hadith") {
        if (onRoute != null) {
          onRoute(Routes.nawawiRoute);
        }
      } else {
        final parsed = int.tryParse(payload);
        if (parsed != null && parsed >= 0 && parsed < azkarDataList.length) {
          onCategory(azkarDataList[parsed]);
        }
      }
    }
  }
}
