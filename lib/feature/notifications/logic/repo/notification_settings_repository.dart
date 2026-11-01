import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:great_quran/feature/notifications/logic/models/notification_settings_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class INotificationSettingsRepository {
  Future<NotificationSettingsModel> getSettings();
  Future<void> saveSettings(NotificationSettingsModel settings);
  Future<bool> isExactAlarmPromptShown();
  Future<void> setExactAlarmPromptShown(bool shown);
}

class NotificationSettingsRepository
    implements INotificationSettingsRepository {
  static final provider = Provider<INotificationSettingsRepository>((ref) {
    return NotificationSettingsRepository();
  });

  static const String _prefKey = 'app_notification_settings_key';
  static const String _exactAlarmPromptShownKey = 'exact_alarm_prompt_shown';

  @override
  Future<NotificationSettingsModel> getSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefKey);
      if (saved != null && saved.isNotEmpty) {
        return NotificationSettingsModel.fromJson(jsonDecode(saved));
      }
    } catch (e, stack) {
      debugPrint(
          "NotificationSettingsRepository: Error loading settings: $e\n$stack");
    }
    return const NotificationSettingsModel();
  }

  @override
  Future<void> saveSettings(NotificationSettingsModel settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, jsonEncode(settings.toJson()));
    } catch (e, stack) {
      debugPrint(
          "NotificationSettingsRepository: Error saving settings: $e\n$stack");
    }
  }

  @override
  Future<bool> isExactAlarmPromptShown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_exactAlarmPromptShownKey) ?? false;
    } catch (e, stack) {
      debugPrint(
          "NotificationSettingsRepository: Error reading prompt flag: $e\n$stack");
      return false;
    }
  }

  @override
  Future<void> setExactAlarmPromptShown(bool shown) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_exactAlarmPromptShownKey, shown);
    } catch (e, stack) {
      debugPrint(
          "NotificationSettingsRepository: Error saving prompt flag: $e\n$stack");
    }
  }
}
