enum HabitCategory {
  sunan("السنن الرواتب والنوافل"),
  azkar("أذكار اليوم والليلة"),
  quran("الورد القرآني"),
  fasting("الصيام المستحب");

  final String title;
  const HabitCategory(this.title);
}

class HabitItem {
  final String id;
  final String title;
  final String description;
  final HabitCategory category;
  final bool isCompleted;

  const HabitItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.isCompleted = false,
  });

  HabitItem copyWith({
    String? id,
    String? title,
    String? description,
    HabitCategory? category,
    bool? isCompleted,
  }) {
    return HabitItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category.name,
        'isCompleted': isCompleted,
      };

  factory HabitItem.fromJson(Map<String, dynamic> json) => HabitItem(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        category: HabitCategory.values.firstWhere(
          (c) => c.name == json['category'],
          orElse: () => HabitCategory.sunan,
        ),
        isCompleted: json['isCompleted'] as bool? ?? false,
      );
}

class DailyHabitsState {
  final String dateKey;
  final List<HabitItem> habits;
  final int streakDays;

  const DailyHabitsState({
    required this.dateKey,
    required this.habits,
    this.streakDays = 0,
  });

  int get completedCount => habits.where((h) => h.isCompleted).length;
  int get totalCount => habits.length;
  double get progress => totalCount > 0 ? completedCount / totalCount : 0.0;
  int get percentage => (progress * 100).round();
}
