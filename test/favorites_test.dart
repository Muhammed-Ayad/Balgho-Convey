import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/favorites/logic/models/favorite_item.dart';
import 'package:great_quran/feature/favorites/logic/repo/favorites_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('FavoritesRepository tests', () {
    test('Starts empty and adds/removes items correctly', () async {
      final repo = FavoritesRepository();
      final initial = await repo.getFavorites();
      expect(initial, isEmpty);

      final item = FavoriteItem(
        id: 'test_zekr_1',
        title: 'أذكار الصباح',
        content: 'اللهم بك أصبحنا',
        extraData: 'أذكار الصباح',
        type: FavoriteType.zekr,
        createdAt: DateTime.now(),
      );

      await repo.addFavorite(item);
      final afterAdd = await repo.getFavorites();
      expect(afterAdd.length, 1);
      expect(afterAdd.first.id, 'test_zekr_1');
      expect(await repo.isFavorite('test_zekr_1'), true);

      await repo.removeFavorite('test_zekr_1');
      final afterRemove = await repo.getFavorites();
      expect(afterRemove, isEmpty);
      expect(await repo.isFavorite('test_zekr_1'), false);
    });
  });
}
