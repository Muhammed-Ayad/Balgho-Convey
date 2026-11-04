# Core Helpers Package

## Overview
Provides shared application constants, BuildContext and logging extensions, and UI post-frame execution helpers.

## Interface
- `[lib/core/helpers/constants.dart:Constants]` - Common layout constants, animation durations, and static error messages.
- `[lib/core/helpers/extensions.dart:LogEx]` - Object extension providing developer console logging (`log()`).
- `[lib/core/helpers/extensions.dart:ContextEx]` - BuildContext extensions for responsive dimensions (`heightR`, `widthR`), theme, text theme, and localization lookup (`l10n`).
- `[lib/core/helpers/ui_helpers.dart:UiHelper]` - Helper providing `postBuild()` hook scheduling via `WidgetsBinding.instance.addPostFrameCallback`.

## Invariants
- `[lib/core/helpers/extensions.dart:ContextEx.l10n]` asserts that localized resources exist in the calling `BuildContext` and force-unwraps `AppLocalizations.of(this)!`.

## Side Effects
- `[lib/core/helpers/extensions.dart:LogEx.log]` writes logs to `dart:developer`.

## Verification
- Run: `flutter test`
