# Notifications Feature Package

## Overview
Controls all notification preferences, alarm toggles, diagnostic inspections, exact alarm permission handling for Android 13/14+, and test notification triggering.

## Interface
- `[lib/feature/notifications/logic/models/notification_settings_model.dart:NotificationSettingsModel]` - Model configuring master switch, prayer alerts, azkar reminders, and daily notifications.
- `[lib/feature/notifications/logic/models/notification_diagnostics_model.dart:NotificationDiagnosticsModel]` - Model inspecting OS notification permissions and pending alarms.
- `[lib/feature/notifications/logic/repo/notification_settings_repository.dart:INotificationSettingsRepository]` - Interface defining retrieval and persistence of notification configurations.
- `[lib/feature/notifications/logic/repo/notification_settings_repository.dart:NotificationSettingsRepository]` - Implementation persisting settings as JSON in `SharedPreferences`.
- `[lib/feature/notifications/logic/repo/notification_settings_repository.dart:NotificationSettingsRepository.provider]` - Riverpod provider exposing `INotificationSettingsRepository`.
- `[lib/feature/notifications/logic/providers/notification_settings_provider.dart:NotificationSettingsNotifier]` - StateNotifier updating settings and automatically resynchronizing OS alarm schedules.
- `[lib/feature/notifications/logic/providers/notification_settings_provider.dart:NotificationSettingsNotifier.provider]` - Riverpod provider exposing `NotificationSettingsNotifier`.
- `[lib/feature/notifications/logic/providers/notification_settings_provider.dart:notificationDiagnosticsProvider]` - Auto-disposing FutureProvider returning active notification diagnostics.
- `[lib/feature/notifications/view/screens/notifications_settings_screen.dart:NotificationsSettingsScreen]` - Configuration page with category switches and diagnostics.
- `[lib/feature/notifications/view/widgets/notification_master_card.dart:NotificationMasterCard]` - Master enable/disable card for the entire notification system.
- `[lib/feature/notifications/view/widgets/notification_switch_item.dart:NotificationSwitchItem]` - Toggle switch for an individual notification channel.
- `[lib/feature/notifications/view/widgets/notification_diagnostics_card.dart:NotificationDiagnosticsCard]` - Card showing live channel status and pending alarms.
- `[lib/feature/notifications/view/widgets/notification_test_card.dart:NotificationTestCard]` - Card allowing manual triggering of test notifications.
- `[lib/feature/notifications/view/widgets/exact_alarm_warning_banner.dart:ExactAlarmWarningBanner]` - Banner warning users if exact alarm permissions are restricted.

## Invariants
- Disabling the master toggle (`allNotificationsEnabled = false`) cancels all active and pending notification schedules across all categories.

## Side Effects
- Persists settings to `SharedPreferences`.
- Requests Android runtime permissions (`POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM`).
- Schedules and cancels system alarms via `NotificationSchedulerService`.

## Verification
- Run: `flutter test test/notifications_test.dart`
