# Settings Feature Package

## Overview
Configures user preferences for theme mode, Adhan audio reciter selection, Fajr audio selection, daylight saving time adjustments, and flip-to-mute hardware toggles.

## Interface
- `[lib/feature/settings/logic/models/azan_sound_option.dart:AzanSoundOption]` - Model holding audio filename, URL, and title for an Adhan reciter.
- `[lib/feature/settings/logic/models/azan_sound_option.dart:AzanVoice]` - Enum of available Adhan voices (Makkah, Madinah, Al-Aqsa, Abdulbasit, etc.).
- `[lib/feature/settings/logic/models/azan_sound_option.dart:AzanNotificationPreferences]` - Preferences model storing selected voice, Fajr voice, daylight saving mode, and flip-to-mute boolean.
- `[lib/feature/settings/logic/models/azan_sound_option.dart:DaylightSavingMode]` - Enum for daylight saving adjustments (`auto`, `plusOneHour`, `none`).
- `[lib/feature/settings/logic/repo/azan_settings_repository.dart:IAzanSettingsRepository]` - Storage contract for Adhan sound and daylight saving preferences.
- `[lib/feature/settings/logic/repo/azan_settings_repository.dart:AzanSettingsRepository]` - Implementation persisting preferences as JSON in `SharedPreferences`.
- `[lib/feature/settings/logic/repo/azan_settings_repository.dart:AzanSettingsRepository.provider]` - Riverpod provider exposing `IAzanSettingsRepository`.
- `[lib/feature/settings/logic/providers/azan_settings_provider.dart:AzanSettingsNotifier]` - StateNotifier managing audio preview playback and persisting preference modifications.
- `[lib/feature/settings/logic/providers/azan_settings_provider.dart:AzanSettingsNotifier.provider]` - Riverpod provider for Adhan preferences.
- `[lib/feature/settings/view/screens/settings_screen.dart:SettingsScreen]` - Main application settings menu.
- `[lib/feature/settings/view/screens/azan_settings_screen.dart:AzanSettingsScreen]` - Dedicated Adhan sounds and calculation preferences screen.
- `[lib/feature/settings/view/widgets/daylight_saving_sheet.dart:DaylightSavingSheet]` - Bottom sheet modal selecting daylight saving adjustment mode.

## Invariants
- Audio preview playback automatically halts upon selecting a different voice or leaving the settings screen.
- Updating daylight saving preferences triggers automatic recalculation in `AzanTimeNotifier`.

## Side Effects
- Plays temporary audio preview samples using `audioplayers`.
- Downloads remote Adhan MP3 files via `AzanAudioCacheService`.
- Saves JSON configuration string to `SharedPreferences` key `azan_notification_preferences_key`.

## Verification
- Run: `flutter test test/azan_settings_test.dart`
