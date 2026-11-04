# Habits Feature Package

## Overview
Tracks daily Islamic habits, sunan prayers, and acts of worship with daily progress indicators, completion streaks, and day-scoped local persistence.

## Interface
- `[lib/feature/habits/logic/models/habit_item.dart:HabitItem]` - Model defining a habit with identifier, title, description, category, and completion flag.
- `[lib/feature/habits/logic/models/habit_item.dart:HabitCategory]` - Categorization enum (`sunan`, `azkar`, `quran`, `other`).
- `[lib/feature/habits/logic/models/habit_item.dart:DailyHabitsState]` - Aggregate daily habit state containing list of habits, completion count, and streak count.
- `[lib/feature/habits/logic/repo/habits_repository.dart:IHabitsRepository]` - Contract for loading and toggling daily habits.
- `[lib/feature/habits/logic/repo/habits_repository.dart:HabitsRepository]` - Storage implementation saving completed habit IDs keyed by day (`habits_day_yyyy-MM-dd`) in `SharedPreferences`.
- `[lib/feature/habits/logic/repo/habits_repository.dart:HabitsRepository.provider]` - Riverpod provider exposing `IHabitsRepository`.
- `[lib/feature/habits/logic/providers/habits_provider.dart:DailyHabitsNotifier]` - StateNotifier orchestrating habit toggles and progress updates.
- `[lib/feature/habits/logic/providers/habits_provider.dart:DailyHabitsNotifier.provider]` - Riverpod provider for daily habits state.
- `[lib/feature/habits/view/screens/habits_screen.dart:HabitsScreen]` - Screen displaying progress ring, streak card, and categorized habit checklists.
- `[lib/feature/habits/view/widgets/habit_progress_card.dart:HabitProgressCard]` - Progress overview widget displaying percentage completed.
- `[lib/feature/habits/view/widgets/habit_tile_widget.dart:HabitTileWidget]` - Interactive checkbox tile toggling a specific habit.

## Invariants
- Habit completions are scoped per date (`yyyy-MM-dd`); crossing midnight automatically initializes an unchecked list for the new date while maintaining streak calculations.

## Side Effects
- Emits haptic vibration on habit toggle via `HapticFeedback.lightImpact()`.
- Reads/writes date-scoped keys and streak records in `SharedPreferences`.

## Verification
- Run: `flutter test test/habits_test.dart`
