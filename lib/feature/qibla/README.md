# Qibla Feature Package

## Overview
Computes the geographic Qibla bearing towards the Kaaba (Mecca) using spherical coordinates and device GPS location, pairing with the device compass sensor (`flutter_compass`) to rotate a dynamic interactive dial.

## Interface
- `[lib/feature/qibla/logic/repo/qibla_repository.dart:IQiblaRepository]` - Repository interface defining calculation of Qibla bearing angle.
- `[lib/feature/qibla/logic/repo/qibla_repository.dart:QiblaRepository]` - Calculates azimuth angle from latitude/longitude using `adhan.Qibla.qibla()`.
- `[lib/feature/qibla/logic/repo/qibla_repository.dart:QiblaRepository.provider]` - Riverpod provider exposing `IQiblaRepository`.
- `[lib/feature/qibla/logic/providers/qibla_provider.dart:compassStreamProvider]` - Stream provider emitting hardware `CompassEvent` updates.
- `[lib/feature/qibla/logic/providers/qibla_provider.dart:QiblaDirectionNotifier]` - StateNotifier managing Qibla angle state.
- `[lib/feature/qibla/logic/providers/qibla_provider.dart:QiblaDirectionNotifier.provider]` - Riverpod provider exposing `QiblaDirectionNotifier`.
- `[lib/feature/qibla/view/screens/qibla_screen.dart:QiblaScreen]` - Full screen presenting animated compass dial, direction angle, and calibration options.
- `[lib/feature/qibla/view/widgets/qibla_compass_dial.dart:QiblaCompassDial]` - Rotatable compass dial rendering needle, degree markings, and Kaaba icon.
- `[lib/feature/qibla/view/widgets/qibla_bottom_bar.dart:QiblaBottomBar]` - Bottom informational bar showing current angle and calibration prompts.
- `[lib/feature/qibla/view/widgets/qibla_calibration_dialog.dart:QiblaCalibrationDialog]` - Dialog explaining the figure-8 sensor calibration motion.
- `[lib/feature/qibla/view/widgets/qibla_fallback_widget.dart:QiblaFallbackWidget]` - Graceful fallback shown when hardware magnetometer is absent.

## Invariants
- `[lib/feature/qibla/logic/providers/qibla_provider.dart:compassStreamProvider]` enforces a 4-second timeout to detect missing or stalled compass sensors.
- Emits lightweight haptic tick when the compass needle aligns within ±2° of the target Qibla bearing.

## Side Effects
- Listens to device magnetometer and orientation sensors.
- Requests location permission via `LocationService`.

## Verification
- Run: `flutter test test/qibla_test.dart`
