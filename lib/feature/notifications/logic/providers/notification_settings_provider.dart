import 'package:great_quran/core/services/local_notification_service.dart';
import 'package:great_quran/core/services/notification_scheduler_service.dart';
import 'package:great_quran/feature/notifications/logic/models/notification_settings_model.dart';
import 'package:great_quran/feature/notifications/logic/repo/notification_settings_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationSettingsNotifier
    extends StateNotifier<AsyncValue<NotificationSettingsModel>> {
  static final provider = StateNotifierProvider<NotificationSettingsNotifier,
      AsyncValue<NotificationSettingsModel>>((ref) {
    return NotificationSettingsNotifier(
      ref.read(NotificationSettingsRepository.provider),
      ref.read(NotificationSchedulerService.provider),
      ref.read(LocalNotificationService.provider),
    );
  });

  final INotificationSettingsRepository _repository;
  final NotificationSchedulerService _schedulerService;
  final LocalNotificationService _notificationService;

  NotificationSettingsNotifier(
    this._repository,
    this._schedulerService,
    this._notificationService,
  ) : super(const AsyncValue.loading()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final settings = await _repository.getSettings();
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> _saveAndSchedule(NotificationSettingsModel newSettings) async {
    state = AsyncValue.data(newSettings);
    await _repository.saveSettings(newSettings);
    await _schedulerService.syncSchedules(newSettings);
  }

  Future<void> requestPermissions() async {
    await _notificationService.requestPermissions();
  }

  Future<void> sendTestNotification() async {
    await _schedulerService.sendTestNotification();
  }

  Future<void> toggleAllNotifications(bool enabled) async {
    final current = state.value ?? const NotificationSettingsModel();
    final updated = current.copyWith(allNotificationsEnabled: enabled);
    await _saveAndSchedule(updated);
  }

  Future<void> togglePrayerCategory(bool enabled) async {
    final current = state.value ?? const NotificationSettingsModel();
    final updated = current.copyWith(prayerNotificationsEnabled: enabled);
    await _saveAndSchedule(updated);
  }

  Future<void> toggleSpecificPrayer(String prayer, bool enabled) async {
    final current = state.value ?? const NotificationSettingsModel();
    NotificationSettingsModel updated;
    switch (prayer) {
      case 'fajr':
        updated = current.copyWith(fajr: enabled);
        break;
      case 'dhuhr':
        updated = current.copyWith(dhuhr: enabled);
        break;
      case 'asr':
        updated = current.copyWith(asr: enabled);
        break;
      case 'maghrib':
        updated = current.copyWith(maghrib: enabled);
        break;
      case 'isha':
        updated = current.copyWith(isha: enabled);
        break;
      default:
        updated = current;
    }
    await _saveAndSchedule(updated);
  }

  Future<void> togglePrayerPreReminder(bool enabled) async {
    final current = state.value ?? const NotificationSettingsModel();
    final updated = current.copyWith(prayerPreReminder: enabled);
    await _saveAndSchedule(updated);
  }

  Future<void> toggleAzkarCategory(bool enabled) async {
    final current = state.value ?? const NotificationSettingsModel();
    final updated = current.copyWith(azkarNotificationsEnabled: enabled);
    await _saveAndSchedule(updated);
  }

  Future<void> toggleSpecificAzkar(String type, bool enabled) async {
    final current = state.value ?? const NotificationSettingsModel();
    NotificationSettingsModel updated;
    switch (type) {
      case 'morning':
        updated = current.copyWith(morningAzkar: enabled);
        break;
      case 'evening':
        updated = current.copyWith(eveningAzkar: enabled);
        break;
      case 'sleep':
        updated = current.copyWith(sleepAzkar: enabled);
        break;
      case 'wakeup':
        updated = current.copyWith(wakeUpAzkar: enabled);
        break;
      default:
        updated = current;
    }
    await _saveAndSchedule(updated);
  }

  Future<void> toggleDailyZekr(bool enabled) async {
    final current = state.value ?? const NotificationSettingsModel();
    final updated = current.copyWith(dailyZekrEnabled: enabled);
    await _saveAndSchedule(updated);
  }

  Future<void> toggleDailyHadith(bool enabled) async {
    final current = state.value ?? const NotificationSettingsModel();
    final updated = current.copyWith(dailyHadithEnabled: enabled);
    await _saveAndSchedule(updated);
  }

  Future<void> toggleSunanCategory(bool enabled) async {
    final current = state.value ?? const NotificationSettingsModel();
    final updated = current.copyWith(sunanEnabled: enabled);
    await _saveAndSchedule(updated);
  }

  Future<void> toggleDuha(bool enabled) async {
    final current = state.value ?? const NotificationSettingsModel();
    final updated = current.copyWith(duhaPrayer: enabled);
    await _saveAndSchedule(updated);
  }

  Future<void> toggleQiyam(bool enabled) async {
    final current = state.value ?? const NotificationSettingsModel();
    final updated = current.copyWith(qiyamNight: enabled);
    await _saveAndSchedule(updated);
  }

  Future<void> toggleOccasionsCategory(bool enabled) async {
    final current = state.value ?? const NotificationSettingsModel();
    final updated = current.copyWith(occasionsEnabled: enabled);
    await _saveAndSchedule(updated);
  }

  Future<void> toggleFridayKahf(bool enabled) async {
    final current = state.value ?? const NotificationSettingsModel();
    final updated = current.copyWith(fridayKahf: enabled);
    await _saveAndSchedule(updated);
  }

  Future<void> toggleFastingMondayThursday(bool enabled) async {
    final current = state.value ?? const NotificationSettingsModel();
    final updated = current.copyWith(fastingMondayThursday: enabled);
    await _saveAndSchedule(updated);
  }

  Future<void> toggleFastingWhiteDays(bool enabled) async {
    final current = state.value ?? const NotificationSettingsModel();
    final updated = current.copyWith(fastingWhiteDays: enabled);
    await _saveAndSchedule(updated);
  }
}
