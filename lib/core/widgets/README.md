# Core Widgets Package

## Overview
Houses reusable shared UI components including application bars, state indicators (loading, error, empty), Lottie animation containers, and permission rationale dialogs.

## Interface
- `[lib/core/widgets/app_lottie_widget.dart:AppLottieWidget]` - Lottie animation container with size controls and error fallbacks.
- `[lib/core/widgets/custom_app_bar.dart:CustomAppBar]` - Standardized application top app bar with title and action styling.
- `[lib/core/widgets/empty_state_widget.dart:EmptyStateWidget]` - Reusable placeholder for empty data lists.
- `[lib/core/widgets/error_widget.dart:CustomErrorWidget]` - Standardized error view with retry callback.
- `[lib/core/widgets/loading_widget.dart:LoadingWidget]` - Circular/Spinkit loading indicator for asynchronous operations.
- `[lib/core/widgets/location_rationale_dialog.dart:LocationRationaleDialog]` - Dialog explaining location usage before requesting device permissions.

## Invariants
- `[lib/core/widgets/custom_app_bar.dart:CustomAppBar]` implements `PreferredSizeWidget` with a default toolbar height.

## Side Effects
- None

## Verification
- Run: `flutter test test/widget_test.dart`
