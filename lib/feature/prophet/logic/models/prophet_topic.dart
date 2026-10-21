class ProphetTopic {
  final String id;
  final String category;
  final String title;
  final String subtitle;
  final String summary;
  final String content;
  final List<String> quranVerses;
  final List<String> hadiths;
  final List<String> sources;
  final List<String> keyPoints;

  const ProphetTopic({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.content,
    this.quranVerses = const [],
    this.hadiths = const [],
    required this.sources,
    this.keyPoints = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'title': title,
        'subtitle': subtitle,
        'summary': summary,
        'content': content,
        'quranVerses': quranVerses,
        'hadiths': hadiths,
        'sources': sources,
        'keyPoints': keyPoints,
      };

  factory ProphetTopic.fromJson(Map<String, dynamic> json) => ProphetTopic(
        id: json['id'] as String,
        category: json['category'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        summary: json['summary'] as String,
        content: json['content'] as String,
        quranVerses: (json['quranVerses'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        hadiths: (json['hadiths'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        sources:
            (json['sources'] as List<dynamic>).map((e) => e as String).toList(),
        keyPoints: (json['keyPoints'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
      );
}
