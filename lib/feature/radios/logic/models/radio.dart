class RadioDetalis {
  final String name;
  final String url;

  const RadioDetalis(this.name, this.url);

  factory RadioDetalis.fromJson(Map<String, dynamic> json) => RadioDetalis(
        json['name'] as String? ?? '',
        json['url'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
      };
}
