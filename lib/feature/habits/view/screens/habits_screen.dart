import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/habits/logic/models/habit_item.dart';
import 'package:great_quran/feature/habits/logic/providers/habits_provider.dart';
import 'package:great_quran/feature/habits/view/widgets/habit_progress_card.dart';
import 'package:great_quran/feature/habits/view/widgets/habit_tile_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(DailyHabitsNotifier.provider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "سجل الورد والعبادات اليومية",
      ),
      body: state.when(
        data: (habitsState) {
          final habitsByCategory = <HabitCategory, List<HabitItem>>{};
          for (final habit in habitsState.habits) {
            habitsByCategory.putIfAbsent(habit.category, () => []).add(habit);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: D.sizeXXLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HabitProgressCardWidget(state: habitsState),
                ...HabitCategory.values.map((category) {
                  final list = habitsByCategory[category] ?? [];
                  if (list.isEmpty) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HabitCategoryHeaderWidget(title: category.title),
                      ...list.map((habit) {
                        return HabitTileWidget(
                          habit: habit,
                          onToggle: () {
                            ref
                                .read(DailyHabitsNotifier.provider.notifier)
                                .toggleHabit(habit.id);
                          },
                        );
                      }),
                      const SizedBox(height: D.sizeSmall),
                    ],
                  );
                }),
              ],
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (err, stack) => CustomErrorWidget(
          errorMsg: err.toString(),
          onRefresh: () {
            ref.read(DailyHabitsNotifier.provider.notifier).fetchHabits();
          },
        ),
      ),
    );
  }
}

class HabitCategoryHeaderWidget extends StatelessWidget {
  final String title;

  const HabitCategoryHeaderWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeLarge,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }
}
