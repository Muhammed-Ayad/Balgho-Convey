class Azkar {
  final String category;
  final String count;
  final String description;
  final String reference;
  final String zekr;

  Azkar(
      {required this.category,
      required this.count,
      required this.description,
      required this.reference,
      required this.zekr});

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'count': count,
      'description': description,
      'reference': reference,
      'zekr': zekr,
    };
  }

  factory Azkar.fromJson(Map<String, dynamic> map) {
    return Azkar(
      category: map['category'] ?? '',
      count: map['count'] ?? '',
      description: map['description'] ?? '',
      reference: map['reference'] ?? '',
      zekr: map['zekr'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Azkar(category: $category, count: $count, description: $description, reference: $reference, zekr: $zekr)';
  }
}
