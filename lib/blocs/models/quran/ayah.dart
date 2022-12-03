import 'package:json_annotation/json_annotation.dart';
part 'ayah.g.dart';

@JsonSerializable()
class Ayah  {
  final int number;
  final String text;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;

  Ayah(this.number, this.text, this.numberInSurah, this.juz, this.manzil, this.page, this.ruku, this.hizbQuarter);

  factory Ayah.fromJson(Map<String, dynamic> json) =>
      _$AyahFromJson(json);

  Map<String, dynamic> toJson() => _$AyahToJson(this);
}
