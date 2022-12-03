import 'package:great_quran/blocs/models/azkar/azkar.dart';

import 'azkar_list.dart';

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
