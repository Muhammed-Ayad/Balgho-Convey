class Nawawi {
  final String hadith;
  final String description;
  final String title;

  const Nawawi(this.hadith, this.description, this.title);

  factory Nawawi.fromJson(Map<String, dynamic> json) => Nawawi(
        json['hadith'] as String? ?? '',
        json['description'] as String? ?? '',
        json['title'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'hadith': hadith,
        'description': description,
        'title': title,
      };
}
