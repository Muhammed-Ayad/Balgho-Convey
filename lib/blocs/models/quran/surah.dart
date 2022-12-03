import 'package:great_quran/blocs/models/quran/ayah.dart';
import 'package:json_annotation/json_annotation.dart';
part 'surah.g.dart';

@JsonSerializable()
class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final List<Ayah> ayahs;

  Surah(this.number, this.name, this.englishName, this.englishNameTranslation,
      this.revelationType, this.ayahs);
  factory Surah.fromJson(Map<String, dynamic> json) => _$SurahFromJson(json);

  Map<String, dynamic> toJson() => _$SurahToJson(this);
}
