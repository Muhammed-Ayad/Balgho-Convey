import 'package:great_quran/feature/azkar/logic/data/all_azkar.dart';

enum AzkarSection {
  all("الكل"),
  daily("اليوم والليلة"),
  prayer("الصلاة والمسجد"),
  supplications("أدعية ومناسبات"),
  ruqyah("الرقية الشرعية");

  final String title;
  const AzkarSection(this.title);
}

class AzkarFilterHelper {
  static const Set<String> _dailyTitles = {
    "أذكار الصباح",
    "أذكار المساء",
    "أذكار الاستيقاظ من النوم",
    "الدعاء إذا تقلب في الليل",
    "دعاء الفزع في النوم و من بلي بالوحشة",
    "ما يفعل من رأى الرؤيا أو الحلم في النوم",
  };

  static const Set<String> _prayerTitles = {
    "الذكر قبل الوضوء",
    "الذكر بعد الفراغ من الوضوء",
    "دعاء الذهاب إلى المسجد",
    "دعاء دخول المسجد",
    "دعاء الخروج من المسجد",
    "أذكار الآذان",
    "دعاء الاستفتاح",
    "دعاء الركوع",
    "دعاء الرفع من الركوع",
    "دعاء السجود",
    "دعاء الجلسة بين السجدتين",
    "دعاء سجود التلاوة",
    "التشهد",
    "الصلاة على النبي بعد التشهد",
    "الدعاء بعد التشهد الأخير قبل السلام",
    "دعاء صلاة الاستخارة",
    "دعاء الوسوسة في الصلاة و القراءة",
    "فضل الصلاة على النبي صلى الله عليه و سلم",
    "كيف كان النبي يسبح؟",
  };

  static const Set<String> _ruqyahTitles = {
    "ما يعوذ به الأولاد - رقية",
    "الرُّقية الشرعية من القرآن الكريم",
    "الرُّقية الشرعية من السنة النبوية",
    "دعاء طرد الشيطان و وساوسه",
    "دعاء من خشي أن يصيب شيئا بعينه",
    "دعاء الخوف من الشرك",
    "الاستغفار و التوبة",
  };

  static List<String> filter({
    required AzkarSection section,
    required String searchQuery,
  }) {
    List<String> list;

    switch (section) {
      case AzkarSection.all:
        list = azkarDataList;
        break;
      case AzkarSection.daily:
        list =
            azkarDataList.where((item) => _dailyTitles.contains(item)).toList();
        break;
      case AzkarSection.prayer:
        list = azkarDataList
            .where((item) => _prayerTitles.contains(item))
            .toList();
        break;
      case AzkarSection.ruqyah:
        list = azkarDataList
            .where((item) => _ruqyahTitles.contains(item))
            .toList();
        break;
      case AzkarSection.supplications:
        list = azkarDataList.where((item) {
          return !_dailyTitles.contains(item) &&
              !_prayerTitles.contains(item) &&
              !_ruqyahTitles.contains(item);
        }).toList();
        break;
    }

    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return list;
    }

    return list.where((item) {
      final normalizedItem = item.toLowerCase();
      return normalizedItem.contains(query);
    }).toList();
  }
}
