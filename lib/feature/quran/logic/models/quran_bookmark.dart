class QuranBookmark {
  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final DateTime updatedAt;

  const QuranBookmark({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'surahName': surahName,
        'ayahNumber': ayahNumber,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory QuranBookmark.fromJson(Map<String, dynamic> json) {
    return QuranBookmark(
      surahNumber: json['surahNumber'] as int? ?? 1,
      surahName: json['surahName'] as String? ?? 'الفاتحة',
      ayahNumber: json['ayahNumber'] as int? ?? 1,
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
