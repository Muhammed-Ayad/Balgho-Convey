# Tasbih Feature Package

## Overview
Provides a digital electronic rosary (السبحة الإلكترونية) supporting preset and custom dhikr goals, haptic impact feedbacks on count milestones, progress reset, and selection persistence.

## Interface
- `[lib/feature/tasbih/logic/models/tasbih_item.dart:TasbihItem]` - Model containing tasbih item title, hadith fadl reference, target milestone, and current tally.
- `[lib/feature/tasbih/logic/repo/tasbih_repository.dart:ITasbihRepository]` - Contract for persisting active tasbih tallies and indices.
- `[lib/feature/tasbih/logic/repo/tasbih_repository.dart:TasbihRepository]` - Implementation persisting serialized tasbih lists in `SharedPreferences`.
- `[lib/feature/tasbih/logic/repo/tasbih_repository.dart:TasbihRepository.provider]` - Riverpod provider exposing `ITasbihRepository`.
- `[lib/feature/tasbih/logic/providers/tasbih_provider.dart:TasbihState]` - Immutable state holding item list, active index, and vibration toggle.
- `[lib/feature/tasbih/logic/providers/tasbih_provider.dart:TasbihNotifier]` - StateNotifier handling increments, resets, active selection changes, and custom target updates.
- `[lib/feature/tasbih/logic/providers/tasbih_provider.dart:tasbihProvider]` - Riverpod provider exposing `TasbihNotifier`.
- `[lib/feature/tasbih/view/screens/tasbih_screen.dart:TasbihScreen]` - Main interactive tasbih screen with circular tap surface.
- `[lib/feature/tasbih/view/widgets/tasbih_counter_widget.dart:TasbihCounterWidget]` - Circular tap counter with count animation and target progress indicator.
- `[lib/feature/tasbih/view/widgets/tasbih_target_chips.dart:TasbihTargetChips]` - Target selector chips (33, 100, open).
- `[lib/feature/tasbih/view/widgets/tasbih_zekr_selector.dart:TasbihZekrSelector]` - Horizontal selector allowing swapping between preset adhkar.

## Invariants
- `[lib/feature/tasbih/logic/providers/tasbih_provider.dart:TasbihState.currentItem]` clamps active index safely to prevent index-out-of-bounds errors on empty or modified lists.

## Side Effects
- Emits light haptic vibrations on single increment and heavy impact vibration when the target count is achieved (`HapticFeedback.heavyImpact()`).
- Writes active item index and tallies to `SharedPreferences` keys `tasbih_active_index_key` and `tasbih_items_list_key`.

## Verification
- Run: `flutter test test/tasbih_test.dart`
