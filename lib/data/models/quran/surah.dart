import 'package:equatable/equatable.dart';

import 'ayah.dart';

class Surah extends Equatable {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final List<Ayah> ayah;

  const Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayah,
  });

  @override
  List<Object> get props {
    return [
      number,
      name,
      englishName,
      englishNameTranslation,
      revelationType,
      ayah,
    ];
  }

  factory Surah.initial() {
    return const Surah(
        number: 0,
        name: '',
        englishName: '',
        englishNameTranslation: '',
        revelationType: '',
        ayah: []);
  }

  @override
  String toString() {
    return 'Surah(number: $number, name: $name, englishName: $englishName, englishNameTranslation: $englishNameTranslation, revelationType: $revelationType,ayah $ayah)';
  }

  factory Surah.fromJson(Map<String, dynamic> json) {
    Iterable ayahs = json['ayahs'];
    List<Ayah> ayahsList = ayahs.map((e) => Ayah.fromJson((e))).toList();
    return Surah(
      number: json['number'],
      name: json['name'].toString(),
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      ayah: ayahsList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'revelationType': revelationType,
      'ayah': ayah.asMap(),
    };
  }
}
