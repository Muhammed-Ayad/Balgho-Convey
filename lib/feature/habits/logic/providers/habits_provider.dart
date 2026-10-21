import 'package:flutter/services.dart';
import 'package:great_quran/feature/habits/logic/models/habit_item.dart';
import 'package:great_quran/feature/habits/logic/repo/habits_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DailyHabitsNotifier extends StateNotifier<AsyncValue<DailyHabitsState>> {
  static final provider =
      StateNotifierProvider<DailyHabitsNotifier, AsyncValue<DailyHabitsState>>(
          (ref) {
    return DailyHabitsNotifier(ref.read(HabitsRepository.provider));
  });

  final IHabitsRepository _repository;

  DailyHabitsNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchHabits();
  }

  Future<void> fetchHabits() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getDailyHabits());
  }

  Future<void> toggleHabit(String habitId) async {
    HapticFeedback.lightImpact();
    await _repository.toggleHabit(habitId);
    state = await AsyncValue.guard(() => _repository.getDailyHabits());
  }
}
