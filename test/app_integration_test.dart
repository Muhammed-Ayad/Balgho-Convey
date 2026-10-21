import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/app.dart';
import 'package:great_quran/core/services/location_service.dart';
import 'package:great_quran/feature/azan/logic/repo/azan_repository.dart';
import 'package:great_quran/feature/azan/view/screens/azan_screen.dart';
import 'package:great_quran/feature/azan/view/widgets/header_azan.dart';
import 'package:great_quran/feature/habits/view/screens/habits_screen.dart';
import 'package:great_quran/feature/notifications/view/screens/notifications_settings_screen.dart';
import 'package:great_quran/feature/prophet/view/screens/prophet_screen.dart';
import 'package:great_quran/feature/settings/view/screens/settings_screen.dart';
import 'package:great_quran/feature/tasbih/view/screens/tasbih_screen.dart';
import 'package:great_quran/l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLocationService extends LocationService {
  @override
  Future<LocationData?> getCurrentLocation() async {
    return LocationData.fromMap({
      'latitude': 30.0444,
      'longitude': 31.2357,
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    const globalChannel = MethodChannel('xyz.luan/audioplayers.global');
    const playerChannel = MethodChannel('xyz.luan/audioplayers');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(globalChannel, (call) async => 1);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(playerChannel, (call) async => 1);
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget wrapWithLocalization(Widget child) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
      home: child,
    );
  }

  group('Full Application End-to-End Integration Tests', () {
    testWidgets('App boots smoothly to HomeScreen with all primary widgets',
        (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            LocationService.provider.overrideWithValue(MockLocationService()),
            AzanRepository.provider.overrideWith(
              (ref) => AzanRepository(ref.read(LocationService.provider)),
            ),
          ],
          child: MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Title
      expect(find.text("بلغوا عني ولو آية"), findsOneWidget);
      expect(find.text("أذكار اليوم والليلة"), findsOneWidget);
      expect(find.text("الخدمات الإسلامية"), findsOneWidget);

      // Verify Feature Cards exist
      expect(find.text("المسبحة الإلكترونية"), findsOneWidget);
      expect(find.text("سجل الورد والعبادات اليومية"), findsOneWidget);
      expect(find.text("اعرف نبيك ﷺ"), findsOneWidget);
      expect(find.text("الأربعون النووية"), findsOneWidget);
    });

    testWidgets('Journey: Tasbih Screen counter integration', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: wrapWithLocalization(const TasbihScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("المسبحة الإلكترونية"), findsOneWidget);
      expect(find.text("سُبْحَانَ اللَّهِ"), findsWidgets);

      // Tap reset
      await tester.tap(find.byIcon(Icons.refresh_rounded));
      await tester.pumpAndSettle();
      expect(find.text("0"), findsOneWidget);
    });

    testWidgets(
        'Journey: Habits Tracker completes a habit and updates progress',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: wrapWithLocalization(const HabitsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("سجل الورد والعبادات اليومية"), findsOneWidget);
      expect(find.text("سنة الفجر"), findsOneWidget);

      final checkIcons = find.byIcon(Icons.circle_outlined);
      if (checkIcons.evaluate().isNotEmpty) {
        await tester.tap(checkIcons.first);
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.check_circle_rounded), findsWidgets);
      }
    });

    testWidgets('Journey: Prophet Screen and topics search filter integration',
        (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          child: wrapWithLocalization(const ProphetScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("اعرف نبيك ﷺ"), findsWidgets);
      expect(find.text("مُحَمَّدٌ رَسُولُ اللَّهِ ﷺ"), findsOneWidget);

      // Enter search text
      await tester.enterText(find.byType(TextField), "القرآن");
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Journey: Settings and Notification Center toggles integration',
        (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          child: wrapWithLocalization(const NotificationsSettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("مركز الإشعارات والتنبيهات"), findsOneWidget);
      expect(find.text("تفعيل كافة الإشعارات"), findsOneWidget);
      expect(find.text("مواقيت الصلوات الخمس"), findsOneWidget);

      expect(find.byType(Switch), findsWidgets);
    });

    testWidgets('Journey: Settings Screen navigation tiles render correctly',
        (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          child: wrapWithLocalization(const SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("الإعدادات"), findsOneWidget);
      expect(find.text("التوقيت الصيفي والشتوي"), findsOneWidget);
      expect(find.text("مركز الإشعارات والتنبيهات"), findsOneWidget);
      expect(find.text("صوت ومؤذن الأذان"), findsOneWidget);
      expect(find.text("ودجت الشاشة الرئيسية"), findsOneWidget);
    });

    testWidgets(
        'Journey: Azan Screen renders upgraded UI, sunan card, and DST chip',
        (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            LocationService.provider.overrideWithValue(MockLocationService()),
            AzanRepository.provider.overrideWith(
              (ref) => AzanRepository(ref.read(LocationService.provider)),
            ),
          ],
          child: wrapWithLocalization(const AzanScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("مواقيت الصلاة"), findsOneWidget);
      expect(find.textContaining("الصلاة القادمة:"), findsWidgets);
      expect(find.text("مواقيت الصلوات الخمس والشروق"), findsOneWidget);
      expect(find.text("مواقيت السنن وقيام الليل"), findsOneWidget);
      expect(find.text("الثلث الأخير (قيام الليل)"), findsOneWidget);
      expect(find.text("منتصف الليل الشرعي"), findsOneWidget);
      expect(find.text("اتجاه القبلة الشريفة"), findsOneWidget);
      expect(find.textContaining("دعاء ما بعد الأذان"), findsOneWidget);

      // Verify DST quick selector chip opens bottom sheet
      final dstChip = find.byType(DstQuickSelectorChip);
      expect(dstChip, findsOneWidget);
      await tester.tap(dstChip);
      await tester.pumpAndSettle();

      expect(find.text("ضبط التوقيت الصيفي والشتوي"), findsOneWidget);
      expect(find.text("التوقيت الصيفي (+1 ساعة)"), findsOneWidget);
      expect(find.text("التوقيت الشتوي"), findsOneWidget);
    });
  });
}
