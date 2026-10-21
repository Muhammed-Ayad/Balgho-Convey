import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/habits/logic/repo/habits_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('HabitsRepository tests', () {
    test('Initializes with default daily habits', () async {
      final repo = HabitsRepository();
      final state = await repo.getDailyHabits();

      expect(state.habits.isNotEmpty, true);
      expect(state.completedCount, 0);
      expect(state.progress, 0.0);
    });

    test('Toggling habit updates status and completion count', () async {
      final repo = HabitsRepository();
      final initial = await repo.getDailyHabits();
      final targetId = initial.habits.first.id;

      await repo.toggleHabit(targetId);
      final updated = await repo.getDailyHabits();

      expect(updated.completedCount, 1);
      final item = updated.habits.firstWhere((h) => h.id == targetId);
      expect(item.isCompleted, true);

      // Toggle back
      await repo.toggleHabit(targetId);
      final toggledBack = await repo.getDailyHabits();
      expect(toggledBack.completedCount, 0);
    });
  });
}
