import 'dart:convert';
import 'package:great_quran/feature/favorites/logic/models/favorite_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IFavoritesRepository {
  Future<List<FavoriteItem>> getFavorites();
  Future<void> addFavorite(FavoriteItem item);
  Future<void> removeFavorite(String id);
  Future<bool> isFavorite(String id);
}

class FavoritesRepository implements IFavoritesRepository {
  static final provider = Provider<IFavoritesRepository>((ref) {
    return FavoritesRepository();
  });

  static const String _prefKey = 'user_favorites_items_list';

  @override
  Future<List<FavoriteItem>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_prefKey);
      if (jsonList == null || jsonList.isEmpty) {
        return [];
      }
      return jsonList
          .map((item) => FavoriteItem.fromJson(jsonDecode(item)))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> addFavorite(FavoriteItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = await getFavorites();
    currentList.removeWhere((it) => it.id == item.id);
    currentList.insert(0, item);

    final stringList =
        currentList.map((it) => jsonEncode(it.toJson())).toList();
    await prefs.setStringList(_prefKey, stringList);
  }

  @override
  Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = await getFavorites();
    currentList.removeWhere((it) => it.id == id);

    final stringList =
        currentList.map((it) => jsonEncode(it.toJson())).toList();
    await prefs.setStringList(_prefKey, stringList);
  }

  @override
  Future<bool> isFavorite(String id) async {
    final currentList = await getFavorites();
    return currentList.any((it) => it.id == id);
  }
}
