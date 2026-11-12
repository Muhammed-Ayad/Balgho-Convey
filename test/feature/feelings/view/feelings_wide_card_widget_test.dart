import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/home/view/widgets/feature_grid_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('FeelingsWideCardWidget renders title, subtitle, and badge correctly',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FeelingsWideCardWidget(),
        ),
      ),
    );

    expect(find.text("ما الذي تشعر به الآن؟"), findsOneWidget);
    expect(find.text("اختر حالتك، ودع القرآن يمنحك السكينة"), findsOneWidget);
    expect(find.text("تدبّر"), findsOneWidget);
    expect(find.byIcon(Icons.auto_awesome_rounded), findsOneWidget);
  });
}
