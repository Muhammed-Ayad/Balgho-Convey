# Radios Feature Package

## Overview
Streams online Islamic radio stations, recitations, and lectures from MP3Quran. Implements continuous background playback via `audio_service`, lock-screen notification controls, and animated audio visualizers.

## Interface
- `[lib/feature/radios/logic/models/radio.dart:RadioDetalis]` - Model representing an individual radio station with name, streaming URL, and category.
- `[lib/feature/radios/logic/models/radios.dart:Radios]` - Model grouping radio stations into categories.
- `[lib/feature/radios/logic/repo/radios_repository.dart:IRadiosRepository]` - Repository contract for retrieving station catalogs.
- `[lib/feature/radios/logic/repo/radios_repository.dart:RadiosRepository]` - Repository parsing `assets/json/radios_new.json`.
- `[lib/feature/radios/logic/repo/radios_repository.dart:RadiosRepository.provider]` - Riverpod provider exposing `IRadiosRepository`.
- `[lib/feature/radios/logic/providers/radio_audio_handler.dart:RadioAudioHandler]` - `BaseAudioHandler` managing `audioplayers`, audio focus, playlist queue, and lock-screen media controls.
- `[lib/feature/radios/logic/providers/radio_audio_handler.dart:radioAudioHandlerProvider]` - Provider overridden at app startup with initialized `RadioAudioHandler`.
- `[lib/feature/radios/logic/providers/audio_notifier.dart:AudioNotifier]` - StateNotifier synchronizing UI playback state with the background audio handler.
- `[lib/feature/radios/logic/providers/audio_notifier.dart:audioNotifierProvider]` - StateNotifierProvider exposing `AudioState`.
- `[lib/feature/radios/logic/providers/radios_provider.dart:RadiosNotifier]` - StateNotifier fetching station catalog.
- `[lib/feature/radios/view/screens/radios_screen.dart:RadiosScreen]` - Screen showing station list with live mini-player overlay.
- `[lib/feature/radios/view/screens/radio_categories_screen.dart:RadioCategoriesScreen]` - Screen categorizing reciters and stations.
- `[lib/feature/radios/view/screens/audio_page.dart:AudioPage]` - Dedicated full-screen player with animated visualizer, volume, and playback controls.
- `[lib/feature/radios/view/widgets/audio_player_controls.dart:AudioPlayerControls]` - Play/pause, next, and previous buttons.
- `[lib/feature/radios/view/widgets/radio_mini_player_widget.dart:RadioMiniPlayerWidget]` - Persistent bottom banner playing current stream.

## Invariants
- `[lib/feature/radios/logic/providers/radio_audio_handler.dart:RadioAudioHandler]` requests `AndroidAudioFocus.gain` and sets `stayAwake: true` to prevent OS suspension during audio streaming.

## Side Effects
- Streams live audio over network connections (`audioplayers`).
- Creates ongoing foreground media notification with playback actions (`audio_service`).

## Verification
- Run: `flutter test test/audio_notifier_test.dart`
