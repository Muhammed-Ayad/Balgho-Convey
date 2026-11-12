class FeelingVerseModel {
  final String id;
  final String surahName;
  final int surahNumber;
  final int ayahNumber;
  final String ayahText;
  final String comfortMessage;
  final String? context;
  final List<String> tags;

  const FeelingVerseModel({
    required this.id,
    required this.surahName,
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahText,
    required this.comfortMessage,
    this.context,
    this.tags = const [],
  });

  String get audioUrl {
    final s = surahNumber.toString().padLeft(3, '0');
    final a = ayahNumber.toString().padLeft(3, '0');
    return 'https://everyayah.com/data/Husary_128kbps/$s$a.mp3';
  }

  factory FeelingVerseModel.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tags'];
    final List<String> parsedTags = rawTags is List
        ? rawTags.map((e) => e.toString()).toList()
        : const [];

    return FeelingVerseModel(
      id: json['id']?.toString() ?? '',
      surahName: json['surahName'] as String,
      surahNumber: json['surahNumber'] as int,
      ayahNumber: json['ayahNumber'] as int,
      ayahText: json['ayahText'] as String,
      comfortMessage: json['comfortMessage'] as String,
      context: json['context'] as String?,
      tags: parsedTags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surahName': surahName,
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'ayahText': ayahText,
      'comfortMessage': comfortMessage,
      if (context != null) 'context': context,
      if (tags.isNotEmpty) 'tags': tags,
    };
  }
}
