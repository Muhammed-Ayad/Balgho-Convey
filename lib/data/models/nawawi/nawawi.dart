class Nawawi {
  final String description;
  final String hadith;
  Nawawi({
    required this.description,
    required this.hadith,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'hadith': hadith,
    };
  }

  factory Nawawi.fromJson(Map<String, dynamic> map) {
    return Nawawi(
      description: map['description'] ?? '',
      hadith: map['hadith'] ?? '',
    );
  }
}
