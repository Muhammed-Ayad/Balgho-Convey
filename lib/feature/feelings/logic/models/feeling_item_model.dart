import 'package:great_quran/feature/feelings/logic/models/feeling_verse_model.dart';

class FeelingItemModel {
  final String id;
  final String title;
  final String icon;
  final List<FeelingVerseModel> verses;

  const FeelingItemModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.verses,
  });

  int get versesCount => verses.length;

  factory FeelingItemModel.fromJson(Map<String, dynamic> json) {
    final versesList = (json['verses'] as List<dynamic>?)
            ?.map((v) => FeelingVerseModel.fromJson(v as Map<String, dynamic>))
            .toList() ??
        const [];
    return FeelingItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      verses: versesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'verses': verses.map((v) => v.toJson()).toList(),
    };
  }
}
