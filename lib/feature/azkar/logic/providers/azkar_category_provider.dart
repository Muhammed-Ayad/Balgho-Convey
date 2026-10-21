import 'package:flutter/services.dart';
import 'package:great_quran/feature/azkar/logic/data/azkar_list.dart';
import 'package:great_quran/feature/azkar/logic/models/azkar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ZekrProgressItem {
  final int id;
  final Azkar zekr;
  final int targetCount;
  final int currentCount;
  final bool isCompleted;

  const ZekrProgressItem({
    required this.id,
    required this.zekr,
    required this.targetCount,
    this.currentCount = 0,
    this.isCompleted = false,
  });

  int get remainingCount => (targetCount - currentCount).clamp(0, targetCount);

  ZekrProgressItem copyWith({
    int? currentCount,
    bool? isCompleted,
  }) {
    return ZekrProgressItem(
      id: id,
      zekr: zekr,
      targetCount: targetCount,
      currentCount: currentCount ?? this.currentCount,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class AzkarCategoryState {
  final String category;
  final List<ZekrProgressItem> items;

  const AzkarCategoryState({
    required this.category,
    required this.items,
  });

  List<ZekrProgressItem> get activeItems =>
      items.where((item) => !item.isCompleted).toList();

  int get totalItems => items.length;
  int get completedItems => items.where((item) => item.isCompleted).length;
  double get progress => totalItems == 0 ? 0.0 : completedItems / totalItems;
  bool get isAllCompleted => totalItems > 0 && completedItems == totalItems;
}

class AzkarCategoryNotifier
    extends StateNotifier<AsyncValue<AzkarCategoryState>> {
  final String category;

  AzkarCategoryNotifier(this.category) : super(const AsyncValue.loading()) {
    loadCategoryAzkar();
  }

  void loadCategoryAzkar() {
    try {
      final matching =
          azkarDB.where((element) => element.containsValue(category)).toList();

      final List<ZekrProgressItem> items = [];
      for (var i = 0; i < matching.length; i++) {
        final azkar = Azkar.fromJson(matching[i]);
        final target = int.tryParse(azkar.count) ?? 1;
        items.add(ZekrProgressItem(
          id: i,
          zekr: azkar,
          targetCount: target <= 0 ? 1 : target,
        ));
      }

      state = AsyncValue.data(
        AzkarCategoryState(
          category: category,
          items: items,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void increment(int id) {
    state.whenData((currentState) {
      final updatedItems = currentState.items.map((item) {
        if (item.id == id && !item.isCompleted) {
          final newCount = item.currentCount + 1;
          final isDone = newCount >= item.targetCount;
          if (isDone) {
            HapticFeedback.mediumImpact();
          } else {
            HapticFeedback.lightImpact();
          }
          return item.copyWith(
            currentCount: newCount,
            isCompleted: isDone,
          );
        }
        return item;
      }).toList();

      state = AsyncValue.data(
        AzkarCategoryState(
          category: currentState.category,
          items: updatedItems,
        ),
      );
    });
  }

  void reset() {
    state.whenData((currentState) {
      final resetItems = currentState.items.map((item) {
        return item.copyWith(
          currentCount: 0,
          isCompleted: false,
        );
      }).toList();

      state = AsyncValue.data(
        AzkarCategoryState(
          category: currentState.category,
          items: resetItems,
        ),
      );
      HapticFeedback.mediumImpact();
    });
  }
}

final azkarCategoryProvider = StateNotifierProvider.autoDispose
    .family<AzkarCategoryNotifier, AsyncValue<AzkarCategoryState>, String>(
  (ref, category) => AzkarCategoryNotifier(category),
);
