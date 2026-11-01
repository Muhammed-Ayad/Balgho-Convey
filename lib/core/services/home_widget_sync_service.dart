import 'package:flutter/services.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeWidgetSyncService {
  static final provider = Provider<HomeWidgetSyncService>((ref) {
    return HomeWidgetSyncService();
  });

  static const MethodChannel _channel =
      MethodChannel('com.convey.ayah.mohamed.ayad/widget_sync');

  static const String keyNextPrayerName = 'widget_next_prayer_name';
  static const String keyNextPrayerTime = 'widget_next_prayer_time';
  static const String keyNextPrayerRemaining = 'widget_next_prayer_remaining';
  static const String keyHijriDate = 'widget_hijri_date';
  static const String keyDailyZekr = 'widget_daily_zekr';
  static const String keyDailyZekrFadl = 'widget_daily_zekr_fadl';
  static const String keyLastUpdated = 'widget_last_updated';

  Future<void> _notifyNativeWidgets() async {
    try {
      await _channel.invokeMethod('updateWidgets');
      "Native Android widgets update requested".log();
    } catch (e) {
      "Error notifying native widgets: $e".log();
    }
  }

  Future<void> syncPrayerData({
    required String prayerName,
    required String prayerTime,
    required String remainingFormatted,
    required String hijriDate,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(keyNextPrayerName, prayerName);
      await prefs.setString(keyNextPrayerTime, prayerTime);
      await prefs.setString(keyNextPrayerRemaining, remainingFormatted);
      await prefs.setString(keyHijriDate, hijriDate);
      await prefs.setString(
        keyLastUpdated,
        DateFormat('hh:mm a').format(DateTime.now()),
      );
      "Home widget prayer data synced successfully".log();
      await _notifyNativeWidgets();
    } catch (e) {
      "Error syncing prayer data to widget: $e".log();
    }
  }

  Future<void> syncDailyZekr({
    required String zekr,
    required String fadl,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(keyDailyZekr, zekr);
      await prefs.setString(keyDailyZekrFadl, fadl);
      "Home widget daily zekr synced successfully".log();
      await _notifyNativeWidgets();
    } catch (e) {
      "Error syncing daily zekr to widget: $e".log();
    }
  }

  Future<Map<String, String>> getSyncedWidgetData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        keyNextPrayerName: prefs.getString(keyNextPrayerName) ?? "المغرب",
        keyNextPrayerTime: prefs.getString(keyNextPrayerTime) ?? "05:45 م",
        keyNextPrayerRemaining:
            prefs.getString(keyNextPrayerRemaining) ?? "45 دقيقة",
        keyHijriDate: prefs.getString(keyHijriDate) ?? "التقويم الهجري",
        keyDailyZekr: prefs.getString(keyDailyZekr) ??
            "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ",
        keyDailyZekrFadl: prefs.getString(keyDailyZekrFadl) ??
            "كلمتان خفيفتان على اللسان ثقيلتان في الميزان",
        keyLastUpdated: prefs.getString(keyLastUpdated) ?? "الآن",
      };
    } catch (_) {
      return {};
    }
  }
}
