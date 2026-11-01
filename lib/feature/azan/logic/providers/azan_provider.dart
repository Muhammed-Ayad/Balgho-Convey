import 'package:great_quran/core/services/notification_scheduler_service.dart';
import 'package:great_quran/feature/azan/logic/models/azan.dart';
import 'package:great_quran/feature/azan/logic/repo/azan_repository.dart';
import 'package:great_quran/feature/notifications/logic/repo/notification_settings_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AzanTimeNotifier extends StateNotifier<AsyncValue<Azan>> {
  static final provider =
      StateNotifierProvider<AzanTimeNotifier, AsyncValue<Azan>>((ref) {
    return AzanTimeNotifier(ref.read(AzanRepository.provider), ref);
  });

  final IAzanRepository _azanRepository;
  final Ref _ref;

  AzanTimeNotifier(this._azanRepository, this._ref)
      : super(AsyncValue.data(_azanRepository.getInitialAzan())) {
    _initFromCache();
  }

  Future<void> _initFromCache() async {
    final cached = await _azanRepository.getCachedAzan();
    if (cached != null) {
      state = AsyncValue.data(cached);
    }
  }

  Future<void> getAzan({bool allowPrompt = false}) async {
    try {
      final azan = await _azanRepository.getAzan(allowPrompt: allowPrompt);
      state = AsyncValue.data(azan);
      try {
        final scheduler = _ref.read(NotificationSchedulerService.provider);
        final settings = await _ref
            .read(NotificationSettingsRepository.provider)
            .getSettings();
        if (settings.allNotificationsEnabled &&
            settings.prayerNotificationsEnabled) {
          await scheduler.syncSchedules(settings);
        }
      } catch (_) {}
    } catch (e, stack) {
      if (!state.hasValue) {
        state = AsyncValue.error(e, stack);
      }
    }
  }
}
