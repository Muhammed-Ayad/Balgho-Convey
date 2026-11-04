# Home Feature Package

## Overview
Main dashboard screen and presentation layer consolidating upcoming prayer countdowns, quick access cards for Quran and Azkar, feature grid tiles, and instructions for native Android AppWidgets.

## Interface
- `[lib/feature/home/logic/providers/next_prayer_provider.dart:NextPrayerModel]` - View model representing next upcoming prayer name, time, and remaining duration.
- `[lib/feature/home/logic/providers/next_prayer_provider.dart:nextPrayerTickerProvider]` - Periodic 30-second stream ticker keeping countdowns fresh.
- `[lib/feature/home/logic/providers/next_prayer_provider.dart:nextPrayerProvider]` - Provider computing the imminent prayer from `AzanTimeNotifier` calculations.
- `[lib/feature/home/view/screens/home_screen.dart:HomeScreen]` - Root home dashboard composing banners, prayer cards, and navigation grids.
- `[lib/feature/home/view/screens/widgets_guide_screen.dart:WidgetsGuideScreen]` - Visual tutorial screen guiding users on adding native Android AppWidgets.
- `[lib/feature/home/view/widgets/next_prayer_card.dart:NextPrayerCard]` - Dashboard header card rendering the next prayer countdown.
- `[lib/feature/home/view/widgets/feature_grid_card.dart:FeatureGridCard]` - Reusable menu item card for main feature navigation.
- `[lib/feature/home/view/widgets/morning_evening_azkar_card.dart:MorningEveningAzkarCard]` - Dynamic banner offering morning or evening azkar based on the time of day.
- `[lib/feature/home/view/widgets/quran_home_card.dart:QuranHomeCard]` - Shortcut card to resume Quran reading.
- `[lib/feature/home/view/widgets/section_header.dart:SectionHeader]` - Section divider title widget.

## Invariants
- `[lib/feature/home/logic/providers/next_prayer_provider.dart:nextPrayerTickerProvider]` disposes its periodic timer when no longer watched.

## Side Effects
- None

## Verification
- Run: `flutter test test/widget_test.dart`
