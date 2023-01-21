import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/services/local_notification_service.dart';

import '../../helpers/enums.dart';
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
      } else {
        await registerAzkarNotifications();
      }
      state = GenericState.success(!state.getData()!);
    }
  }

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
}
