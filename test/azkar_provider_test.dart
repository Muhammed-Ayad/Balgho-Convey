import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/azkar/logic/providers/azkar_category_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AzkarCategoryNotifier tests', () {
    test('Loads category azkar correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state =
          container.read(azkarCategoryProvider("أذكار الصباح")).value!;

      expect(state.category, "أذكار الصباح");
      expect(state.items.isNotEmpty, true);
      expect(state.totalItems, state.items.length);
      expect(state.completedItems, 0);
      expect(state.isAllCompleted, false);
      expect(state.progress, 0.0);
    });

    test('Increment increases count and marks completion when target reached',
        () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier =
          container.read(azkarCategoryProvider("أذكار الصباح").notifier);
      final initialItem = container
          .read(azkarCategoryProvider("أذكار الصباح"))
          .value!
          .items
          .first;

      // Increment all the way to targetCount
      for (int i = 0; i < initialItem.targetCount; i++) {
        notifier.increment(initialItem.id);
      }

      final updatedState =
          container.read(azkarCategoryProvider("أذكار الصباح")).value!;
      final updatedItem =
          updatedState.items.firstWhere((it) => it.id == initialItem.id);

      expect(updatedItem.currentCount, initialItem.targetCount);
      expect(updatedItem.isCompleted, true);
      expect(updatedItem.remainingCount, 0);
      expect(updatedState.completedItems, 1);
      // Item must disappear from activeItems
      expect(
          updatedState.activeItems.any((it) => it.id == initialItem.id), false);
    });

    test('Reset restores all items to 0 and active status', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier =
          container.read(azkarCategoryProvider("أذكار الصباح").notifier);
      final firstItem = container
          .read(azkarCategoryProvider("أذكار الصباح"))
          .value!
          .items
          .first;

      for (int i = 0; i < firstItem.targetCount; i++) {
        notifier.increment(firstItem.id);
      }

      expect(
          container
              .read(azkarCategoryProvider("أذكار الصباح"))
              .value!
              .completedItems,
          1);

      notifier.reset();

      final resetState =
          container.read(azkarCategoryProvider("أذكار الصباح")).value!;
      expect(resetState.completedItems, 0);
      expect(resetState.items.every((it) => it.currentCount == 0), true);
      expect(resetState.items.every((it) => !it.isCompleted), true);
      expect(resetState.activeItems.length, resetState.totalItems);
    });
  });
}
