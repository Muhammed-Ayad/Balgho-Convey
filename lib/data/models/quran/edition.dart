import 'package:equatable/equatable.dart';

class Edition extends Equatable {
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String format;
  final String type;

  const Edition({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
  });

  @override
  List<Object> get props {
    return [
      identifier,
      language,
      name,
      englishName,
      format,
      type,
    ];
  }

  @override
  String toString() {
    return 'Edition(identifier: $identifier, language: $language, name: $name, englishName: $englishName, format: $format, type: $type)';
  }

  factory Edition.fromJson(Map<String, dynamic> json) {
    return Edition(
      identifier: json['identifier'],
      language: json['language'],
      name: json['name'],
      englishName: json['englishName'],
      format: json['format'],
      type: json['type'],
    );
  }
}
