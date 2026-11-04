# Azan Feature Package

## Overview
Calculates Islamic prayer times using astronomical formulas from the `adhan` library based on GPS coordinates or cached fallback locations. Provides prayer time countdowns, Hijri calendar mapping, and sunan prayer guides.

## Interface
- `[lib/feature/azan/logic/models/azan.dart:Azan]` - Root model containing prayer data and metadata for the current calculation.
- `[lib/feature/azan/logic/models/timings.dart:Timings]` - Holds daily prayer time strings (Fajr, Sunrise, Dhuhr, Asr, Sunset, Maghrib, Isha, Imsak, Midnight).
- `[lib/feature/azan/logic/models/hijri.dart:Hijri]` - Hijri calendar date model with day, month, and year representation.
- `[lib/feature/azan/logic/repo/azan_repository.dart:IAzanRepository]` - Repository interface defining prayer time retrieval methods.
- `[lib/feature/azan/logic/repo/azan_repository.dart:AzanRepository]` - Implementation calculating prayer times with `adhan`, Cairo default coordinates (30.0444, 31.2357), and daylight savings adjustments.
- `[lib/feature/azan/logic/repo/azan_repository.dart:AzanRepository.provider]` - Riverpod provider exposing `IAzanRepository`.
- `[lib/feature/azan/logic/providers/azan_provider.dart:AzanTimeNotifier]` - StateNotifier managing `AsyncValue<Azan>`.
- `[lib/feature/azan/logic/providers/azan_provider.dart:AzanTimeNotifier.provider]` - Riverpod provider exposing `AzanTimeNotifier`.
- `[lib/feature/azan/view/screens/azan_screen.dart:AzanScreen]` - Full screen showing today's prayer times, current/next prayer status, and prayer recommendations.
- `[lib/feature/azan/view/widgets/azan_item.dart:AzanItemWidget]` - Card displaying a single prayer's name, time, and active status.
- `[lib/feature/azan/view/widgets/header_azan.dart:HeaderAzan]` - Header displaying location and date context.
- `[lib/feature/azan/view/widgets/azan_sunan_card.dart:AzanSunanCard]` - Informational card explaining sunan prayers associated with obligatory prayers.

## Invariants
- `[lib/feature/azan/logic/repo/azan_repository.dart:AzanRepository]` falls back to default Cairo coordinates (30.0444, 31.2357) if location permissions are denied or GPS is unavailable.
- Prayer time calculations strictly execute locally on device via `adhan` without external network requests.

## Side Effects
- Reads and writes cached coordinates and calculations in `SharedPreferences` (`cached_azan_lat`, `cached_azan_lng`, `cached_azan_json`).
- Requests GPS location access via `LocationService`.
- Triggers notification schedule resynchronization via `NotificationSchedulerService` when prayer calculations update.

## Verification
- Run: `flutter test test/azan_test.dart`
