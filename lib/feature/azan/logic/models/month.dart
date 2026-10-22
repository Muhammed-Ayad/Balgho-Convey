class Month {
  final int number;
  final String en;

  const Month(this.number, this.en);

  factory Month.fromJson(Map<String, dynamic> json) => Month(
        (json['number'] as num?)?.toInt() ?? 0,
        json['en'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'number': number,
        'en': en,
      };
}
