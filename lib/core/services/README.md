# Core Services Package

## Overview
Houses system-level hardware, platform channel, and OS abstraction services including location tracking, audio caching, local notifications, background schedule synchronization, flip-to-mute hardware detection, and Android AppWidget synchronizers.

## Interface
- `[lib/core/services/azan_audio_cache_service.dart:AzanAudioCacheService]` - Manages caching and disk resolution of Adhan audio files via Dio and path_provider (`getAudioFilePath`, `isAudioCached`, `downloadAudio`).
- `[lib/core/services/azan_audio_cache_service.dart:AzanAudioCacheService.provider]` - Riverpod provider exposing `AzanAudioCacheService`.
- `[lib/core/services/flip_to_mute_service.dart:FlipToMuteService]` - Listens to native Android accelerometer events over MethodChannel `com.convey.ayah.mohamed.ayad/flip_to_mute` to silence active Adhan audio when face-down.
- `[lib/core/services/flip_to_mute_service.dart:FlipToMuteService.provider]` - Riverpod provider exposing `FlipToMuteService`.
- `[lib/core/services/home_widget_sync_service.dart:HomeWidgetSyncService]` - Syncs prayer time and daily zekr state to SharedPreferences and triggers native Android AppWidgets over `com.convey.ayah.mohamed.ayad/widget_sync`.
- `[lib/core/services/home_widget_sync_service.dart:HomeWidgetSyncService.provider]` - Riverpod provider exposing `HomeWidgetSyncService`.
- `[lib/core/services/local_notification_service.dart:LocalNotificationService]` - Wraps `FlutterLocalNotificationsPlugin` for channel configuration, instant alerts, and notification action handling.
- `[lib/core/services/local_notification_service.dart:LocalNotificationService.provider]` - Riverpod provider exposing `LocalNotificationService`.
- `[lib/core/services/location_service.dart:LocationService]` - Handles location permission requests and GPS coordinate retrieval via the `location` package.
- `[lib/core/services/location_service.dart:LocationService.provider]` - Riverpod provider exposing `LocationService`.
- `[lib/core/services/notification_scheduler_service.dart:NotificationSchedulerService]` - Orchestrates exact zone-aware alarms for prayer times, morning/evening azkar, and recurring reminders via `timezone`.
- `[lib/core/services/notification_scheduler_service.dart:NotificationSchedulerService.provider]` - Riverpod provider exposing `NotificationSchedulerService`.

## Invariants
- `[lib/core/services/local_notification_service.dart:LocalNotificationService.init]` must be called before scheduling or displaying any system notifications.
- `[lib/core/services/flip_to_mute_service.dart:FlipToMuteService.initialize]` is idempotent; subsequent calls return early without re-registering platform channels.

## Side Effects
- Reads/writes audio files in device app directory storage (`path_provider`).
- Writes widget keys to `SharedPreferences`.
- Invokes native Android platform channels via `MethodChannel`.
- Requests OS permissions (Location, Notifications, Exact Alarms).
- Dispatches and cancels local device alarms.

## Verification
- Run: `flutter test test/notifications_test.dart`
