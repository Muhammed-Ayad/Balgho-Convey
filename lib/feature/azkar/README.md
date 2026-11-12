# Azkar Feature Package

## Overview
Provides Islamic supplications (Hisn al-Muslim) categorized across over 130 chapters. Includes interactive tap counters with haptic feedback, search and section filtering, and reminder subscriptions.

## Interface
- `[lib/feature/azkar/logic/models/azkar.dart:Azkar]` - Data model representing a supplication item with text, description, and repeat count.
- `[lib/feature/azkar/logic/repo/azkar_repository.dart:IAzkarRepository]` - Repository contract for retrieving Azkar categories and supplications.
- `[lib/feature/azkar/logic/repo/azkar_repository.dart:AzkarRepository]` - Local repository implementation backed by compiled in-memory Azkar data.
- `[lib/feature/azkar/logic/repo/azkar_repository.dart:AzkarRepository.provider]` - Riverpod provider exposing `IAzkarRepository`.
- `[lib/feature/azkar/logic/providers/azkar_category_provider.dart:AzkarCategoryNotifier]` - StateNotifier managing progress per zekr (`incrementCount`, `resetCategory`, `completeAll`).
- `[lib/feature/azkar/logic/providers/azkar_category_provider.dart:azkarCategoryProvider]` - Family provider returning category progress state.
- `[lib/feature/azkar/logic/providers/notifications_subscription_notifier.dart:NotificationSubscriptionNotifier]` - Manages user notification subscription toggles for categories.
- `[lib/feature/azkar/view/screens/azkar_screen.dart:AzkarScreen]` - Screen displaying searchable category list with chips filtering.
- `[lib/feature/azkar/view/screens/azkar_category_screen.dart:AzkarCategoryScreen]` - Screen showing supplications within a selected category with interactive counters.
- `[lib/feature/azkar/view/widgets/zekr_card.dart:ZekrCard]` - Card rendering supplication text, fadl (benefit), remaining count, and tap feedback.
- `[lib/feature/azkar/view/widgets/azkar_category_tile.dart:AzkarCategoryTile]` - List tile for category navigation.
- `[lib/feature/azkar/view/widgets/azkar_search_field.dart:AzkarSearchField]` - Search input for finding specific categories or supplications.
- `[lib/feature/azkar/view/widgets/azkar_section_chips.dart:AzkarSectionChips]` - Filter chips for quickly scoping categories.

## Invariants
- `[lib/feature/azkar/logic/providers/azkar_category_provider.dart:ZekrProgressItem.remainingCount]` never decrements below 0.
- Category data is served synchronously from offline embedded datasets.

## Side Effects
- Emits light and medium haptic vibration feedback via `HapticFeedback.lightImpact()` and `HapticFeedback.heavyImpact()` upon tapping or completing a zekr.

## Verification
- Run: `flutter test test/azkar_provider_test.dart`
