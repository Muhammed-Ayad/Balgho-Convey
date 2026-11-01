import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/notifications/logic/models/notification_settings_model.dart';
import 'package:great_quran/feature/notifications/logic/repo/notification_settings_repository.dart';
import 'package:great_quran/feature/notifications/view/screens/notifications_settings_screen.dart';
import 'package:great_quran/feature/notifications/view/widgets/notification_category_container.dart';
import 'package:great_quran/feature/notifications/view/widgets/notification_master_card.dart';
import 'package:great_quran/feature/notifications/view/widgets/notification_switch_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('NotificationSettingsModel tests', () {
    test('Defaults are properly configured', () {
      const model = NotificationSettingsModel();
      expect(model.allNotificationsEnabled, true);
      expect(model.prayerNotificationsEnabled, true);
      expect(model.fajr, true);
      expect(model.dhuhr, true);
      expect(model.asr, true);
      expect(model.maghrib, true);
      expect(model.isha, true);
      expect(model.prayerPreReminder, true);
      expect(model.azkarNotificationsEnabled, true);
      expect(model.morningAzkar, true);
      expect(model.eveningAzkar, true);
      expect(model.sleepAzkar, true);
      expect(model.dailyZekrEnabled, true);
      expect(model.dailyHadithEnabled, true);
      expect(model.sunanEnabled, true);
      expect(model.duhaPrayer, true);
      expect(model.qiyamNight, true);
      expect(model.occasionsEnabled, true);
      expect(model.fridayKahf, true);
      expect(model.fastingMondayThursday, true);
    });

    test('Serialization and deserialization matches', () {
      const model = NotificationSettingsModel(
        allNotificationsEnabled: false,
        fajr: false,
        morningAzkar: false,
        duhaPrayer: false,
      );

      final json = model.toJson();
      final fromJson = NotificationSettingsModel.fromJson(json);

      expect(fromJson.allNotificationsEnabled, false);
      expect(fromJson.fajr, false);
      expect(fromJson.morningAzkar, false);
      expect(fromJson.duhaPrayer, false);
      expect(fromJson.dhuhr, true);
    });

    test('copyWith works correctly', () {
      const model = NotificationSettingsModel();
      final updated = model.copyWith(
        allNotificationsEnabled: false,
        wakeUpAzkar: true,
      );

      expect(updated.allNotificationsEnabled, false);
      expect(updated.wakeUpAzkar, true);
      expect(updated.fajr, true);
    });
  });

  group('NotificationSettingsRepository tests', () {
    test('Loads default values when nothing is stored', () async {
      final repo = NotificationSettingsRepository();
      final settings = await repo.getSettings();

      expect(settings.allNotificationsEnabled, true);
      expect(settings.prayerNotificationsEnabled, true);
    });

    test('Saves and retrieves modified settings', () async {
      final repo = NotificationSettingsRepository();
      const custom = NotificationSettingsModel(
        allNotificationsEnabled: false,
        prayerNotificationsEnabled: false,
        fajr: false,
      );

      await repo.saveSettings(custom);
      final retrieved = await repo.getSettings();

      expect(retrieved.allNotificationsEnabled, false);
      expect(retrieved.prayerNotificationsEnabled, false);
      expect(retrieved.fajr, false);
    });
  });

  group('Notification Widgets tests', () {
    testWidgets('NotificationMasterCard renders properly', (tester) async {
      bool changed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationMasterCard(
              isEnabled: true,
              onChanged: (val) {
                changed = val;
              },
            ),
          ),
        ),
      );

      expect(find.text("تفعيل كافة الإشعارات"), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);

      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(changed, false);
    });

    testWidgets('NotificationCategoryContainer renders header and items',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NotificationCategoryContainer(
              icon: Icons.mosque_rounded,
              title: "مواقيت الصلوات الخمس",
              subtitle: "تنبيهات بدخول وقت كل صلاة",
              isCategoryEnabled: true,
              children: [
                NotificationSwitchItem(
                  title: "صلاة الفجر",
                  value: true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text("مواقيت الصلوات الخمس"), findsOneWidget);
      expect(find.text("صلاة الفجر"), findsOneWidget);
    });

    testWidgets('NotificationsSettingsScreen displays in ProviderScope',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: NotificationsSettingsScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text("مركز الإشعارات والتنبيهات"), findsOneWidget);
      expect(find.text("تفعيل كافة الإشعارات"), findsOneWidget);
    });
  });
}
