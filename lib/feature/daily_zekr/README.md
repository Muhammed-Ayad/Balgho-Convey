# Daily Zekr Feature Package

## Overview
Computes and rotates a daily Islamic supplication or Hadith calculated deterministically based on the calendar date, automatically scheduling refresh timers at midnight.

## Interface
- `[lib/feature/daily_zekr/logic/models/daily_zekr.dart:DailyZekr]` - Data model containing zekr text, source reference, fadl description, and Hadith indicator flag.
- `[lib/feature/daily_zekr/logic/providers/daily_zekr_provider.dart:kDailyZekrList]` - Compile-time catalog of curated daily supplications.
- `[lib/feature/daily_zekr/logic/providers/daily_zekr_provider.dart:dailyZekrProvider]` - Riverpod auto-disposing provider selecting today's zekr based on days since epoch.
- `[lib/feature/daily_zekr/view/widgets/daily_zekr_card.dart:DailyZekrCard]` - UI card displaying the daily zekr, share action, and copy button.

## Invariants
- `[lib/feature/daily_zekr/logic/providers/daily_zekr_provider.dart:dailyZekrProvider]` automatically schedules invalidation at the next local midnight.
- Deterministic modulo index mapping guarantees identical zekr selection across multiple app launches on the same calendar day.

## Side Effects
- Copies text to device clipboard on user copy action.
- Dispatches native system share sheet via `share_plus`.

## Verification
- Run: `flutter test test/daily_zekr_test.dart`
