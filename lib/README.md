# Application Source (lib)

## Overview
Houses all Dart application source code, organized into foundational core modules, clean architecture domain features, localized language catalogs, and root application entry points.

## Interface
- `[lib/main.dart:main]` - Application bootstrap function initializing `WidgetsFlutterBinding`, `LocalNotificationService`, background `AudioService` handler, and running `ProviderScope`.
- `[lib/app.dart:MyApp]` - Root `ConsumerStatefulWidget` subscribing to `WidgetsBindingObserver` for lifecycle resume synchronization, routing configuration via `appRouter`, and theme modes.
- `[lib/app.dart:MyApp.instance]` - Static singleton instance factory for `MyApp`.
- `core`: [./core/README.md](./core/README.md) - System-wide cross-cutting foundation (services, network, routing, theme, widgets).
- `feature`: [./feature/README.md](./feature/README.md) - Self-contained business features following the `logic/` and `view/` convention.
- `l10n`: [./l10n/README.md](./l10n/README.md) - Localization delegates and translations for Arabic and English.

## Invariants
- `[lib/main.dart:main]` must wrap the widget tree in a root `ProviderScope` with `radioAudioHandlerProvider` overridden when background audio is initialized.
- `[lib/app.dart:MyApp]` resynchronizes scheduled notifications upon entering `AppLifecycleState.resumed` with a 30-minute throttle window unless the calendar date has changed.

## Side Effects
- Initializes Android notification channels and background audio services on startup.
- Listens to device lifecycle events (`WidgetsBindingObserver`).

## Verification
- Run: `flutter test`
