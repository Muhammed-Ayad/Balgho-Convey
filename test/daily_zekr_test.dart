import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/daily_zekr/logic/providers/daily_zekr_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('DailyZekr tests', () {
    test('Returns valid daily zekr or hadith', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final daily = container.read(dailyZekrProvider);

      expect(daily.text.isNotEmpty, true);
      expect(daily.reference.isNotEmpty, true);
      expect(kDailyZekrList.contains(daily), true);
    });
  });
}
