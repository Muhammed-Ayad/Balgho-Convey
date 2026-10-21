import 'dart:convert';
import 'package:great_quran/feature/settings/logic/models/azan_sound_option.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAzanSettingsRepository {
  Future<AzanNotificationPreferences> getPreferences();
  Future<void> savePreferences(AzanNotificationPreferences prefs);
}

class AzanSettingsRepository implements IAzanSettingsRepository {
  static final provider = Provider<IAzanSettingsRepository>((ref) {
    return AzanSettingsRepository();
  });

  static const String _prefKey = 'azan_notification_preferences_key';

  @override
  Future<AzanNotificationPreferences> getPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefKey);
      if (saved != null && saved.isNotEmpty) {
        return AzanNotificationPreferences.fromJson(jsonDecode(saved));
      }
    } catch (_) {}
    return const AzanNotificationPreferences();
  }

  @override
  Future<void> savePreferences(AzanNotificationPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, jsonEncode(preferences.toJson()));
  }
}
