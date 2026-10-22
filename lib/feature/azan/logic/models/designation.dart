class Designation {
  final String abbreviated;
  final String expanded;

  const Designation(this.abbreviated, this.expanded);

  factory Designation.fromJson(Map<String, dynamic> json) => Designation(
        json['abbreviated'] as String? ?? '',
        json['expanded'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'abbreviated': abbreviated,
        'expanded': expanded,
      };
}
