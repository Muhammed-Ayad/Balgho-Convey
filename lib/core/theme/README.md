# Core Theme Package

## Overview
Defines design tokens, palette definitions, typography scales, light/dark Material 3 themes, and persistent theme mode state management.

## Interface
- `[lib/core/theme/colors.dart:AppColors]` - Color palette constants for light and dark themes (primary, secondary, surfaces, card backgrounds).
- `[lib/core/theme/dimensions.dart:D]` - Standard spacing and padding constants.
- `[lib/core/theme/font_manager.dart:FontConstants]` - Font family names and typographic weights (`UthmanicHafs`, etc.).
- `[lib/core/theme/text_styles.dart:AppTextStyles]` - TextStyle factory helpers.
- `[lib/core/theme/themes.dart:AppTheme]` - Light and dark `ThemeData` builders.
- `[lib/core/theme/theme_provider.dart:themeModeProvider]` - Riverpod `StateNotifierProvider` exposing current `ThemeMode`.
- `[lib/core/theme/theme_provider.dart:ThemeModeNotifier]` - StateNotifier managing theme state and persisting choices to `SharedPreferences`.

## Invariants
- `[lib/core/theme/theme_provider.dart:ThemeModeNotifier.setThemeMode]` persists theme mode index and safely handles out-of-bounds saved indices with a fallback to `ThemeMode.system`.

## Side Effects
- Reads and writes integer preference key `app_theme_mode_key` in `SharedPreferences`.

## Verification
- Run: `flutter test`
