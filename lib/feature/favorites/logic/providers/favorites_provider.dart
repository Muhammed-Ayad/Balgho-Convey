import 'package:great_quran/feature/favorites/logic/models/favorite_item.dart';
import 'package:great_quran/feature/favorites/logic/repo/favorites_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoritesNotifier extends StateNotifier<AsyncValue<List<FavoriteItem>>> {
  static final provider =
      StateNotifierProvider<FavoritesNotifier, AsyncValue<List<FavoriteItem>>>(
          (ref) {
    return FavoritesNotifier(ref.read(FavoritesRepository.provider));
  });

  final IFavoritesRepository _repository;

  FavoritesNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getFavorites());
  }

  Future<bool> toggleFavorite(FavoriteItem item) async {
    final isFav = await _repository.isFavorite(item.id);
    if (isFav) {
      await _repository.removeFavorite(item.id);
    } else {
      await _repository.addFavorite(item);
    }
    await fetchFavorites();
    return !isFav;
  }

  Future<void> removeFavorite(String id) async {
    await _repository.removeFavorite(id);
    await fetchFavorites();
  }

  bool isItemFavorite(String id) {
    return state.value?.any((item) => item.id == id) ?? false;
  }
}

final isFavoriteProvider = Provider.family<bool, String>((ref, id) {
  final state = ref.watch(FavoritesNotifier.provider);
  return state.value?.any((item) => item.id == id) ?? false;
});
