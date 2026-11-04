# Core Routes Package

## Overview
Defines central navigation route paths and the declarative `GoRouter` configuration wiring URLs to screen widgets across all application features.

## Interface
- `[lib/core/routes/routes_manager.dart:Routes]` - String constants defining application routes (`mainRoute`, `azanRoute`, `azkarRoute`, `quranRoute`, `qiblaRoute`, `radiosRoute`, `nawawiRoute`, `habitsRoute`, `favoritesRoute`, `tasbihRoute`, `prophetRoute`, `settingsRoute`, `notificationsSettingsRoute`, `azanSettingsRoute`, etc.).
- `[lib/core/routes/routes_manager.dart:appRouter]` - Global `GoRouter` instance configuring route declarations and custom page transitions.

## Invariants
- Route navigation relies on valid route parameters where required (e.g., extra model arguments for `surahRoute`, `prophetDetailRoute`, and `audioPageRoute`).

## Side Effects
- Mutates application navigation state and updates the system URL/history.

## Verification
- Run: `flutter test test/widget_test.dart`
