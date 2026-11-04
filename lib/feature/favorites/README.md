# Favorites Feature Package

## Overview
Provides a unified bookmarking and favorites system across the application, allowing users to save, toggle, and view favorite Azkar, Hadiths, Quranic verses, and Radio stations with local persistence.

## Interface
- `[lib/feature/favorites/logic/models/favorite_item.dart:FavoriteItem]` - Model storing favorite entry with unique id, type, title, subtitle, and timestamp.
- `[lib/feature/favorites/logic/models/favorite_item.dart:FavoriteType]` - Enum specifying favorite content types (`azkar`, `hadith`, `quran`, `radio`).
- `[lib/feature/favorites/logic/repo/favorites_repository.dart:IFavoritesRepository]` - Storage contract for querying and modifying favorites.
- `[lib/feature/favorites/logic/repo/favorites_repository.dart:FavoritesRepository]` - Persistent repository storing serialized JSON records in `SharedPreferences`.
- `[lib/feature/favorites/logic/repo/favorites_repository.dart:FavoritesRepository.provider]` - Riverpod provider exposing `IFavoritesRepository`.
- `[lib/feature/favorites/logic/providers/favorites_provider.dart:FavoritesNotifier]` - StateNotifier managing list of user favorites.
- `[lib/feature/favorites/logic/providers/favorites_provider.dart:FavoritesNotifier.provider]` - Riverpod provider for favorites state.
- `[lib/feature/favorites/logic/providers/favorites_provider.dart:isFavoriteProvider]` - Family provider checking whether a specific item id is bookmarked.
- `[lib/feature/favorites/view/screens/favorites_screen.dart:FavoritesScreen]` - Screen showing categorized favorite items with filter tabs.
- `[lib/feature/favorites/view/widgets/favorite_item_card.dart:FavoriteItemCard]` - Dismissible card representing a bookmarked item with tap navigation and delete action.

## Invariants
- `[lib/feature/favorites/logic/repo/favorites_repository.dart:FavoritesRepository.addFavorite]` guarantees deduplication by removing previous matching IDs before prepending.

## Side Effects
- Reads and writes serialized JSON strings to `SharedPreferences` key `user_favorites_items_list`.

## Verification
- Run: `flutter test test/favorites_test.dart`
