// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/blocs/notifiers/notifications_subscription_notifier.dart';
import 'package:great_quran/data/local/json/all_azkar.dart';
import 'package:great_quran/helpers/enums.dart';
import 'package:great_quran/services/local_notification_service.dart';

void main() {
  test('fromName returns correct AzkarType', () {
    expect(AzkarType.fromName('morning'), AzkarType.morning);
    expect(AzkarType.fromName('evening'), AzkarType.evening);
  });

  test('fromName returns default AzkarType', () {
    expect(AzkarType.fromName('invalid'), AzkarType.morning);
  });
  test("getAzkarCategory returns the right category", () {
    expect(
        NotificationsSubscriptionNotifier(LocalNotificationService())
            .getAzkarCategory("evening"),
        azkarDataList[1]);
  });
}
