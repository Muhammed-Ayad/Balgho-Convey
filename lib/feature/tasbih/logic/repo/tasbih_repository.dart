import 'dart:convert';
import 'package:great_quran/feature/tasbih/logic/models/tasbih_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ITasbihRepository {
  Future<List<TasbihItem>> getTasbihList();
  Future<void> saveTasbihList(List<TasbihItem> items);
  Future<int> getActiveIndex();
  Future<void> saveActiveIndex(int index);
}

class TasbihRepository implements ITasbihRepository {
  static final provider = Provider<ITasbihRepository>((ref) {
    return TasbihRepository();
  });

  static const String _listKey = 'tasbih_items_list_key';
  static const String _activeKey = 'tasbih_active_index_key';

  static const List<TasbihItem> defaultItems = [
    TasbihItem(
      id: 0,
      title: "سُبْحَانَ اللَّهِ",
      fadl: "كلمتان خفيفتان على اللسان ثقيلتان في الميزان",
      target: 33,
    ),
    TasbihItem(
      id: 1,
      title: "الْحَمْدُ لِلَّهِ",
      fadl: "الحمد لله تملأ الميزان",
      target: 33,
    ),
    TasbihItem(
      id: 2,
      title: "لَا إِلَهَ إِلَّا اللَّهُ",
      fadl: "أفضل الذكر لا إله إلا الله",
      target: 33,
    ),
    TasbihItem(
      id: 3,
      title: "اللَّهُ أَكْبَرُ",
      fadl: "أحب الكلام إلى الله أربع",
      target: 33,
    ),
    TasbihItem(
      id: 4,
      title: "أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ",
      fadl: "من لزم الاستغفار جعل الله له من كل هم فرجاً",
      target: 100,
    ),
    TasbihItem(
      id: 5,
      title: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
      fadl: "كنز من كنوز الجنة",
      target: 33,
    ),
    TasbihItem(
      id: 6,
      title: "اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ",
      fadl: "من صلى عليّ صلاة صلى الله عليه بها عشراً",
      target: 100,
    ),
    TasbihItem(
      id: 7,
      title: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ",
      fadl: "حبيبتان إلى الرحمن",
      target: 100,
    ),
  ];

  @override
  Future<List<TasbihItem>> getTasbihList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_listKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded
            .map((item) => TasbihItem.fromMap(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return defaultItems;
  }

  @override
  Future<void> saveTasbihList(List<TasbihItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(items.map((e) => e.toMap()).toList());
      await prefs.setString(_listKey, encoded);
    } catch (_) {}
  }

  @override
  Future<int> getActiveIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_activeKey) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  @override
  Future<void> saveActiveIndex(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_activeKey, index);
    } catch (_) {}
  }
}
