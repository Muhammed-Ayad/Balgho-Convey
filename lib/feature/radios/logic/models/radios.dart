import 'package:great_quran/feature/radios/logic/models/radio.dart';

class Radios {
  final String title;
  final List<RadioDetalis> radio;

  const Radios(this.title, this.radio);

  factory Radios.fromJson(Map<String, dynamic> json) => Radios(
        json['title'] as String? ?? '',
        (json['radio'] as List<dynamic>?)
                ?.map((e) => RadioDetalis.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'radio': radio.map((e) => e.toJson()).toList(),
      };
}
