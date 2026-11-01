class Weekday {
  final String en;
  final String ar;

  const Weekday(this.en, this.ar);

  factory Weekday.fromJson(Map<String, dynamic> json) => Weekday(
        json['en'] as String? ?? '',
        json['ar'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'en': en,
        'ar': ar,
      };
}
