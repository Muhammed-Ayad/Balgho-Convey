import 'dart:convert';
import 'package:great_quran/feature/notifications/logic/models/notification_settings_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class INotificationSettingsRepository {
  Future<NotificationSettingsModel> getSettings();
  Future<void> saveSettings(NotificationSettingsModel settings);
}

class NotificationSettingsRepository
    implements INotificationSettingsRepository {
  static final provider = Provider<INotificationSettingsRepository>((ref) {
    return NotificationSettingsRepository();
  });

  static const String _prefKey = 'app_notification_settings_key';

  @override
  Future<NotificationSettingsModel> getSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefKey);
      if (saved != null && saved.isNotEmpty) {
        return NotificationSettingsModel.fromJson(jsonDecode(saved));
      }
    } catch (_) {}
    return const NotificationSettingsModel();
  }

  @override
  Future<void> saveSettings(NotificationSettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, jsonEncode(settings.toJson()));
  }
}
