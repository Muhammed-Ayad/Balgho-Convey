class FeelingVerseModel {
  final int id;
  final String surahName;
  final int surahNumber;
  final int ayahNumber;
  final String ayahText;
  final String comfortMessage;

  const FeelingVerseModel({
    required this.id,
    required this.surahName,
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahText,
    required this.comfortMessage,
  });

  String get audioUrl {
    final s = surahNumber.toString().padLeft(3, '0');
    final a = ayahNumber.toString().padLeft(3, '0');
    return 'https://everyayah.com/data/Alafasy_128kbps/$s$a.mp3';
  }

  factory FeelingVerseModel.fromJson(Map<String, dynamic> json) {
    return FeelingVerseModel(
      id: json['id'] as int,
      surahName: json['surahName'] as String,
      surahNumber: json['surahNumber'] as int,
      ayahNumber: json['ayahNumber'] as int,
      ayahText: json['ayahText'] as String,
      comfortMessage: json['comfortMessage'] as String,
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
    };
  }
}
