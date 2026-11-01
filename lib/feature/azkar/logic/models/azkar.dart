class Azkar {
  final String category;
  final String count;
  final String description;
  final String reference;
  final String zekr;

  const Azkar(
    this.category,
    this.count,
    this.description,
    this.reference,
    this.zekr,
  );

  factory Azkar.fromJson(Map<String, dynamic> json) => Azkar(
        json['category'] as String? ?? '',
        json['count'] as String? ?? '',
        json['description'] as String? ?? '',
        json['reference'] as String? ?? '',
        json['zekr'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'count': count,
        'description': description,
        'reference': reference,
        'zekr': zekr,
      };
}
