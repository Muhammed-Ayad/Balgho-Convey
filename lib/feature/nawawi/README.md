# Nawawi Feature Package

## Overview
Provides the full text, Arabic commentary, and audio listening references for the Forty Hadith of Imam al-Nawawi (الأربعون النووية), loaded from local JSON asset bundles.

## Interface
- `[lib/feature/nawawi/logic/models/nawawi.dart:Nawawi]` - Data model for each hadith including title, hadith text, and detailed explanation.
- `[lib/feature/nawawi/logic/repo/nawawi_repository.dart:INawawiRepository]` - Repository contract for retrieving Forty Hadiths.
- `[lib/feature/nawawi/logic/repo/nawawi_repository.dart:NawawiRepository]` - Asset-backed repository reading `assets/json/nawawi.json`.
- `[lib/feature/nawawi/logic/repo/nawawi_repository.dart:NawawiRepository.provider]` - Riverpod provider exposing `INawawiRepository`.
- `[lib/feature/nawawi/logic/providers/nawawi_provider.dart:NawawiNotifier]` - StateNotifier managing `AsyncValue<List<Nawawi>>`.
- `[lib/feature/nawawi/logic/providers/nawawi_provider.dart:NawawiNotifier.provider]` - Riverpod provider exposing `NawawiNotifier`.
- `[lib/feature/nawawi/view/screens/nawawi_screen.dart:NawawiScreen]` - Grid/list view displaying the 42 prophetic traditions.
- `[lib/feature/nawawi/view/widgets/nawawi_item.dart:NawawiItemWidget]` - Hadith list tile with bookmarking and share actions.
- `[lib/feature/nawawi/view/widgets/nawawi_explanation_sheet.dart:NawawiExplanationSheet]` - Bottom sheet rendering the comprehensive textual explanation for a hadith.
- `[lib/feature/nawawi/view/widgets/nawawi_dialog.dart:NawawiDialog]` - Dialog modal presenting hadith details.

## Invariants
- Hadith content is loaded offline from local bundle resources (`assets/json/nawawi.json`) with zero network reliance.

## Side Effects
- Copies hadith text to system clipboard.
- Dispatches native system share sheet via `share_plus`.

## Verification
- Run: `flutter test test/nawawi_theme_test.dart`
