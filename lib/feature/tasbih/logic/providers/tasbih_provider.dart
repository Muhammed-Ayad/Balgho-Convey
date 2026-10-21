import 'package:flutter/services.dart';
import 'package:great_quran/feature/tasbih/logic/models/tasbih_item.dart';
import 'package:great_quran/feature/tasbih/logic/repo/tasbih_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TasbihState {
  final List<TasbihItem> items;
  final int activeIndex;
  final bool vibrateEnabled;

  const TasbihState({
    required this.items,
    this.activeIndex = 0,
    this.vibrateEnabled = true,
  });

  TasbihItem get currentItem {
    if (items.isEmpty) {
      return const TasbihItem(id: 0, title: "سُبْحَانَ اللَّهِ");
    }
    final safeIndex = activeIndex.clamp(0, items.length - 1);
    return items[safeIndex];
  }

  TasbihState copyWith({
    List<TasbihItem>? items,
    int? activeIndex,
    bool? vibrateEnabled,
  }) {
    return TasbihState(
      items: items ?? this.items,
      activeIndex: activeIndex ?? this.activeIndex,
      vibrateEnabled: vibrateEnabled ?? this.vibrateEnabled,
    );
  }
}

class TasbihNotifier extends StateNotifier<AsyncValue<TasbihState>> {
  final ITasbihRepository _repo;

  TasbihNotifier(this._repo) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final items = await _repo.getTasbihList();
      final active = await _repo.getActiveIndex();
      state = AsyncValue.data(
        TasbihState(
          items: items,
          activeIndex: active,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void increment() {
    state.whenData((s) {
      final item = s.currentItem;
      final newCount = item.count + 1;
      final newTotal = item.totalCount + 1;

      final isTargetReached = item.target > 0 && newCount % item.target == 0;

      if (s.vibrateEnabled) {
        if (isTargetReached) {
          HapticFeedback.heavyImpact();
        } else {
          HapticFeedback.lightImpact();
        }
      }

      final updatedItems = [...s.items];
      updatedItems[s.activeIndex] = item.copyWith(
        count: newCount,
        totalCount: newTotal,
      );

      state = AsyncValue.data(s.copyWith(items: updatedItems));
      _repo.saveTasbihList(updatedItems);
    });
  }

  void resetCurrent() {
    state.whenData((s) {
      final item = s.currentItem;
      final updatedItems = [...s.items];
      updatedItems[s.activeIndex] = item.copyWith(count: 0);

      if (s.vibrateEnabled) {
        HapticFeedback.mediumImpact();
      }

      state = AsyncValue.data(s.copyWith(items: updatedItems));
      _repo.saveTasbihList(updatedItems);
    });
  }

  void selectZekr(int index) {
    state.whenData((s) {
      if (index >= 0 && index < s.items.length) {
        state = AsyncValue.data(s.copyWith(activeIndex: index));
        _repo.saveActiveIndex(index);
      }
    });
  }

  void setTarget(int target) {
    state.whenData((s) {
      final item = s.currentItem;
      final updatedItems = [...s.items];
      updatedItems[s.activeIndex] = item.copyWith(target: target);

      state = AsyncValue.data(s.copyWith(items: updatedItems));
      _repo.saveTasbihList(updatedItems);
    });
  }

  void toggleVibration() {
    state.whenData((s) {
      state = AsyncValue.data(s.copyWith(vibrateEnabled: !s.vibrateEnabled));
    });
  }
}

final tasbihProvider =
    StateNotifierProvider<TasbihNotifier, AsyncValue<TasbihState>>((ref) {
  return TasbihNotifier(ref.read(TasbihRepository.provider));
});
