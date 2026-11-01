import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/nawawi/view/widgets/nawawi_item.dart';

void main() {
  const sampleHadith = 'إنما الأعمال بالنيات وإنما لكل امرئ ما نوى';

  testWidgets('NawawiHadithCardWidget adapts text color to dark theme onSurface',
      (tester) async {
    const darkTheme = ColorScheme.dark(
      surface: Color(0xFF121212),
      onSurface: Color(0xFFEEEEEE),
      primary: Color(0xFF00B0FF),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: darkTheme),
        home: const Scaffold(
          body: NawawiHadithCardWidget(
            hadithText: sampleHadith,
          ),
        ),
      ),
    );

    final selectableTextFinder = find.byType(SelectableText);
    expect(selectableTextFinder, findsOneWidget);

    final SelectableText textWidget = tester.widget(selectableTextFinder);
    expect(textWidget.style?.color, equals(const Color(0xFFEEEEEE)));
  });

  testWidgets('NawawiHadithCardWidget adapts text color to light theme onSurface',
      (tester) async {
    const lightTheme = ColorScheme.light(
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1A1A1A),
      primary: Color(0xFF00695C),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: lightTheme),
        home: const Scaffold(
          body: NawawiHadithCardWidget(
            hadithText: sampleHadith,
          ),
        ),
      ),
    );

    final selectableTextFinder = find.byType(SelectableText);
    expect(selectableTextFinder, findsOneWidget);

    final SelectableText textWidget = tester.widget(selectableTextFinder);
    expect(textWidget.style?.color, equals(const Color(0xFF1A1A1A)));
  });
}
