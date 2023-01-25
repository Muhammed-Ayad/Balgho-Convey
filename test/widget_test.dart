// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/ui/app.dart';

void main() async {
  await EasyLocalization.ensureInitialized();
  testWidgets("Test App Title Success", (widgetTester) async {
    await widgetTester.pumpWidget(
      EasyLocalization(
        path: 'assets/translations',
        supportedLocales: const [
          Locale("ar"),
        ],
        child: ProviderScope(
          child: MyApp(),
        ),
      ),
    );
    await widgetTester.pumpAndSettle();
    final titleFinder = find.text("بلغوا عني ولو آية");

    expect(titleFinder, findsOneWidget);
  });
}
