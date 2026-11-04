# Localization Package

## Overview
Provides internationalization and localized string resources for the Balgho Convey application, supporting Arabic (`ar`) and English (`en`) with generated delegates and lookup helpers.

## Interface
- `[lib/l10n/app_localizations.dart:AppLocalizations]` - Abstract base class for application localizations.
- `[lib/l10n/app_localizations.dart:AppLocalizations.of]` - Static context accessor retrieving localized string instances.
- `[lib/l10n/app_localizations.dart:AppLocalizations.delegate]` - Localization delegate instance for `MaterialApp.localizationsDelegates`.
- `[lib/l10n/app_localizations.dart:AppLocalizations.supportedLocales]` - List of supported locales (`ar`, `en`).
- `[lib/l10n/app_localizations_ar.dart:AppLocalizationsAr]` - Arabic language implementation class.
- `[lib/l10n/app_localizations_en.dart:AppLocalizationsEn]` - English language implementation class.

## Invariants
- `[lib/l10n/app_localizations.dart:AppLocalizations]` requires a valid locale context; throws `FlutterError` if accessed outside a localization scope.

## Side Effects
- None

## Verification
- Run: `flutter test`
