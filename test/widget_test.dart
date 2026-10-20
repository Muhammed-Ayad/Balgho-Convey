import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  testWidgets("Test App Title Success", (widgetTester) async {
    await widgetTester.pumpWidget(
      ProviderScope(
        child: MyApp(),
      ),
    );
    await widgetTester.pumpAndSettle();
    final titleFinder = find.text("بلغوا عني ولو آية");

    expect(titleFinder, findsOneWidget);
  });
}
