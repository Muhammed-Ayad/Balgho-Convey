import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/tasbih/logic/models/tasbih_item.dart';
import 'package:great_quran/feature/tasbih/logic/providers/tasbih_provider.dart';
import 'package:great_quran/feature/tasbih/logic/repo/tasbih_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MockTasbihRepository implements ITasbihRepository {
  List<TasbihItem> items = [...TasbihRepository.defaultItems];
  int active = 0;

  @override
  Future<List<TasbihItem>> getTasbihList() async => items;

  @override
  Future<void> saveTasbihList(List<TasbihItem> newItems) async {
    items = [...newItems];
  }

  @override
  Future<int> getActiveIndex() async => active;

  @override
  Future<void> saveActiveIndex(int index) async {
    active = index;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tasbih tests', () {
    test('Initializes with default items and active item', () async {
      final mockRepo = MockTasbihRepository();
      final container = ProviderContainer(
        overrides: [
          TasbihRepository.provider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      // Wait for initialization
      await container.read(tasbihProvider.notifier).stream.first;

      final state = container.read(tasbihProvider).value!;
      expect(state.items.isNotEmpty, true);
      expect(state.activeIndex, 0);
      expect(state.currentItem.title, "سُبْحَانَ اللَّهِ");
      expect(state.currentItem.count, 0);
    });

    test('Increment increases count and total count', () async {
      final mockRepo = MockTasbihRepository();
      final container = ProviderContainer(
        overrides: [
          TasbihRepository.provider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(tasbihProvider.notifier).stream.first;

      final notifier = container.read(tasbihProvider.notifier);
      notifier.increment();
      notifier.increment();

      final state = container.read(tasbihProvider).value!;
      expect(state.currentItem.count, 2);
      expect(state.currentItem.totalCount, 2);
    });

    test('ResetCurrent resets count to 0 but preserves totalCount', () async {
      final mockRepo = MockTasbihRepository();
      final container = ProviderContainer(
        overrides: [
          TasbihRepository.provider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(tasbihProvider.notifier).stream.first;

      final notifier = container.read(tasbihProvider.notifier);
      notifier.increment();
      notifier.increment();
      expect(container.read(tasbihProvider).value!.currentItem.count, 2);

      notifier.resetCurrent();

      final state = container.read(tasbihProvider).value!;
      expect(state.currentItem.count, 0);
      expect(state.currentItem.totalCount, 2);
    });

    test('Selecting another zekr switches active item', () async {
      final mockRepo = MockTasbihRepository();
      final container = ProviderContainer(
        overrides: [
          TasbihRepository.provider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(tasbihProvider.notifier).stream.first;

      final notifier = container.read(tasbihProvider.notifier);
      notifier.selectZekr(1);

      final state = container.read(tasbihProvider).value!;
      expect(state.activeIndex, 1);
      expect(state.currentItem.title, "الْحَمْدُ لِلَّهِ");
    });

    test('Setting target updates active item target', () async {
      final mockRepo = MockTasbihRepository();
      final container = ProviderContainer(
        overrides: [
          TasbihRepository.provider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(tasbihProvider.notifier).stream.first;

      final notifier = container.read(tasbihProvider.notifier);
      notifier.setTarget(100);

      final state = container.read(tasbihProvider).value!;
      expect(state.currentItem.target, 100);
    });
  });
}
