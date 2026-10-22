import 'dart:convert';
import 'package:great_quran/feature/habits/logic/models/habit_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IHabitsRepository {
  Future<DailyHabitsState> getDailyHabits();
  Future<void> toggleHabit(String habitId);
}

class HabitsRepository implements IHabitsRepository {
  static final provider = Provider<IHabitsRepository>((ref) {
    return HabitsRepository();
  });

  static const String _prefKeyHabitsPrefix = 'habits_day_';
  static const String _prefKeyStreak = 'habits_streak_count';
  static const String _prefKeyLastCompletedDate = 'habits_last_completed_date';

  static final List<HabitItem> _defaultHabits = [
    const HabitItem(
      id: 'sunnah_fajr',
      title: "سنة الفجر",
      description: "ركعتان قبل صلاة الصبح (خير من الدنيا وما فيها)",
      category: HabitCategory.sunan,
    ),
    const HabitItem(
      id: 'sunnah_dhuhr',
      title: "راتبة الظهر",
      description: "أربع ركعات قبل الظهر وركعتان بعدها",
      category: HabitCategory.sunan,
    ),
    const HabitItem(
      id: 'sunnah_maghrib',
      title: "راتبة المغرب",
      description: "ركعتان بعد صلاة المغرب",
      category: HabitCategory.sunan,
    ),
    const HabitItem(
      id: 'sunnah_isha',
      title: "راتبة العشاء",
      description: "ركعتان بعد صلاة العشاء",
      category: HabitCategory.sunan,
    ),
    const HabitItem(
      id: 'sunnah_witr',
      title: "صلاة الوتر",
      description: "ختام صلاة الليل (أوتروا يا أهل القرآن)",
      category: HabitCategory.sunan,
    ),
    const HabitItem(
      id: 'sunnah_duha',
      title: "صلاة الضحى",
      description: "صلاة الأوابين (ركعتان تجزئ عن صدقة مفاصل الجسد)",
      category: HabitCategory.sunan,
    ),
    const HabitItem(
      id: 'azkar_sabah',
      title: "أذكار الصباح",
      description:
          "من قال: «بسم الله الذي لا يضر مع اسمه شيء...» ثلاثاً لم يضره شيء [أبو داود والترمذي]",
      category: HabitCategory.azkar,
    ),
    const HabitItem(
      id: 'azkar_masaa',
      title: "أذكار المساء",
      description: "سكينة وحفظ لليلتك امتثالاً للتوجيه النبوي الشريف",
      category: HabitCategory.azkar,
    ),
    const HabitItem(
      id: 'azkar_istighfar',
      title: "الاستغفار (100 مرة)",
      description:
          "اقتداءً بفعله ﷺ [صحيح مسلم: 2702]، وتطبيقاً لوعد الله: ﴿اسْتَغْفِرُوا رَبَّكُمْ إِنَّهُ كَانَ غَفَّارًا * يُرْسِلِ السَّمَاءَ عَلَيْكُم مِّدْرَارًا﴾ [نوح: 10-11]",
      category: HabitCategory.azkar,
    ),
    const HabitItem(
      id: 'azkar_salat_nabi',
      title: "الصلاة على النبي (100 مرة)",
      description: "يُكفى همك ويُغفر ذنبك وتُصلي عليك الملائكة",
      category: HabitCategory.azkar,
    ),
    const HabitItem(
      id: 'quran_wird',
      title: "الورد القرآني اليومي",
      description: "تلاوة وتدبر لصفحات مباركة من كتاب الله",
      category: HabitCategory.quran,
    ),
    const HabitItem(
      id: 'fasting_sunnah',
      title: "صيام مستحب",
      description: "صيام الاثنين أو الخميس أو الأيام البيض لمن استطاع",
      category: HabitCategory.fasting,
    ),
  ];

  String _getTodayKey() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Future<DailyHabitsState> getDailyHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = _getTodayKey();
    final savedJson = prefs.getString('$_prefKeyHabitsPrefix$todayKey');

    List<HabitItem> habits;
    if (savedJson != null && savedJson.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(savedJson);
      final savedMap = {for (var it in decoded) it['id']: it['isCompleted']};
      habits = _defaultHabits.map((def) {
        return def.copyWith(
          isCompleted: savedMap[def.id] as bool? ?? false,
        );
      }).toList();
    } else {
      habits = _defaultHabits;
    }

    final streak = prefs.getInt(_prefKeyStreak) ?? 0;
    return DailyHabitsState(
      dateKey: todayKey,
      habits: habits,
      streakDays: streak,
    );
  }

  @override
  Future<void> toggleHabit(String habitId) async {
    final prefs = await SharedPreferences.getInstance();
    final todayState = await getDailyHabits();
    final todayKey = _getTodayKey();

    final updatedHabits = todayState.habits.map((item) {
      if (item.id == habitId) {
        return item.copyWith(isCompleted: !item.isCompleted);
      }
      return item;
    }).toList();

    final encoded = jsonEncode(updatedHabits.map((h) => h.toJson()).toList());
    await prefs.setString('$_prefKeyHabitsPrefix$todayKey', encoded);

    // تحديث سلسلة الأيام المتتالية (Streak) إذا تجاوزت النسبة 50%
    final completed = updatedHabits.where((h) => h.isCompleted).length;
    if (completed >= 5) {
      final lastDate = prefs.getString(_prefKeyLastCompletedDate);
      if (lastDate != todayKey) {
        final currentStreak = prefs.getInt(_prefKeyStreak) ?? 0;
        await prefs.setInt(_prefKeyStreak, currentStreak + 1);
        await prefs.setString(_prefKeyLastCompletedDate, todayKey);
      }
    }
  }
}
