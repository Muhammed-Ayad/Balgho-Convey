import 'package:great_quran/feature/quran/logic/models/ayah.dart';

class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final List<Ayah> ayahs;

  const Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    final rawAyahs = json['ayahs'] as List<dynamic>? ?? [];
    return Surah(
      number: json['number'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      englishNameTranslation: json['englishNameTranslation'] as String,
      revelationType: json['revelationType'] as String,
      ayahs: rawAyahs
          .map((a) => Ayah.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }

  bool get isMeccan => revelationType.toLowerCase() == 'meccan';
  int get ayahCount => ayahs.length;

  /// Returns the Juz number where the Surah begins
  int get startingJuz => ayahs.isNotEmpty ? ayahs.first.juz : 1;

  /// Returns the Page number where the Surah begins
  int get startingPage => ayahs.isNotEmpty ? ayahs.first.page : 1;
}
