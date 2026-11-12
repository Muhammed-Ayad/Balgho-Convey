# Contact Us Feature Package

## Overview
Provides developer contact information, application metadata, version details, and quick actions to send feedback emails, copy support addresses, or open the Google Play Store listing.

## Interface
- `[lib/feature/contact_us/view/screens/contact_us_screen.dart:ContactUsScreen]` - Main contact screen presenting support cards.
- `[lib/feature/contact_us/view/screens/contact_us_screen.dart:ContactHeaderCard]` - Information banner explaining contact purpose.
- `[lib/feature/contact_us/view/screens/contact_us_screen.dart:ContactEmailActionCard]` - Email launch and copy actions.
- `[lib/feature/contact_us/view/screens/contact_us_screen.dart:ContactAppInfoCard]` - Application version and package info card.

## Invariants
- None

## Side Effects
- Opens external mail clients via `url_launcher`.
- Copies email address to device clipboard via `FlutterClipboard`.

## Verification
- Run: `flutter test test/widget_test.dart`
