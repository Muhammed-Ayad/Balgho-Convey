import 'package:great_quran/feature/azkar/logic/data/all_azkar.dart';
import 'package:great_quran/feature/azkar/logic/data/azkar_by_category.dart';
import 'package:great_quran/feature/azkar/logic/models/azkar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class IAzkarRepository {
  List<String> getCategories();
  List<Azkar> getAzkarByCategory(String category);
}

class AzkarRepository implements IAzkarRepository {
  static final provider =
      Provider<IAzkarRepository>((ref) => AzkarRepository());

  @override
  List<String> getCategories() {
    return azkarDataList.map((e) => e.toString()).toList();
  }

  @override
  List<Azkar> getAzkarByCategory(String category) {
    final azkarByCategory = AzkarByCategory();
    azkarByCategory.getAzkarByCategory(category);
    return azkarByCategory.azkarList;
  }
}
