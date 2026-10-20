import 'package:great_quran/feature/azkar/logic/data/azkar_list.dart';
import 'package:great_quran/feature/azkar/logic/models/azkar.dart';

class AzkarByCategory {
  final List<Azkar> _azkarList = [];

  getAzkarByCategory(String category) {
    return azkarDB
        .where(
          (element) => element.containsValue(category),
        )
        .forEach(
          (element) => _azkarList.add(
            Azkar.fromJson(element),
          ),
        );
  }

  List<Azkar> get azkarList => _azkarList;
}
